//: Playground - noun: a place where people can play

import PlaygroundSupport
import ViewElements

class InputRowComponent: ComponentOf<(title: String, placeholder: String, defaultText: String?, isSecured: Bool)> {
    override func render() -> StackProps {
        let el1 = ElementOfLabel(props: self.props.title).styles { (lb) in
            lb.al_fixedWidth(width: 80)
            lb.backgroundColor = .lightGray
        }
        let txtfld = ElementOfTextField(props: (props.defaultText, props.placeholder)).styles { (tf) in
            tf.cornerRadius(4)
            tf.border(width: 1, color: .black)
            tf.backgroundColor = .yellow
            tf.textColor = .black
            tf.font = .systemFont(ofSize: 12)
            tf.al_fixedHeight(height: 44)
            tf.isSecureTextEntry = self.props.isSecured
        }

        return HorizontalStack(
            distribute: .fill,
            align: .top,
            spacing: 8, [el1,txtfld])
    }
}

class TestViewController: TableModelViewController {
    override func setupTable() {
    
        let table = Table(rowsBlock: { () -> [Row] in
            let lb1 = Row(ElementOfLabel(props: "Welcome!").styles({ (lb) in
                lb.font = UIFont.boldSystemFont(ofSize: 30)
                lb.textAlignment = .center
            }))
            lb1.rowHeight = 100
            
            let lb2 = Row(ElementOfLabel(props: "Please login to use the system:").styles({ (lb) in
                lb.backgroundColor = UIColor.groupTableViewBackground
            }))
            
            let usr = Row(InputRowComponent(props: ("Username", "Your username here.", "aunnnn", false)))
            
            let pwd = Row(InputRowComponent(props: ("Password", "Your password here.", nil, true)))
            
            let login = Row(ElementOfButton(props: "Login").styles({ (bttn) in
                bttn.al_fixedWidth(width: 100)
                bttn.al_fixedHeight(height: 32)
                bttn.backgroundColor = .black
                bttn.setTitleColor(.white, for: .normal)
                bttn.cornerRadius(6)
            }))
            
            let spc20 = RowOfEmptySpace(height: 20)
            spc20.backgroundColor = .gray
            
            login.layoutMarginsStyle = Row.LayoutMarginStyle.each(vertical: 8, horizontal: 40)
            
            let rows = [spc20, lb1, lb2, usr, pwd, login, spc20]
            return rows
        })
        table.centersContentIfPossible = true
        self.table = table
    }
}
let cv = TestViewController()


cv.view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 576)

// Live result. If doesn't show, try close Xcode and reopen.
PlaygroundPage.current.liveView = cv.view

