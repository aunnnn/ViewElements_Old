//
//  TableSectionHeaderView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

internal class TableSectionHeaderFooterView: UITableViewHeaderFooterView {
    
    private var _headerFooter: ElementContainer?
    
    var headerFooter: ElementContainer? {
        get {
            return _headerFooter
        }
        
        set {
            defer { self._headerFooter = newValue }
            
            let old = _headerFooter?.element
            let new = newValue?.element
            
            guard let displayable = (self._elementView as? ElementDisplayable) else { return }
            displayable.element = newValue?.element
            
            if let old = old, let new = new {
                let oldProps = old.unTypedProps
                let newProps = new.unTypedProps
                guard old.unTypedShouldElementUpdate(oldProps: oldProps, newProps: newProps) else { return }
            }
            
            displayable.update()
        }
    }
    
    weak var _elementView: UIView?
    
    init(headerFooter: ElementContainer, reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let element = headerFooter.element
        let _view = element.build()
        if ((_view as? ElementDisplayable) == nil) {
            fatalError("View built from element must conform to ElementDisplayable.")
        }
        self._elementView = _view
        
        headerFooter.setOpaqueBackgroundColorForContainerAndChildrenElementsIfNecessary(containerView: self.contentView, elementView: _view)
        self.contentView.addSubview(_view)
        _view.al_pinToLayoutMarginsGuide(ofView: self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialising via storyboard is not suppported.")
    }
}
