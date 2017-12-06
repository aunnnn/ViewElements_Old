//: Playground - noun: a place where people can play

import PlaygroundSupport
import ViewElements

class CenteredContentViewController: TableModelViewController {
    
    var labelsCount = 0
    
    override func setupTable() {
        
        self.debugMode = true
        let header = Row(ElementOfLabel(props: "Hello Oozou").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 40)
            lb.textAlignment = .center
        }))
        
        let msg1 = Row(ElementOfLabel(props: "This is just a simple demo. \n\nMultilines and autolayout are handled automatically.\nA row of empty space (below, in blue) can be used to style the layout.").styles({ (lb) in
            lb.textAlignment = .center
        }))
        msg1.backgroundColor = .yellow
        
        let spc20 = RowOfEmptySpace(height: 40)
        spc20.backgroundColor = .blue
        spc20.tag = "space"

        let msg2 = Row(ElementOfLabel(props: "Button and tap action are also supported."))
        let bttn1 = Row(ElementOfButtonWithAction(props: (title: "Press to add label", handler: { [unowned self] in
            self.buttonPressed()
        })).styles({ (bttn) in
            bttn.backgroundColor = .lightGray
        }))
        
        let rows = [header, msg1, spc20, msg2, bttn1]
        
        let section = Section(rows: rows)
        //        do {
        //            let header = SectionHeader(ElementOfLabel(props: "Header!"))
        //            header.backgroundColor = .orange
        //
        //            let footer = SectionFooter(ElementOfLabel(props: "Footer!"))
        //            footer.backgroundColor = .orange
        //
        //            section.header = header
        //            section.footer = footer
        //        }
        let table = Table(sections: [section])
        self.table = table
    }
    
    func buttonPressed() {
        
        labelsCount += 1
        let s = "Label: \(labelsCount)"
        
        let lb = Row(ElementOfLabel(props: s))
        self.table.sections.first?.rows.append(lb)
        self.tableView.reloadData()
    }
}

let cv = CenteredContentViewController()
cv.view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 576)

PlaygroundPage.current.liveView = cv.view
