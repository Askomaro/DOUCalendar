//
//  ArticleTableViewCell.swift
//  DOUCalendar
//
//  Created by Anton Skomarovskyi on 7/29/19.
//  Copyright © 2019 Anton Skomarovskyi. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var spaceConstant : CGFloat  = 0
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var mainLabelTitle : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    var infoLabel : UILabel = {
        var infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        
        return infoLabel
    }()
    
    var textView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainImageView)
        self.addSubview(mainLabelTitle)
        self.addSubview(infoLabel)
        self.addSubview(textView)
    }
    
    override func layoutSubviews() {
        mainImageView.layer.cornerRadius = 5
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spaceConstant).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: spaceConstant).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spaceConstant).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 120 ).isActive = true
        
        mainLabelTitle.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: spaceConstant).isActive = true
        mainLabelTitle.topAnchor.constraint(equalTo: self.mainImageView.topAnchor).isActive = true
        mainLabelTitle.rightAnchor.constraint(equalTo: self.infoLabel.leftAnchor, constant: -spaceConstant).isActive = true
        mainLabelTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        textView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: spaceConstant).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.mainLabelTitle.bottomAnchor, constant: spaceConstant).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spaceConstant).isActive = true
        
        infoLabel.leftAnchor.constraint(equalTo: self.mainLabelTitle.rightAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: self.textView.topAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spaceConstant).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
