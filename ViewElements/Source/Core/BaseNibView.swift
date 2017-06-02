//
//  BaseNibView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// Base UIView that is instantiated from nib file.
///
/// *IMPORTANT:* UIView that is initiated from nib file must have this as a base class, as it performs some tasks on awakeFromNib.
/// For view that is created with .init(), you can just override ElementDisplayable.
open class BaseNibView: UIView, ElementDisplayable {
    
    public var element: ElementOfView?
    
    internal var didAwakeFromNibBlock: (() -> Void)? {
        didSet {
            // If at this time 'awakeFromNib' is already called, performs it directly here.
            if didAwakeFromNib {
                didAwakeFromNibBlock?()
            }
        }
    }
    
    private var didAwakeFromNib = false
    
    open func setup() {}
    open func update() {}
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        /*
            We can't be sure whether didAwakeFromNibBlock is set 
            before awakeFromNib() was called. But we must
            perform the block eventually, once. So keep
            track whether awakeFromNib is called.
         */
        
        didAwakeFromNibBlock?()
        didAwakeFromNib = true
    }
    
    open class func buildMethod() -> ViewBuildMethod {
        return .nib
    }
}
