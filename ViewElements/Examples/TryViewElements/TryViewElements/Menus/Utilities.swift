//
//  Utilities.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedTo(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedFit(inSize: CGSize) -> UIImage {
        let widthFactor = size.width / inSize.width
        let heightFactor = size.height / inSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = self.resizedTo(newSize: newSize)
        return resized
    }
}

extension UIButton {
    
    @discardableResult
    func colorText(_ color: UIColor) -> UIButton {
        self.setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func colorHighlightedText(_ color: UIColor) -> UIButton {
        self.setTitleColor(color, for: .highlighted)
        return self
    }
    
    @discardableResult
    func multilines() -> UIButton {
        self.titleLabel?.numberOfLines = 0
        return self
    }
    
    @discardableResult
    func numberOfLines(_ number: Int) -> UIButton {
        self.titleLabel?.numberOfLines = number
        return self
    }
    
    @discardableResult
    func withFont(_ font: UIFont) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func withIcon(_ icon: UIImage, tintColor: UIColor?=nil) -> UIButton {
        let _icon: UIImage
        if let tint = tintColor {
            _icon = icon.withRenderingMode(.alwaysTemplate)
            self.imageView?.tintColor = tint
        } else {
            _icon = icon
        }
        self.setImage(_icon, for: .normal)
        return self
    }
    
    @discardableResult
    func tintIcon(color: UIColor) -> UIButton {
        self.imageView?.tintColor = color
        return self
    }
    
    @discardableResult
    func offsetIcon(left: CGFloat, verticalInset: CGFloat=0) -> UIButton {
        self.contentEdgeInsets = .init(top: verticalInset, left: 16, bottom: verticalInset, right: 10)
        self.imageEdgeInsets = .init(top: verticalInset, left: -14, bottom: verticalInset, right: 0)
        return self
    }
    
    @discardableResult
    func withTitle(text: String) -> UIButton {
        self.setTitle(text, for: .normal)
        return self
    }
}
