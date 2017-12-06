//
//  CenteredContentViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 12/1/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class CenteredContentViewController: TableModelViewController {
    
    override func setupTable() {
        let table = Table { () -> [Row] in
            
            let header = Row(ElementOfLabel(props: "Hello World").styles({ (lb) in
                lb.textAlignment = .center
            }))
            let msg = Row(ElementOfLabel(props: "To center the content like this, just set table.centersContentIfPossible = true").styles({ (lb) in
                lb.textAlignment = .center
            }))
            return [header, msg]
        }
        table.centersContentIfPossible = true
        self.table = table
    }
}
