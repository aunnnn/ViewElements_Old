//
//  ImageView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class BaseImageView: UIImageView, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    open func update() {}
    public static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

open class ImageView: BaseImageView, OptionalTypedPropsAccessible {
    public typealias PropsType = UIImage
    
    open override func setup() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    open override func update() {
        self.image = props
    }
}

public func ElementOfImageView(props: UIImage) -> ElementOf<ImageView> {
    return ElementOf<ImageView>.init(props: props)
}
