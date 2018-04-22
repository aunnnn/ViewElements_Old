//
//  UIView+AutoLayout.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

public extension UIView {
    
    /// Pin self to view's edges with inset.
    @discardableResult
    func al_pinToEdges(ofView view: UIView, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = UILayoutPriority(1000)) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ]
        constraints.forEach { (c) in
            c.priority = priority
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    /// Pin self to view's margins guide.
    @discardableResult
    func al_pinToLayoutMarginsGuide(ofView view: UIView) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.layoutMarginsGuide
        self.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        return self
    }
    
    /// Center self inside view.
    @discardableResult
    func al_center(insideView view: UIView) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func al_fixedSize(width: CGFloat, height: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let w = self.widthAnchor.constraint(equalToConstant: width)
        w.isActive = true
        w.priority = UILayoutPriority(rawValue: 999)
        let h = self.heightAnchor.constraint(equalToConstant: height)
        h.isActive = true
        h.priority = UILayoutPriority(rawValue: 999)
        return self
    }
    
    @discardableResult
    func al_fixedHeight(height: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let h = self.heightAnchor.constraint(equalToConstant: height)
        h.isActive = true
        h.priority = .required
        return self
    }
    
    @discardableResult
    func al_fixedWidth(width: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let w = self.widthAnchor.constraint(equalToConstant: width)
        w.isActive = true
        w.priority = .required
        return self
    }
    
    @discardableResult
    func al_aspectRatio(width: CGFloat, height: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let widthToHeight = width/height
        let ratio = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: widthToHeight)
        ratio.isActive = true
        ratio.priority = UILayoutPriority(rawValue: 999)
        return self
    }
    
    @discardableResult
    func al_aspectRatio(ofImage: UIImage) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let widthToHeight = ofImage.size.width / ofImage.size.height
        let ratio = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: widthToHeight)
        ratio.isActive = true
        ratio.priority = UILayoutPriority(rawValue: 999)
        return self
    }
}
