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
    
    private var articlesModel : [ArticleModel] = []
    
    private let articleRetriever : ArticleRetriever = ArticleRetriever()
    
    private let notification = UISelectionFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        SVProgressHUD.show()
        
        self.tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articelTableViewCell")

        updateUI()
        
        configureRefreshControl()
    }

    private func updateUI(){
        //      Make async http call to dou calendar and map to ArticlesModel
        //      after it finished then call closure where set ArticlesModel and reload tableView
        //      DispatchQueue.main.async ???
        articleRetriever.getArticlesModel{
            SVProgressHUD.dismiss()
            
            self.articlesModel = $0
            
            self.articleTableView.reloadData()
        }
    }
    
    private func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:#selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        updateUI()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.notification.selectionChanged()
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
