//: [Previous](@previous)

import PlaygroundSupport
import ViewElements

//ViewElements.debugMode = true

class CenteredContentViewController: TableModelViewController {
    
    override func setupTable() {
            
        let header = Row(ElementOfLabel(props: "Hello World").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 40)
            lb.textAlignment = .center
        }))
        
        let msg1 = Row(ElementOfLabel(props: "This is just a simple demo. Below is a space of 22 pts:").styles({ (lb) in
            lb.textAlignment = .center
        }))
        
        let spc20 = RowOfEmptySpace(height: 22)
        spc20.backgroundColor = .gray
        spc20.tag = "space"
        
        let bttn1 = Row(ElementOfButtonWithAction(props: (title: "Press me!", handler: { [unowned self] in
            self.increaseSpace()
        })).styles({ (bttn) in
            bttn.backgroundColor = .lightGray
        }))
        
        let rows = [header, msg1, spc20, bttn1]
        
        let section = Section(rows: rows)
        do {
            let header = SectionHeader(ElementOfLabel(props: "Header!"))
            header.backgroundColor = .orange
            
            let footer = SectionFooter(ElementOfLabel(props: "Footer!"))
            footer.backgroundColor = .orange
            
            section.header = header
            section.footer = footer
        }
        self.table = Table(sections: [section])
    }
    
    func increaseSpace() {
        
        let sgm = Row(ElementOfSegmentedControl(props: (["one", "two","three"], 0)))
        sgm.rowHeight = 50
        self.table.sections.first?.rows.append(sgm)
        self.tableView.reloadData()
    }
}

let cv = CenteredContentViewController()
cv.view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 576)

// Live result. If doesn't show, try close Xcode and reopen.
PlaygroundPage.current.liveView = cv.view
