//
//  ArticleViewController.swift
//  DOUCalendar
//
//  Created by Anton Skomarovskyi on 7/31/19.
//  Copyright © 2019 Anton Skomarovskyi. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var MainImageView: UIImageView!
    
    @IBOutlet weak var MainTitleLabel: UILabel!
    
    @IBOutlet weak var TextView: UITextView!
    
    var articleModel : ArticleModel!
    
    var extendedArticleModel : ExtendedArticleModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainImageView.layer.shadowColor = UIColor.black.cgColor
        MainImageView.layer.shadowRadius = 3
        MainImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        MainImageView.layer.shadowOpacity = 3
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    public func updateUI() {
        MainTitleLabel.text = articleModel.title
        MainImageView.sd_setImage(with: extendedArticleModel.imageURL)
        TextView.text = extendedArticleModel.fullDescription
        
        title = MainTitleLabel.text
    }
}
