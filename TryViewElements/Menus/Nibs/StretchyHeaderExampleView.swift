//
//  StretchyHeaderExampleView.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 3/25/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class StretchyHeaderExampleView: BaseNibView, OptionalTypedPropsAccessible {

    typealias PropsType = (image: UIImage, title: String)

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    override func setup() {

    }

    override func update() {
        self.nameLabel.text = self.props?.title
        self.profileImageView.image = self.props?.image
    }
}
