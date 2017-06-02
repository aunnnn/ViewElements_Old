//
//  TableRowViewCell.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

internal final class TableRowViewCell: UITableViewCell {
    
    private var _row: Row?
    
    var row: Row? {
        get {
            return _row
        }
        
        set {
            defer { self._row = newValue }
            
            let old = _row?.element
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
    
    internal weak var _elementView: UIView?
    
    init(row: Row, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        let element = row.element
        let _view = element.build()
        if ((_view as? ElementDisplayable) == nil) {
            fatalError("View built from element must conform to ElementDisplayable.")
        }
        self._elementView = _view
        
        row.setOpaqueBackgroundColorForContainerAndChildrenElementsIfNecessary(containerView: self.contentView, elementView: _view)
        
        self.contentView.addSubview(_view)
        
        if row.pinToEdgesInsteadOfLayoutMarginsGuide {
            _view.al_pinToEdges(ofView: self.contentView)
        } else {
            _view.al_pinToLayoutMarginsGuide(ofView: self.contentView)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialising via storyboard is not suppported.")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let row = self._row else { return }
        self.separatorInset = row.separatorStyle.value(withCellBounds: self.bounds)
    }
}
