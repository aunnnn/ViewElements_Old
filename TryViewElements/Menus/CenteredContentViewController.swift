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
            
            let header = Row(ElementOfLabel(props: "Hello World"))
            return [header]
        }
        self.table = table
    }
}
