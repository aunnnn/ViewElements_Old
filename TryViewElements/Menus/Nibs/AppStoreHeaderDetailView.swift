//
//  AppStoreHeaderDetailView.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/2/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class AppStoreHeaderDetailView: BaseNibView, OptionalTypedPropsAccessible {
    
    typealias PropsType = (img: UIImage, title: String, developer: String, age: String, price: String)
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appAgeLimitedLabel: UILabel!
    @IBOutlet weak var appDeveloperLabel: UIButton!
    @IBOutlet weak var appPriceLabel: UIButton!
    
    override func setup() {
        appTitleLabel.font = UIFont.systemFont(ofSize: 18)
        
        appDeveloperLabel
            .withFont(.systemFont(ofSize: 14))
            .colorText(.darkGray)
        
        appImageView.contentMode = .scaleToFill
        appImageView.clipsToBounds = true
        appImageView.cornerRadius(24)
        appImageView.border(width: 1, color: .lightGray)
        
        appPriceLabel.border(width: 1, color: .blue)
        appPriceLabel
            .withFont(.boldSystemFont(ofSize: 14))
            .colorText(.blue)
            .colorHighlightedText(.green)
            .cornerRadius(4)
        
        appAgeLimitedLabel.border(width: 1, color: .darkGray)
        appAgeLimitedLabel.font = UIFont.systemFont(ofSize: 11)
        appAgeLimitedLabel.textColor = .darkGray
    }
    
    override func update() {
        appImageView.image = props?.img
        appTitleLabel.text = props?.title
        appDeveloperLabel.withTitle(text: props?.developer ?? "")
        appPriceLabel.withTitle(text: props?.price ?? "GET")
        appAgeLimitedLabel.text = props?.age
    }
}

extension OptionalTypedPropsAccessible where Self: UIView, Self: ElementDisplayable {
    static func element(props: Self.PropsType) -> ElementOf<Self> {
        return ElementOf<Self>.init(props: props)
    }
    
    static func asRow(props: Self.PropsType) -> Row {
        return Row(self.element(props: props))
    }
}

func ElementOfAppStoreHeaderDetail(props: AppStoreHeaderDetailView.PropsType) -> ElementOf<AppStoreHeaderDetailView> {
    return AppStoreHeaderDetailView.element(props: props)
}
