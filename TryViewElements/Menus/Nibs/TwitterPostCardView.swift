//
//  TwitterPostCardView.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElements

// Icon made by http://www.flaticon.com/authors/madebyoliver Madebyoliver

final class TwitterPostCardView: BaseNibView, OptionalTypedPropsAccessible {
    
    typealias PropsType = TwitterPost
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func setup() {
        [replyButton, retweetButton, likeButton, shareButton].forEach { (bttn) in
            bttn?.imageView?.contentMode = .scaleAspectFit
            let icon = #imageLiteral(resourceName: "heart.png").resizedFit(inSize: CGSize.init(width: 20, height: 20))
            bttn?
                .withFont(UIFont.systemFont(ofSize: 12))
                .colorText(.gray)
                .colorHighlightedText(.darkGray)
                .withIcon(icon)
                .tintIcon(color: .gray).offsetIcon(left: 4)
                .withTitle(text: "4")
        }
        
        profilePicView.contentMode = .scaleToFill
        profilePicView.clipsToBounds = true
        profilePicView.cornerRadius(4)

        authorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        usernameLabel.textColor = .gray
        
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius(4)
    }
    
    override func update() {
        profilePicView.image = props?.userPic
        authorLabel.text = props?.author
        usernameLabel.text = "\(props?.username ?? "") - \(props?.relativeDate ?? "")"
        detailLabel.text = props?.content
        imageView.image = props?.image
        if let img = props?.image {
            let hwRatio = img.size.height / img.size.width
            imageViewHeightConstraint.constant = self.imageView.bounds.width * hwRatio
            imageView.isHidden = false
        } else {
            imageViewHeightConstraint.constant = 0
            imageView.isHidden = true
        }
    }
}
