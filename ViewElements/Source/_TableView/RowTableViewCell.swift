//
//  RowTableViewCell.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

internal final class RowTableViewCell: UITableViewCell {
    
    private var _row: Row?
    
    public var row: Row? {
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
                if let _old = old.unTypedProps, let _new = new.unTypedProps {
                    guard old.unTypedShouldElementUpdate(oldProps: _old, newProps: _new) else {
                        print("No need to update \(old.viewIdentifier): \(_old).")
                        return
                    }
                }
            }
            
            displayable.update()
            self.layoutIfNeeded()
        }
    }
    
    private weak var _elementView: UIView?
    
    init(element: ElementOfView, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        let _view = element.build()
        if ((_view as? ElementDisplayable) == nil) {
            fatalError("View built from element must conform to ElementDisplayable.")
        }
        self._elementView = _view
        self.contentView.addSubview(_view)
        _view.al_pinToLayoutMarginsGuide(ofView: self.contentView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialising via storyboard is not suppported.")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let row = self._row else { return }
        self.separatorInset = row.cellAppearance.separatorStyle.value(withCellBounds: self.bounds)
    }
}
