//
//  TestView.swift
//  TryViewElements+UI
//
//  Created by Wirawit Rueopas on 3/18/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

public protocol TestViewDelegate: class {
    func testViewDidTapButton(props: TestView.PropsType?)
}

public class TestView: BaseNibView, OptionalTypedPropsAccessible {

    /// Better use struct instead of tuple if it gets complicated!
    public typealias PropsType = (labelText: String, buttonTitle: String, delegate: TestViewDelegate?)

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    weak var delegate: TestViewDelegate?

    public override func setup() {}

    public override func update() {
        self.label.text = self.props?.labelText
        self.button.setTitle(self.props?.buttonTitle, for: .normal)
        self.delegate = self.props?.delegate
    }

    @IBAction func buttonPushed(_ sender: Any) {
        self.delegate?.testViewDidTapButton(props: self.props)
    }
}
