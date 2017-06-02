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
    
    /// Layout margins.
    var layoutMarginsStyle: Row.LayoutMarginStyle { get }
    
    /// Default is false.
    /// If true, upon view construction, all children's background color are automatically set to Row's backgroundColor,
    /// and isOpaque is set to true.
    /// This is for rendering optimization.
    var childrenHaveSameBackgroundColorAsContainer: Bool { get }
}

extension ElementContainer {
    func setOpaqueBackgroundColorForContainerAndChildrenElementsIfNecessary(containerView: UIView, elementView: UIView) {
        if self.childrenHaveSameBackgroundColorAsContainer {
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
    }
    
    /// Configure root view.
    ///
    /// Normally rootView is UITableViewCell/ UITableHeaderFooterView.
    func configure(rootView: UIView) {
        rootView.backgroundColor = self.backgroundColor
        rootView.preservesSuperviewLayoutMargins = false
        rootView.layoutMargins = .zero
    }
    
    /// Configure container.
    ///
    /// Normally containerView is UITableViewCell / UITableHeaderFooterView's *contentView*, where the *layout margins* reflect with the model.
    func configure(containerView: UIView) {
        containerView.backgroundColor = self.backgroundColor
        containerView.preservesSuperviewLayoutMargins = false
        containerView.layoutMargins = self.layoutMarginsStyle.value
    }
    
    public func buildContainerViewAndWrap(elementView: UIView) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(elementView)
        elementView.al_pinToLayoutMarginsGuide(ofView: containerView)
        
        self.configure(containerView: containerView)
        self.setOpaqueBackgroundColorForContainerAndChildrenElementsIfNecessary(containerView: containerView, elementView: elementView)
        return containerView
    }
}
