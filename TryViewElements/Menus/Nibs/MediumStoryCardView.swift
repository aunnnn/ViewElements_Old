//
//  MediumStoryCardView.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElements

class MediumStoryCardView: BaseNibView, OptionalTypedPropsAccessible {
    
    typealias PropsType = (title: String, author: String, hearts: Int, responses: Int, image: UIImage)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var heartsLabel: UILabel!
    
    @IBOutlet weak var responsesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func setup() {
        super.setup()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        authorLabel.textColor = MediumTheme.green
        heartsLabel.textColor = .gray
        responsesLabel.textColor = .gray
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        [authorLabel, heartsLabel, responsesLabel].forEach { (lb) in
            lb.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    override func update() {
        super.update()
        self.imageView.image = props?.image
        self.authorLabel.text = props?.author
        self.titleLabel.text = props?.title
        
        let heart = props?.hearts ?? 0
        let response = props?.responses ?? 0
        if heart != 0 {
            self.heartsLabel.text = "H \(heart)"
            self.heartsLabel.isHidden = false
        } else {
            self.heartsLabel.isHidden = true
        }
        
        if response != 0 {
            self.responsesLabel.text = "R \(response)"
            self.responsesLabel.isHidden = false
        } else {
            self.responsesLabel.isHidden = true
        }
    }
    
    override static func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
