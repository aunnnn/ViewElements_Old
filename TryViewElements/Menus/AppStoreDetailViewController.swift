//
//  AppStoreDetailViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/2/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class AppStoreDetailViewController: TableModelViewController {
    override func setupTable() {
        let h: SectionHeader = makeSegmentedControlHeader(selectedIndex: 0)
        
        let lb = Row(ElementOfLabel(props: "What is this!!"))
        lb.backgroundColor = MediumTheme.lightGray
        
        let s = Section(header: h, footer: nil, rows: TwitterFeedWithNibViewController.mockFeedSection().rows)
        self.table = Table(sections: [s])
        
        let appHeader = ElementOf<AppStoreHeaderDetailView>.init(props: (#imageLiteral(resourceName: "logo.png"), "Flying With Me - The last survival", "Wirawit Rueopas", "4+", "฿ 69.00"))
        let header = TableHeaderView(appHeader)
        header.layoutMarginsStyle = .zero
        header.backgroundColor = MediumTheme.lightGray
        table.headerView = header
    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
        showDetail(index: sender.selectedSegmentIndex)
    }

    func makeSegmentedControlHeader(selectedIndex: Int) -> SectionHeader {
        let s = ElementOfSegmentedControl(props: (["Details", "Reviews", "Related"], selectedIndex)).styles({ [unowned self] (s) in
            s.tintColor = UIColor.gray
            s.addTarget(self, action: #selector(self.valueChanged(sender:)), for: .valueChanged)
        })

        let sh = SectionHeader(s)
        sh.layoutMarginsStyle = .each(vertical: 8, horizontal: 16)
        return sh
    }
    
    func showDetail(index: Int) {
        let header = makeSegmentedControlHeader(selectedIndex: index)

        let section: Section = {
            switch index {
            case 0:
                return Section(header: header, footer: nil, rows: TwitterFeedWithNibViewController.mockFeedSection().rows)
            case 1:
                return Section(header: header, footer: nil, rows: MediumFeedViewController.mockFeedSection().rows)
            case 2:
                let lb = ElementOfLabel(props: "You can even add footer, how great is that?")
                let footer = SectionFooter(lb)
                return Section(header: header, footer: footer, rowsBlock: { () -> [Row] in
                    let all = [
                        Row(ElementOf<MediumStoryCardView>.init(props: ("Create Android Recyclerview adapters like a boss with MultiViewAdaptor", "Riyas Ahamed", 182, 23, #imageLiteral(resourceName: "cog.jpg")))),
                        Row(ElementOf<MediumStoryCardView>.init(props: ("ViewElements is the best library for iOS out there, no kidding", "Wirawit Rueopas", 0, 4, #imageLiteral(resourceName: "cog.jpg"))))
                    
                    ]
                    all.row(height: 120)
                    return all
                })
            default:
                fatalError()
            }
        }()
        
        self.table.sections[0] = section
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableView.scrollRectToVisible(.init(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
}
