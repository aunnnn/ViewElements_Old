//
//  Button.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class BaseButton: UIButton, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    
    open func update() {}
    public static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

public typealias ButtonProps = String

open class Button: BaseButton, OptionalTypedPropsAccessible {
    public typealias PropsType = ButtonProps
    
    open override func setup() {
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitleColor(.gray, for: .highlighted)
    }
    
    open override func update() {
        self.setTitle(self.props, for: .normal)
    }
}

public func ElementOfButton(props: ButtonProps) -> ElementOf<Button> {
    return ElementOf<Button>.init(props: props)
}
