//
//  UIView+Conveniences.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

public extension UIView {
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        return self
    }
}
