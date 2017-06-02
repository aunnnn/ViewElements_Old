//
//  SegmentedControl.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 6/2/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import Foundation

open class BaseSegmentedControl: UISegmentedControl, ElementDisplayable {
    
    public var element: ElementOfView?
    
    open func setup() {}
    open func update() {}
    
    public static func buildMethod() -> ViewBuildMethod {
        return .init
    }
}

public typealias SegmentedControlProps = (segmentTitles: [String], selectedIndex: Int)

open class SegmentedControl: BaseSegmentedControl, OptionalTypedPropsAccessible {
    public typealias PropsType = SegmentedControlProps
    
    open override func update() {
        self.removeAllSegments()
        self.props?.segmentTitles.enumerated().forEach({ (ind, el) in
            self.insertSegment(withTitle: el, at: ind, animated: false)
        })
        self.selectedSegmentIndex = self.props?.selectedIndex ?? 0
    }
}

public func ElementOfSegmentedControl(props: SegmentedControlProps) -> ElementOf<SegmentedControl> {
    return ElementOf<SegmentedControl>.init(props: props)
}
