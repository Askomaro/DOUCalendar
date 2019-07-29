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
    
    func getArticlesModel(completionHandler: @escaping ([Article]) -> Void) -> Void {
        
        request(douCalendarUrl, method: .get).responseString{ response in
            switch response.result {
                case .success(let value):
                    let articlesModel = self.parseDOUHTML(html: value)
                    
                    completionHandler(articlesModel)
                
                case .failure(let error):
                    fatalError("Error while querying database: \(String(describing: error))")
                
            }
            
        }
    }
    
    private func parseDOUHTML(html: String) -> [Article] {
        
        var articlesModel : [Article] = []
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for article in doc.css("article"){
                
                guard let articleTitleWE = article.at_xpath("h2[contains(@class, 'title')]") else
                { fatalError("Cannot find h2 web element with a title for an article.") }
                let articleTitle = articleTitleWE.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let articleImageUrl = articleTitleWE.at_xpath("//img/@src") else
                { fatalError("Cannot find imageUrl for an article.") }
                
                guard let articleDetailesWE = article.at_xpath("div[contains(@class, 'when-and-where')]") else
                { fatalError("Cannot find div web element with a where and when detailes.") }
                let data = articleDetailesWE.text!.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")

                articlesModel.append(Article(
                    title: articleTitle,
                    city: String(data[1]),
                    date: String(data[0].trimmingCharacters(in: .whitespacesAndNewlines)),
                    cost: String(data.last!.trimmingCharacters(in: .whitespacesAndNewlines)),
                    imageURL: URL(string: articleImageUrl.text!)!))
            }
            
        }
        
        return articlesModel
    }
}
