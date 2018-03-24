//
//  HeaderFooterExampleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 3/23/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElements
import TryViewElements_UI

final class HeaderFooterExampleViewController: TableModelViewController, TestViewDelegate {

    override func setupTable() {

        let rowsMaker: (Int) -> [Row] = { section in

            let mockProps1: TestView.PropsType = ("This table row is created with nib file (TestView.xib) from another module.", "Tap", self)

            return (0...10).map { i in
                let row = Row(ElementOfLabel(props: "Index \(section), \(i)"))
                row.rowHeight = 44
                row.separatorStyle = Row.SeparatorStyle.custom(left: 16, right: 8)
                return row
            } + [Row(ElementOf<TestView>(props: mockProps1))]
        }
        let sectionMaker: (Int) -> Section = { section in
            let rows = rowsMaker(section)
            return Section(rows: rows)
        }

        let sections: [Section] = (0..<7).map { i in
            let s = sectionMaker(i)
            let mockProps2: TestView.PropsType = ("This section header \(i) also uses the same nib file (TestView.xib).\nCreate once, use everywhere!", "Tap", self)
            s.header = SectionHeader(ElementOf<TestView>.init(props: mockProps2))
            s.footer = SectionFooter(ElementOfLabel(props: "Plain footer \(i)."))
            return s
        }
        let table = Table(sections: sections)
        let mockProps3: TestView.PropsType = ("This table header view is created with `TestView.xib`.", "Tap", self)
        table.headerView = TableHeaderView(ElementOf<TestView>.init(props: mockProps3))
        self.table = table
    }

    func testViewDidTapButton(props: TestView.PropsType?) {
        print("Did tap row with props \(props)")
    }
}
