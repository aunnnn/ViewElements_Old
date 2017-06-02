//
//  Row+Configurations.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

public extension Row {
    
    /// Layout margin style of table view cell
    public enum LayoutMarginStyle {
        /// all = 0
        case zero
        
        /// all = 8
        case `default`
        
        /// all = margin
        case all(inset: CGFloat)
        
        case each(vertical: CGFloat, horizontal: CGFloat)
        
        case inset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
        
        internal var value: UIEdgeInsets {
            switch self {
            case .zero:
                return .zero
            case .`default`:
                return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
            case let .all(inset):
                return UIEdgeInsets.init(top: inset, left: inset, bottom: inset, right: inset)
            case let .each(vertical, horizontal):
                return UIEdgeInsets.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
            case let .inset(t, l, b, r):
                return UIEdgeInsets.init(top: t, left: l, bottom: b, right: r)
            }
        }
    }
    
    /// Separator style of table view cell
    public enum SeparatorStyle {
        case none
        
        /// left, right = 8
        case `default`
        
        /// all = 0
        case fullWidth
        
        case custom(left: CGFloat, right: CGFloat)
        
        internal func value(withCellBounds cellBounds: CGRect) -> UIEdgeInsets {
            switch self {
            case .none:
                return UIEdgeInsets(top: 0, left: cellBounds.size.width, bottom: 0, right: 0)
            case .fullWidth:
                return UIEdgeInsets.zero
            case .default:
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            case let .custom(left, right):
                return UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
            }
        }
    }
}
