//
//  TapToLoadMoreViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/1/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TapToLoadMoreViewController: TableModelViewController {
    override func setupTableViewModel() {
        
        let table = Table { () -> [Row] in
            let ld = Row(ElementOfLabel(props: "Hello world").styles({ (lb) in
                lb.textColor = .black
                lb.textAlignment = .center
            }))
            ld.rowHeight = 64
            
            let load = Row(ElementOfLabel(props: "Load more...").styles({ (lb) in
                lb.textColor = .blue
                lb.textAlignment = .center
            }))
            load.didSelectRow = { [weak self] row in
                self?.loadMore()
            }
            load.rowHeight = 36
            return [ld, load]
        }
        self.tableViewModel = table
    }
    
    func loadMore() {
        let table = Table { () -> [Row] in
            let ld = Row(ElementOfLabel(props: "Loading, please wait").styles({ (lb) in
                lb.textColor = .black
                lb.textAlignment = .center
            }))
            ld.rowHeight = 64
            
            let loading = Row(ElementOfActivityIndicator())
            loading.rowHeight = 36
            return [ld, loading]
        }
        self.tableViewModel = table
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.didLoadContent()
        }
        
        self.tableViewModel = table
        self.tableView.reloadData()
    }
    
    func didLoadContent() {
        
        let lb = Row(ElementOfLabel(props: "Loading finished!\nYour content is below.\n\nYou might notice why I'm so verbose here. I'm just randomly typing texts to show you that the content height of the first row is also animated beautifully.\n\nI also added a separator of this row for you...").styles({ (lb) in
            lb.textColor = .black
            lb.textAlignment = .center
        }))
        lb.separatorStyle = .fullWidth
        
        let feedRows = TwitterFeedWithNibViewController.mockFeedSection().rows
        let section = Section(header: nil, footer: nil, rows: [lb] + feedRows)
        
        let table = Table(sections: [section])
        
        self.tableViewModel = table
        
        self.tableView.beginUpdates()
        self.tableView.reloadSections([0], with: .automatic)
        self.tableView.endUpdates()
    }
    
}
