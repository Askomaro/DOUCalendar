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

class ViewController: UITableViewController {
    @IBOutlet var articleTableView: UITableView!
    
    var articlesModel : [Article] = []
    let articleRetriever : ArticleRetriever = ArticleRetriever()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Make async http call to dou calendar and map to ArticlesModel
//      after it finished then call closure where set ArticlesModel and reload tableView
//      DispatchQueue.main.async ???
        articleRetriever.getArticlesModel{
            self.articlesModel = $0
            
            self.articleTableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.articlesModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articleTableView.dequeueReusableCell(withIdentifier: "ArticleItemCell", for: indexPath)
        
        cell.textLabel?.text = self.articlesModel[indexPath.row].title
        
        return cell
    }
}
