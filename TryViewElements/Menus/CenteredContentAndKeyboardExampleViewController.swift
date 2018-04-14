//
//  CenteredContentAndKeyboardExampleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 3/24/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

final class CenteredContentAndKeyboardExampleViewController: TableModelViewController {
    override func setupTable() {
        let txtFldMaker: (String) -> Row = {
            let txtfld = Row(ElementOfTextField(props: (nil, $0)).styles({ (tf) in
                tf.textAlignment = .center
            }))
            txtfld.backgroundColor = .lightText
            return txtfld
        }

        let headingRow = Row(ElementOfLabel(props: "Login here").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            lb.textAlignment = .center
        }))

        let rows: [Row] = [
            headingRow,
            txtFldMaker("Username"),
            txtFldMaker("Password"),
        ]

        rows.forEach { (r) in
            r.backgroundColor = .yellow
        }

        let table = Table(sections: [Section(rows: rows)])
        table.centersContentIfPossible = true
        self.table = table
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
