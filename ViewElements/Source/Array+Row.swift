//
//  Array+Row.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

public extension Array where Element: Row {
    func inset(left: CGFloat, right: CGFloat) {
        self.forEach { (el) in
            el.layoutMarginsStyle = .inset(top: 0, left: left, bottom: 0, right: right)
        }
    }
    
    func background(color: UIColor) {
        self.forEach { (el) in
            el.backgroundColor = color
        }
    }
    
    func childrenHaveSameBackgroundColorAsContainer(value: Bool=true) {
        self.forEach { (el) in
            el.childrenHaveSameBackgroundColorAsContainer = value
        }
    }
    
    func separator(style: Row.SeparatorStyle) {
        self.forEach { (el) in
            el.separatorStyle = style
        }
    }
    
    func row(height: CGFloat) {
        self.forEach { (el) in
            el.rowHeight = height
        }
    }
}
