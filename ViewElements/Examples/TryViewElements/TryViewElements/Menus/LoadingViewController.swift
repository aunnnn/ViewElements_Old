//
//  LoadingViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/1/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class LoadingViewController: TableModelViewController {
    
    override func setupTableViewModel() {
        
        let table = Table { () -> [Row] in
            let ld = Row(ElementOfActivityIndicator())
            ld.rowHeight = 64
            return [ld]
        }
        self.tableViewModel = table
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.didLoadContent()
        }
    }
    
    func didLoadContent() {
    
        let section1 = Section(header: nil, footer: nil) {
            let lb1 = Row(ElementOfLabel(props: "Loading finished").styles({ (lb) in
                lb.textAlignment = .center
            }))
            
            let lb2 = Row(ElementOfLabel(props: "How easy was that?\n\nIf you don't want any animations, just call reloadData(). Here I use table view's animation.").styles({ (lb) in
                lb.textAlignment = .center
            }))
            
            [lb1, lb2].inset(left: 16, right: 16)
            
            return [
                RowOfEmptySpace(height: 20),
                lb1,
                lb2,
            ]
        }
        
        let section2 = TwitterFeedWithNibViewController.mockFeedSection()
        
        self.tableViewModel = Table(sections: [section1, section2])
        
        let inds = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0)]
        let del = [IndexPath(item: 0, section: 0)]
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: del, with: .automatic)
        self.tableView.insertRows(at: inds, with: .automatic)
        self.tableView.insertSections([1], with: .automatic)
        self.tableView.endUpdates()
    }
}

fileprivate func getMockPostRow() -> Row {
    return Row(ElementOf<TwitterPostCardView>.init(props: mockPost()))
}
