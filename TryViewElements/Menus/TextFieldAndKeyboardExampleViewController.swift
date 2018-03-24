//
//  TextFieldAndKeyboardExampleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 3/24/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import ViewElements

final class TextFieldAndKeyboardExampleViewController: TableModelViewController {
    override func setupTable() {

        let txtFldMaker: () -> Row = {
            let txtfld = Row(ElementOfTextField(props: (nil, "type here...")))
            txtfld.backgroundColor = .lightText
            return txtfld
        }

        let lbMaker: () -> Row = {
            let lb = Row(ElementOfLabel(props: "Tap here to dismiss\n... ... ..."))
            lb.didSelectRow = { [weak self] _ in
                self?.tapOutside()
            }
            return lb
        }

        let rows: [Row] = (0...9).flatMap { (i: Int) -> [Row] in
            if i % 2 == 0 {
                return [lbMaker(), lbMaker()]
            } else {
                return [txtFldMaker()]
            }
        }

        rows.forEach { (r) in
            r.backgroundColor = .lightGray
        }

        let table = Table(sections: [Section(rows: rows)])
        self.table = table
    }

    func tapOutside() {
        self.view.endEditing(true)
    }
}
