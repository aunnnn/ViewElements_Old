//
//  TailLoadingViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/1/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TailLoadingViewController: TableModelViewController {
    
    var isLoading = false
    
    override func setupTableViewModel() {
        
        let loadingSection = Section(header: nil, footer: nil, rows: [{
            let row = Row(ElementOfActivityIndicator())
            row.rowHeight = 44
            row.tag = "loading"
            return row
            }()
            ])
        let table = Table(sections: [
            TwitterFeedWithNibViewController.mockFeedSection(),
            loadingSection
            ])
        self.tableViewModel = table
    }
    
    override func tableModelViewControllerWillDisplay(row: Row, at indexPath: IndexPath) {
        if row.tag == "loading" && !isLoading {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.tableViewModel.sections[0].rows.append(contentsOf: TwitterFeedWithNibViewController.mockFeedSection().rows)
                self?.tableView.reloadData()
                self?.isLoading = false
            }
        }
    }
}
