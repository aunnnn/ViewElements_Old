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
        let lb = ElementOfLabel(props: "Test if reload between different stretchy/table header types are working").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
        }

        let lbHeader = StretchyHeader(behavior: .shrinksToMinimumHeight(50), element: lb)
        lbHeader.backgroundColor = .yellow

        let bttnRow = Row(ElementOfButtonWithAction(props: ("Reload to use stretchy with shrink mode", { [unowned self] in
            self.reloadBlueStretchyHeaderShrink100()
        })).styles({ (bttn) in
            bttn.setTitleColor(.blue, for: .normal)
            bttn.titleLabel?.adjustsFontSizeToFitWidth = true
            bttn.titleLabel?.minimumScaleFactor = 0.6
        }))

        let bttnRow2 = Row(ElementOfButtonWithAction(props: ("Reload to use stretchy with scrolls up mode", { [unowned self] in
            self.reloadGreenStretchyHeaderScrollsUp()
        })).styles({ (bttn) in
            bttn.setTitleColor(.green, for: .normal)
            bttn.titleLabel?.adjustsFontSizeToFitWidth = true
            bttn.titleLabel?.minimumScaleFactor = 0.6
        }))

        let bttnRow3 = Row(ElementOfButtonWithAction(props: ("Reload to use stretchy header with interaction", { [unowned self] in
            self.reloadToUseComponentWithButton()
        })).styles({ (bttn) in
            bttn.setTitleColor(.orange, for: .normal)
            bttn.titleLabel?.adjustsFontSizeToFitWidth = true
            bttn.titleLabel?.minimumScaleFactor = 0.6
        }))

        let bttnRow4 = Row(ElementOfButtonWithAction(props: ("Reload to table header view also works", { [unowned self] in
            self.reloadUseTableHeaderView()
        })).styles({ (bttn) in
            bttn.setTitleColor(.purple, for: .normal)
            bttn.titleLabel?.adjustsFontSizeToFitWidth = true
            bttn.titleLabel?.minimumScaleFactor = 0.6
        }))


        let mockRows = (0...10).map { Row(ElementOfLabel(props: "Label \($0)")) }

        let s = Section(rows: [bttnRow, bttnRow2, bttnRow3, bttnRow4] + mockRows)
        let table = Table(sections: [s])
        table.stretchyHeaderView = lbHeader

        self.table = table
    }

    func reloadBlueStretchyHeaderShrink100() {
        let lb = ElementOfLabel(props: "Reloaded! Note that this stretchy use fixed height by setting `restingHeight = 240`. By default (nil), restingHeight is calculated by AutoLayout.").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
        }
        let lbHeader = StretchyHeader(behavior: .shrinksToMinimumHeight(100), element: lb)
        lbHeader.backgroundColor = .blue
        lbHeader.restingHeight = 240
        table.headerView = nil
        table.stretchyHeaderView = lbHeader
        self.reload()
    }

    func reloadGreenStretchyHeaderScrollsUp() {
        let lb = ElementOfLabel(props: "Reloaded!").styles { (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
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
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.5
        }
        let lbHeader = TableHeaderView(lb)
        lbHeader.backgroundColor = .purple
        table.stretchyHeaderView = nil
        table.headerView = lbHeader
        self.reload()
    }

    func reloadToUseComponentWithButton() {
        let lb = SampleComponent(props: ("Test user interaction", "Tap me", {
            print("works!")
        }))

        let lbHeader = StretchyHeader(behavior: .scrollsUpWithContent, element: lb)
        lbHeader.backgroundColor = .orange
        table.headerView = nil
        table.stretchyHeaderView = lbHeader
        self.reload()
    }
}

private final class SampleComponent: ComponentOf<(String, String, () -> Void)> {

    override func shouldElementUpdate(oldProps: (String, String, () -> Void), newProps: (String, String, () -> Void)) -> Bool {
        return (oldProps.0, oldProps.1) != (newProps.0, newProps.1)
    }

    override func render() -> StackProps {
        let els: [ViewBuildable] = [
            ElementOfLabel(props: props.0),
            ElementOfButtonWithAction(props: (props.1, props.2))
        ]
        return HorizontalStack(distribute: .fillEqually,
                                align: .center,
                                spacing: 8,
                                els)
    }
}
