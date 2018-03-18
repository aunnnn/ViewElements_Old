//
//  TestView.swift
//  TryViewElements+UI
//
//  Created by Wirawit Rueopas on 3/18/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

public class TestView: BaseNibView, OptionalTypedPropsAccessible {

    public typealias PropsType = String
    @IBOutlet weak var label: UILabel!

    public override func setup() {

    }

    public override func update() {
        self.label.text = self.props
    }
}
