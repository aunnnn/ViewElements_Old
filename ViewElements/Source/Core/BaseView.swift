//
//  BaseView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Base UIView to override.
open class BaseView: UIView, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    open func update() {}
    
    open class func buildMethod() -> ViewBuildMethod {
        return .init
    }
}
