//: Playground - noun: a place where people can play

import PlaygroundSupport
import ViewElements

ViewElements.debugMode = true

class CenteredContentViewController: TableModelViewController {
    
    var labelsCount = 0
    
    override func setupTable() {
        
        let header = Row(ElementOfLabel(props: "Hello World"))
        
        let msg1 = Row(ElementOfLabel(props: "This is just a simple demo. \n\nMultilines and autolayout are handled automatically.\nA row of empty space (below, in blue) can be used to style the layout."))
        
        let bttn1 = Row(ElementOfButtonWithAction(props: (title: "Press to add label", handler: { [unowned self] in
            self.buttonPressed()
        })))
        
        let rows = [
            header,
            msg1,
            bttn1,
        ]
        
        let section = Section(rows: rows)
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
