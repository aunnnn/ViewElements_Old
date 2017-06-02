//
//  TwitterFeedWithNibViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TwitterFeedWithNibViewController: TableModelViewController {
    override func setupTableViewModel() {
        let section1 = TwitterFeedWithNibViewController.mockFeedSection()
        
        let hd = SectionHeader(ElementOfLabel(props: "In case you've missed it").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 20)
        }))
        hd.backgroundColor = .lightGray
        
        let section2 = Section.init(
            header: hd,
            footer: nil) { () -> [Row] in
                let spc = RowOfEmptySpace(height: 22)
                spc.backgroundColor = MediumTheme.lightGray
                spc.childrenHaveSameBackgroundColorAsContainer = true
                
                let all = (0...10).map { _ in TwitterFeedWithNibViewController.getMockPostRow() }
                all.separator(style: .fullWidth)
                all.background(color: .white)
                all.childrenHaveSameBackgroundColorAsContainer()
                all.inset(left: 0, right: 0)
                return [spc] + all
        }
        self.tableViewModel = Table.init(sections: [section1, section2])
        self.tableViewModel.guessesSimilarHeightForCellsWithSameType = true
        self.tableViewModel.headerView = TableHeaderView(ElementOfLabel(props: "Twitter card created with Nib.\n\nYou will notice that scrolling is so smoother than using Component!").styles({ (lb) in
            lb.font = UIFont.italicSystemFont(ofSize: 14)
            lb.textColor = .gray
        }))
        self.tableViewModel.headerView?.layoutMarginsStyle = .inset(top: 12, left: 22, bottom: 12, right: 22)
        self.tableViewModel.headerView?.backgroundColor = .lightText
        
        self.tableView.backgroundColor = .lightText
    }
    
    static func getMockPostRow() -> Row {
        return Row(ElementOf<TwitterPostCardView>.init(props: mockPost()))
    }
    
    static func mockFeedSection() -> Section {
        return Section(
            header: nil,
            footer: nil,
            rowsBlock: {
                let spc = RowOfEmptySpace(height: 22)
                
                let all = [getMockPostRow(),
                           getMockPostRow(),
                           spc,
                           getMockPostRow(),
                           getMockPostRow(),
                           getMockPostRow(),
                           getMockPostRow(),
                           spc]
                
                all.separator(style: .fullWidth)
                all.background(color: .white)
                all.childrenHaveSameBackgroundColorAsContainer()
                all.inset(left: 0, right: 0)
                
                spc.backgroundColor = MediumTheme.lightGray
                return all
                
        })
    }
}
