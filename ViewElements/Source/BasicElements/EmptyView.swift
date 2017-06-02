//
//  EmptyView.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/26/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

public class EmptyView: BaseView, OptionalTypedPropsAccessible {
    public typealias PropsType = Void
    
    public override func setup() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
    }
}

public func FlexibleSpace() -> ElementOf<EmptyView> {
    return ElementOf<EmptyView>.init(props: ()).styles({ (v) in
        v.setContentHuggingPriority(1, for: .horizontal)
        v.setContentHuggingPriority(1, for: .vertical)
    })
}
