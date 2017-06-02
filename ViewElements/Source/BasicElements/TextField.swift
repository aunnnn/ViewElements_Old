//
//  TextField.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class BaseTextField: UITextField, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    open func update() {}
    public static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

public typealias TextFieldProps = (text: String?, placeholder: String?)

open class TextField: BaseTextField, OptionalTypedPropsAccessible {
    public typealias PropsType = TextFieldProps
    
    open override func setup() {}

    open override func update() {
        self.text = props?.text
        self.placeholder = props?.placeholder
    }
}

public func ElementOfTextField(props: TextFieldProps) -> ElementOf<TextField> {
    return ElementOf<TextField>.init(props: props)
}
