//
//  ElementContainer.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

/// Anything that contains (and manages) ElementOfView.
public protocol ElementContainer {
    
    /// Element that the container wraps.
    var element: ElementOfView { get }
    
    /// Background color of contentView (e.g. of UITableViewCell)
    var backgroundColor: UIColor { get }

    var isUserInteractionEnabled: Bool { get }
    
    /// Layout margins.
    var layoutMarginsStyle: Row.LayoutMarginStyle { get }
    
    /// Default is false.
    /// If true, upon view construction, all children's background colors are automatically set to Row's backgroundColor,
    /// and isOpaque is set to true.
    /// This is for rendering optimization.
    var childrenHaveSameBackgroundColorAsContainer: Bool { get }
}

extension ElementContainer {

    /// Make container view (aka `tableViewCell.contentView`) and elementView same background color as this ElementContainer & set it to opaque.
    func setOpaqueBackgroundColorForContainerAndChildrenElements(containerView: UIView, elementView: UIView) {
        if self.backgroundColor == .clear {
            warn("\(self.element.viewIdentifier) - childrenHaveSameBackgroundColorAsContainer is true but found '.clear' background color. ")
        }

        containerView.backgroundColor = self.backgroundColor
        containerView.isOpaque = true
        if let stack = elementView as? _StackView {
            stack.setAllChildrenOpaqueBackgroundColor(color: self.backgroundColor)
        } else {
            elementView.backgroundColor = self.backgroundColor
            elementView.isOpaque = true
        }
    }
    
    /// Prepare root view (`UITableViewCell/ UITableHeaderFooterView`). E.g. setting layoutMargins to .zero.
    func prepare(rootView: UIView) {
        rootView.backgroundColor = self.backgroundColor
        rootView.preservesSuperviewLayoutMargins = false
        rootView.layoutMargins = .zero
    }
    
    /// Prepare content view (`UITableViewCell/ UITableHeaderFooterView.contentView`).
    /// This is where `layoutMarginsStyle` is applied.
    func prepare(contentView: UIView) {
        contentView.backgroundColor = self.backgroundColor
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = self.layoutMarginsStyle.value
        contentView.isUserInteractionEnabled = self.isUserInteractionEnabled
    }
}
