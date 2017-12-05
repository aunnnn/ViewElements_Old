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

public typealias ButtonWithActionProps = (title: String, handler: () -> Void)

open class ButtonWithAction: BaseButton, OptionalTypedPropsAccessible {
    public typealias PropsType = ButtonWithActionProps
    
    open override func setup() {
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitleColor(.gray, for: .highlighted)
    }
    
    @objc private func handleAction() {
        self.props?.handler()
    }
    
    open override func update() {
        self.setTitle(self.props?.title, for: .normal)
        self.addTarget(self, action: #selector(self.handleAction), for: .touchUpInside)
    }
}

public func ElementOfButton(props: ButtonProps) -> ElementOf<Button> {
    return ElementOf<Button>.init(props: props)
}

public func ElementOfButtonWithAction(props: ButtonWithActionProps) -> ElementOf<ButtonWithAction> {
    return ElementOf<ButtonWithAction>.init(props: props)
}
