//: Playground - noun: a place where people can play

import PlaygroundSupport
import ViewElements

class DemoViewController: TableModelViewController {
    override func setupTable() {
        
        let title = Row(ElementOfLabel(props: "Hello World!").styles({ (lb) in
            lb.textAlignment = .center
            lb.font = UIFont.boldSystemFont(ofSize: 22)
            lb.backgroundColor = .green
        }))
        
        let texts = [
            "ViewElements is so good.",
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.",
            "You can reuse elements with ease!",
            "No need to worry about overflowing content on any page, if you use table view as a basis."
            ].map { t -> Row in
                return Row(ElementOfLabel(props: t).styles({ (lb) in
                    lb.textAlignment = .right
                }))
        }
        
        let rows = [title] + texts
        let section = Section(rows: rows)
        let table = Table(sections: [section])
        
        self.table = table
    }
}

let cv = DemoViewController()
cv.view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 576)

PlaygroundPage.current.liveView = cv.view

