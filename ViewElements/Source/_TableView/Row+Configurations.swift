//
//  Row+Configurations.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

public extension Row {
    
    public struct CellLayoutConfiguration {
        
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
        
        /// Layout margin style.
        public var layoutMarginsStyle: LayoutMarginStyle
        
        /// Estimated row height to be used in table view. Must be more than 0.
        public var estimatedRowHeight: CGFloat
        
        /// Row height to be used in table view. If the value setting to this is not UITableViewAutomaticDimension, estimatedRowHeight will also be set to the same value.
        public var rowHeight: CGFloat {
            didSet {
                // if fixed height, also set estimatedRowHeight to equal rowHeight
                guard hasFixedHeight else {
                    return
                }
                estimatedRowHeight = rowHeight
            }
        }
        
        /// Whether the Row has fixed height, e.g., does not use Autolayout.
        private var hasFixedHeight: Bool {
            return rowHeight != UITableViewAutomaticDimension
        }
        
        public init() {
            self.estimatedRowHeight = 44
            self.rowHeight = UITableViewAutomaticDimension
            self.layoutMarginsStyle = .all(inset: 8)
        }
    }
    
    public struct CellAppearanceConfiguration {
        
        /// Separator style of table view cell
        public enum SeparatorStyle {
            case none
            
            /// left, right = 8
            case `default`
            
            /// all = 0
            case fullWidth
            
            internal func value(withCellBounds cellBounds: CGRect) -> UIEdgeInsets {
                switch self {
                case .none:
                    return UIEdgeInsets(top: 0, left: cellBounds.size.width, bottom: 0, right: 0)
                case .fullWidth:
                    return UIEdgeInsets.zero
                case .default:
                    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
                }
            }
        }
        
        /// Separator style of table view cell.
        public var separatorStyle: SeparatorStyle
        public var selectionStyle: UITableViewCellSelectionStyle
        
        public init() {
            self.separatorStyle = .none
            self.selectionStyle = .none
        }
    }
}
