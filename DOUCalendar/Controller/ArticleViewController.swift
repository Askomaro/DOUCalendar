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
        
    }
    
    public func updateUI() {
        MainTitleLabel.text = articleModel.title
        MainImageView.sd_setImage(with: extendedArticleModel.imageURL)
        TextView.text = extendedArticleModel.fullDescription
        
        MainImageView.layer.cornerRadius = 5
    }

//  MARK: - Navigation
//  In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
        
//    }

}
