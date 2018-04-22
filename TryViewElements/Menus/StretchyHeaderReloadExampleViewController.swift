//
//  StretchyHeaderReloadExampleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 22/4/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import ViewElements

final class StretchyHeaderReloadExampleViewController: TableModelViewController {
    override func setupTable() {
        let lb = ElementOfLabel(props: "Tap Reload").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }

        let lbHeader = StretchyHeader(behavior: .shrinksToMinimumHeight(50), element: lb)
        lbHeader.backgroundColor = .yellow

        let bttnRow = Row(ElementOfButtonWithAction(props: ("Reload blue", { [unowned self] in
            self.reloadBlueStretchyHeaderShrink100()
        })))

        let bttnRow2 = Row(ElementOfButtonWithAction(props: ("Reload scrolls up mode", { [unowned self] in
            self.reloadGreenStretchyHeaderScrollsUp()
        })))

        let bttnRow3 = Row(ElementOfButtonWithAction(props: ("Reload use table header view", { [unowned self] in
            self.reloadUseTableHeaderView()
        })))

        let mockRows = (0...10).map { return Row(ElementOfLabel(props: "Test Row \($0)")) }
        let s = Section(rows: [bttnRow, bttnRow2, bttnRow3] + mockRows)
        let table = Table(sections: [s])
        table.stretchyHeaderView = lbHeader

        self.table = table
    }

    func reloadBlueStretchyHeaderShrink100() {
        let lb = ElementOfLabel(props: "Reloaded!").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        }
        let lbHeader = StretchyHeader(behavior: .shrinksToMinimumHeight(100), element: lb)
        lbHeader.backgroundColor = .blue
        lbHeader.adjustsTableViewScrollIndicatorInsetsBelowStretchyHeaderView = false
        lbHeader.restingHeight = 240
        table.headerView = nil
        table.stretchyHeaderView = lbHeader
        self.reload()
    }

    func reloadGreenStretchyHeaderScrollsUp() {
        let lb = ElementOfLabel(props: "Reloaded!").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        }
        let lbHeader = StretchyHeader(behavior: .scrollsUpWithContent, element: lb)
        lbHeader.backgroundColor = .green
        table.headerView = nil
        table.stretchyHeaderView = lbHeader
        self.reload()
    }

    func reloadUseTableHeaderView() {
        let lb = ElementOfLabel(props: "Reloaded with table header view!").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        }
        let lbHeader = TableHeaderView(lb)
        lbHeader.backgroundColor = .yellow
        table.stretchyHeaderView = nil
        table.headerView = lbHeader
        self.reload()
    }
}
