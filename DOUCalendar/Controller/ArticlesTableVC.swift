//
//  ViewController.swift
//  DOUCalendar
//
//  Created by Anton Skomarovskyi on 7/24/19.
//  Copyright © 2019 Anton Skomarovskyi. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import SDWebImage
import SVProgressHUD

class ArticlesTableVC: UITableViewController {
    @IBOutlet var articleTableView: UITableView!
    
    var articlesModel : [ArticleModel] = []
    let articleRetriever : ArticleRetriever = ArticleRetriever()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        SVProgressHUD.show()
        
        self.tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articelTableViewCell")

//      Make async http call to dou calendar and map to ArticlesModel
//      after it finished then call closure where set ArticlesModel and reload tableView
//      DispatchQueue.main.async ???
        articleRetriever.getArticlesModel{
            SVProgressHUD.dismiss()
            
            self.articlesModel = $0
            
            self.articleTableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articlesModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articelTableViewCell") as! ArticleTableViewCell
        
        cell.mainLabelTitle.text = articlesModel[indexPath.row].title
        cell.infoLabel.text = "\(articlesModel[indexPath.row].date)\t\(articlesModel[indexPath.row].city)\t\(articlesModel[indexPath.row].cost)"
        cell.mainImageView.sd_setImage(with : articlesModel[indexPath.row].imageURL)
        cell.textView.text = articlesModel[indexPath.row].description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleViewController
        let selectedArticleModel = articlesModel[tableView.indexPathForSelectedRow!.row]
        
        destinationVC.articleModel = selectedArticleModel
//        destinationVC.MainImageView.sd_setImage(with : selectedArticleModel.imageURL)
        
        // Just retrieve full article description
        articleRetriever.getExtendedArticleModel(url: selectedArticleModel.extendedArticleUrl, completionHandler: {
            SVProgressHUD.dismiss()

            destinationVC.extendedArticleModel = $0
            
            destinationVC.updateUI()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
