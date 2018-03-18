//
//  ElementOf.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/23/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

public protocol ElementOfView: class, ViewBuildable, UnTypedPropsAccessible, UnTypedPropsShouldElementUpdate {
    var viewIdentifier: String { get }
}

/// Abstraction of UIView that can represent Props. Similar to ViewModel in MVVM.
public final class ElementOf<U: UIView>: ElementOfView, TypedPropsAccessible, TypedPropsShouldElementUpdate where U: ElementDisplayable & OptionalTypedPropsAccessible {
    public typealias T = ElementOf<U>
    public typealias PropsType = U.PropsType
    
    public let unTypedProps: Props
    public var stylesBlock: ((U) -> Void)?
    public var viewIdentifier: String {
        if let name = self.name { return name }
        if stylesBlock != nil {
            return "\(U.self)\(uniqueID)"
        }
        return "\(U.self)"
    }
    
    private var name: String?
    private let uniqueID = randomAlphaNumericString(length: 10)
    
    public init(props: PropsType) {
        self.unTypedProps = props
    }
    
    public func build() -> UIView {
        return _build(method: U.buildMethod())
    }

    open func shouldElementUpdate(oldProps: ElementOf<U>.T.PropsType, newProps: ElementOf<U>.T.PropsType) -> Bool {
        return true
    }
    
    /// Additional style setup to apply. For complex setup, it's recommended to do in 'setup()' in subclass of ElementDisplayable instead.
    public func styles(_ block: @escaping (U) -> Void) -> ElementOf {
        self.stylesBlock = block
        return self
    }
    
    public func name(_ name: String) -> ElementOf {
        self.name = name
        return self
    }
    
    private func _build(method: ViewBuildMethod) -> U {
        switch method {
        case .init:
            let view = U()
            view.setup()
            self.stylesBlock?(view)
            view.element = self
            view.update()
            return view
            
        case .nib:
            
            guard let nib = Bundle.main.loadNibNamed("\(U.self)", owner: nil, options: nil) else {
                fatalError("The nib with name '\(U.self)' is not found.")
            }
            
            let view = nib.first! as! U
            
            guard let baseView = view as? BaseNibView else {
                fatalError("A view instantiated from nib (\(U.self)) must inherit from 'BaseNibView'.")
            }
            
            baseView.didAwakeFromNibBlock = { [weak self] in
                view.setup()
                self?.stylesBlock?(view)
                view.element = self
                view.update()
            }
            return view
        }
    }
}
