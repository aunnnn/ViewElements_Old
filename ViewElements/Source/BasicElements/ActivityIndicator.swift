//
//  ActivityIndicator.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class ActivityIndicator: BaseView, OptionalTypedPropsAccessible {
    
    public typealias PropsType = Bool

    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    open override func setup() {
        self.addSubview(activityIndicatorView)
        activityIndicatorView.al_center(insideView: self)
        activityIndicatorView.hidesWhenStopped = true
    }
    
    open override func update() {
        guard let animating = self.props else {
            activityIndicatorView.startAnimating()
            return
        }
        animating ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
}

public func ElementOfActivityIndicator(props: Bool=true) -> ElementOf<ActivityIndicator> {
    return ElementOf<ActivityIndicator>.init(props: props)
}
