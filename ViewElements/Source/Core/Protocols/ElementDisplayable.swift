//
//  ElementDisplayable.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

// *This bunch of protocols is just a hack that only allow UIView to able to inherit from this protocol.

/// A protocol for UIView that can be configured with Element.
public protocol ElementDisplayable: NSCoding, UIAppearance, UIAppearanceContainer, UIDynamicItem, UITraitEnvironment, UICoordinateSpace, UIFocusItem, CALayerDelegate {
    
    /// Initial setup.
    func setup()
    
    /// Update view with a new element.
    func update()
    
    /// A method to build this UIView. Default is '.init'
    static func buildMethod() -> ViewBuildMethod
    
    var element: ElementOfView? { get set }
}

public extension ElementDisplayable where Self: UIView {
    public var unTypedProps: Props? {
        return element?.unTypedProps
    }
}
