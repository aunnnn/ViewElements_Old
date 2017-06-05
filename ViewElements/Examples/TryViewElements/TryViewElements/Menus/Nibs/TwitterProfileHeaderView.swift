//
//  TwitterProfileHeaderView.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/5/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TwitterProfileHeaderView: BaseNibView, OptionalTypedPropsAccessible {
    
    typealias PropsType = (avatar: UIImage, name: String, description: String)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func setup() {
        
        // Not the best way to make rounded corner + colored border.
        imageView.cornerRadius(6)
        imageView.border(width: 4, color: .white)
        
        imageView.image = #imageLiteral(resourceName: "logo.png")
        imageView.contentMode = .scaleAspectFill
    }
    
    override func update() {
        
        // Simple props
        imageView.image = self.props?.avatar
        nameLabel.text = self.props?.name
        descriptionLabel.text = self.props?.description
    }
}
