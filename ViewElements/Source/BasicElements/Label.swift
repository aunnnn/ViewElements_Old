//
//  Label.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class BaseLabel: UILabel, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    open func update() {}
    public static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

open class Label: BaseLabel, OptionalTypedPropsAccessible {
    public typealias PropsType = String
    
    override open func setup() {
        self.numberOfLines = 0
        self.textColor = .black
        self.isUserInteractionEnabled = false
    }
    
    override open func update() {
        self.text = self.props
    }
}

public func ElementOfLabel(props: String) -> ElementOf<Label> {
    return ElementOf<Label>.init(props: props)
}
