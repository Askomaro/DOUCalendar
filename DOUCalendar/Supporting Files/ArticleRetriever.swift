//
//  ArticleRetriever.swift
//  DOUCalendar
//
//  Created by Anton Skomarovskyi on 7/29/19.
//  Copyright © 2019 Anton Skomarovskyi. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import SDWebImage

class ArticleRetriever {
    let douCalendarUrl : String = "https://dou.ua/calendar"

    init() {}
    
    func getArticlesModel(completionHandler: @escaping ([ArticleModel]) -> Void) -> Void {
        
        request(douCalendarUrl, method: .get).responseString{ response in
            switch response.result {
                case .success(let value):
                    let articlesModel = self.parseArticlesDOM(html: value)
                    
                    completionHandler(articlesModel)
                
                case .failure(let error):
                    fatalError("Error while querying database: \(String(describing: error))")
                
            }
            
        }
    }
    
    func getExtendedArticleModel(url : URL, completionHandler: @escaping (ExtendedArticleModel) -> Void) -> Void {
        
        request(url, method: .get).responseString{ response in
            switch response.result {
            case .success(let value):
                let extendedArticleModel = self.parseConcreteArticleDOM(html: value)
                
                completionHandler(extendedArticleModel)
                
            case .failure(let error):
                fatalError("Error while querying database: \(String(describing: error))")
                
            }
        }
    }
    
    
    private func parseConcreteArticleDOM(html: String) -> ExtendedArticleModel {
        var extendedArticleModel : ExtendedArticleModel?
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let articleWE = doc.css("article").first
            
            guard let description = articleWE?.content else
            { fatalError("There is no article content found") }
            
            guard let articleImageUrl = doc.at_xpath("//img[contains(@class, 'event-info-logo')]/@src") else
            { fatalError("Cannot find imageUrl for an article.") }
            
            extendedArticleModel = ExtendedArticleModel(imageURL: URL(string: articleImageUrl.text!)!, fullDescription: description.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return extendedArticleModel!
    }

    
    private func parseArticlesDOM(html: String) -> [ArticleModel] {
        
        var articlesModel : [ArticleModel] = []
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for article in doc.css("article"){
                
                guard let articleTitleWE = article.at_xpath("h2[contains(@class, 'title')]") else
                { fatalError("Cannot find h2 web element with a title for an article.") }
                let articleTitle = articleTitleWE.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let articleFullDescriptionUrl = articleTitleWE.at_xpath("a/@href") else
                { fatalError("Cannot find article href for an article.") }
                
                guard let articleImageUrl = articleTitleWE.at_xpath("a/img/@src") else
                { fatalError("Cannot find imageUrl for an article.") }
                
                guard let articleDetailesWE = article.at_xpath("div[contains(@class, 'when-and-where')]") else
                { fatalError("Cannot find div web element with a 'where and when' detailes.") }
                let data = articleDetailesWE.text!.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")

                guard let articleDescription = article.at_xpath("p[contains(@class, 'b-typo')]") else
                { fatalError("Cannot find article description web element.") }
                
                articlesModel.append(ArticleModel(
                    title: articleTitle,
                    city: String(data[1].trimmingCharacters(in: .whitespacesAndNewlines)),
                    date: String(data[0].trimmingCharacters(in: .whitespacesAndNewlines)),
                    cost: String(data.last!.trimmingCharacters(in: .whitespacesAndNewlines)),
                    imageURL: URL(string: articleImageUrl.text!)!,
                    description: articleDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                    extendedArticleUrl: URL(string: articleFullDescriptionUrl.text!)!))
            }
            
        }
        
        return articlesModel
    }
}

