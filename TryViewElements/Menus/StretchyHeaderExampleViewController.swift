//
//  StretchyHeaderExampleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 3/24/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

final class StretchyHeaderExampleViewController: TableModelViewController {

    private let isScrollsUpMode: Bool
    private weak var capturedNavigationController: UINavigationController?

    init(isScrollsUpMode: Bool) {
        self.isScrollsUpMode = isScrollsUpMode
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        self.isScrollsUpMode = true
        super.init(coder: aDecoder)
    }

    static func makeTable(isScrollsUpMode: Bool) -> Table {
        let lbMaker: () -> Row = {
            return Row(ElementOfLabel(props: isScrollsUpMode ? "Stretchy header will moves up with content." : "Stretchy header will shrink and stick at the top."))
        }

        let rows: [Row] = (0...20).map { i in
            let lbRow = lbMaker()
            lbRow.rowHeight = 100
            lbRow.separatorStyle = .fullWidth
            lbRow.backgroundColor = isScrollsUpMode ? .lightText : .lightGray
            return lbRow
        }

        let warningRow = Row(ElementOfLabel(props: "Warning: `stretchyHeaderView` can't be used together with `headerView`. If you want to use `headerView`, you must not set stretchyHeaderView` (or set to nil.)").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        }))

        let warning2Row = Row(ElementOfLabel(props: "tableHeaderView doesn't work well with AutoLayout, and somehow stretchyHeaderView messes it up further. But you can always use the first Row as tableHeader."))

        let table = Table(sections: [Section(rows: [warningRow, warning2Row] + rows)])

        let stretchyHeader: StretchyHeader = { () -> StretchyHeader in
            let el = ElementOf<StretchyHeaderExampleView>(props: (#imageLiteral(resourceName: "user1.jpg"), "My name is not John Doe. This is StretchHeader on \(isScrollsUpMode ? "'scrolls up' mode" : "'shrinks' mode").")).styles({ (v) in
                v.backgroundColor = .green
            })

            let sh: StretchyHeader
            if isScrollsUpMode {
                sh = StretchyHeader(behavior: .scrollsUpWithContent, element: el)
            } else {
                sh = StretchyHeader(behavior: .shrinksToMinimumHeight(100), element: el)
            }
            sh.backgroundColor = .black
            sh.layoutMarginsStyle = .inset(top: 8, left: 16, bottom: 8, right: 16)
            return sh
        }()
        table.stretchyHeaderView = stretchyHeader

        return table
    }

    override func setupTable() {
        self.table = StretchyHeaderExampleViewController.makeTable(isScrollsUpMode: self.isScrollsUpMode)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = nil
        view.backgroundColor = .yellow
        tableView.backgroundColor = .clear

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    // MARK:- Navigation bar styles
    override func viewWillAppear(_ animated: Bool) {
        self.setTransparentNavigationBar()
        self.capturedNavigationController = self.navigationController
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.setDefaultNavigationBar()
        super.viewWillDisappear(animated)
    }

    private func setTransparentNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.backgroundColor = UIColor.clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isUserInteractionEnabled = false
        navBar.isTranslucent = true

        navBar.tintColor = .white
    }

    private func setDefaultNavigationBar() {
        guard let nav = self.capturedNavigationController else { return }
        let navBar = nav.navigationBar
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(nil, for: .default)
        navBar.shadowImage = nil
        navBar.isUserInteractionEnabled = true
        navBar.isTranslucent = false
        navBar.tintColor = .blue

        if let parent = nav.viewControllers.last as? ExampleListViewController {
            parent.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
                nav.navigationBar.barTintColor = .white
                nav.navigationBar.tintColor = .blue
            }, completion: nil)
        }
    }
}
