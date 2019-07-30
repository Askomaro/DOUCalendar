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

class ViewController: UITableViewController {
    @IBOutlet var articleTableView: UITableView!
    
    var articlesModel : [Article] = []
    let articleRetriever : ArticleRetriever = ArticleRetriever()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articelTableViewCell")
        
//      Make async http call to dou calendar and map to ArticlesModel
//      after it finished then call closure where set ArticlesModel and reload tableView
//      DispatchQueue.main.async ???
        articleRetriever.getArticlesModel{
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
        cell.infoLabel.text = articlesModel[indexPath.row].city
        cell.mainImageView.sd_setImage(with : articlesModel[indexPath.row].imageURL)
        cell.textView.text = articlesModel[indexPath.row].description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
