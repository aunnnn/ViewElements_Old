//
//  MediumFeedViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/28/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

struct MediumTheme  {
    static var lightGray: UIColor {
        return UIColor.init(red: 250/255.0, green: 251/255.0, blue: 252/255.0, alpha: 1)
    }
    
    static var green: UIColor {
        return UIColor.init(red: 68.0/255, green: 151.0/255, blue: 82.0/255, alpha: 1.0)
    }
}

class MediumFeedViewController: TableModelViewController {
    
    override func setupTable() {
        self.tableView.backgroundColor = MediumTheme.lightGray
        let table = Table(sections: [MediumFeedViewController.mockFeedSection()])
        table.guessesSimilarHeightForCellsWithSameType = true
        self.table = table
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MediumArticleViewController(style: .plain)
        self.show(vc, sender: nil)
    }
    
    static func mockFeedSection() -> Section {
        return Section(header: nil, footer: nil) {
            let titleRow = Row(ElementOfLabel(props: "New for you").styles({ (lb) in
                lb.font = UIFont.boldSystemFont(ofSize: 16)
            }))
            titleRow.backgroundColor = MediumTheme.lightGray
            titleRow.layoutMarginsStyle = .inset(top: 24, left: 24, bottom: 12, right: 24)
            titleRow.separatorStyle = .fullWidth
            
            let posts: [[Row]] = (0...6).map { (num: Int) in
                let spc = RowOfEmptySpace(height:14)
                if num != 6 {
                    spc.separatorStyle = .fullWidth
                    spc.backgroundColor = MediumTheme.lightGray
                }
                let post = MediumFeedViewController.postRow()
                post.background(color: .white)
                return (post + [spc])
            }
            
            let all = [titleRow] + posts.flatMap { $0 }
            all.childrenHaveSameBackgroundColorAsContainer()
            return all
        }
    }
    
    static func postRow() -> [Row] {
        let userImg: UIImage = {
            switch (arc4random() % 3) {
            case 0: return #imageLiteral(resourceName: "user1.jpg")
            case 1: return #imageLiteral(resourceName: "user2.jpg")
            case 2: return #imageLiteral(resourceName: "user3.jpg")
            default: return #imageLiteral(resourceName: "user1.jpg")
            }
        }()
        
        let randomAuthor: String = {
            switch (arc4random() % 3) {
            case 0: return "James Atlucher"
            case 1: return "Wirawit Rueopas"
            case 2: return "Bob the iOS Developer"
            default: return "James and Merry Christsake"
            }
        }()
        
        let randomDate: String = {
            switch (arc4random() % 3) {
            case 0: return "May 23 - 6 min read"
            case 1: return "May 20 - 3 min read"
            case 2: return "Jan 20 - 2 min read"
            default: return "Mar 3 - 3 min read"
            }
        }()
        
        let randomContent: (String, String?) = {
            switch (arc4random() % 3) {
            case 0: return ("10 Things That Will Help You Start Living A Surprisingly Fulfilling Life", "A.K.A How To Be Happy")
            case 1: return ("This Morning Routine will Save You 20+ Hours Per Week", nil)
            case 2: return ("Melania Trump isn't a black and white issue", "While joining her husband on a foreign trip, Melania Trump was captured swatting...")
            default: return ("Alex Tizon's Brutal Honesty", nil)
            }
        }()
        
        let randomImage: UIImage? = {
            switch (arc4random() % 3) {
            case 0: return nil
            case 1: return #imageLiteral(resourceName: "cog.jpg")
            case 2: return #imageLiteral(resourceName: "img1.png")
            default: return #imageLiteral(resourceName: "cog.jpg")
            }
        }()
        let mockInfo = UserInfo.init(img: userImg, authorTitle: randomAuthor, dateAndReadTime: randomDate)
        let mockPost = MediumPost(userInfo: mockInfo, title: randomContent.0, detail: randomContent.1, image: randomImage, hearts: 74, responses: 4)
        
        let userInfo = Row(UserInfoComponent.init(props: mockInfo))
        
        let title = Row(ElementOfLabel(props: mockPost.title).styles { (lb) in
            lb.font = UIFont.boldSystemFont(ofSize: 24)
            }.name("title"))
        
        let detail: Row? = mockPost.detail != nil ? Row(ElementOfLabel(props: mockPost.detail!).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 18)
            lb.textColor = .gray
            }.name("detail")) : nil
        
        let image: Row? = mockPost.image != nil ? Row(ElementOfImageView(props: mockPost.image!).styles { (imv) in
            let h = imv.heightAnchor.constraint(equalTo: imv.widthAnchor, multiplier: 0.6)
            h.isActive = true
            h.priority = UILayoutPriority(rawValue: 999)
            imv.contentMode = .scaleAspectFill
            }.name("image")) : nil
        
        let readmore = Row(ElementOfLabel(props: "Read more...").styles { (lb) in
            lb.textColor = .lightGray
            lb.font = UIFont.systemFont(ofSize: 12)
            }.name("readmore"))
        readmore.separatorStyle = .custom(left: 20, right: 20)
        readmore.rowHeight = 40
        
        let actions = Row(MediumActionsPanelComponent(props: (76, 4)))
        actions.separatorStyle = .fullWidth
        actions.rowHeight = 44
        
        let recommend: [Row] = {
            if arc4random() % 2 == 1 {
                let rec = ElementOfLabel(props: "Wirawit and 32 others recommended").styles({ (lb) in
                    lb.font = UIFont.systemFont(ofSize: 12)
                    lb.textColor = UIColor.lightGray
                })
                return [Row(rec)]
            } else {
                return []
            }
        }()
        
        let all = recommend + [
            userInfo,
            title,
            detail,
            image,
            readmore,
            actions,
            ].compactMap { $0 }
        
        all.inset(left: 20, right: 20)
        
        recommend.first?.layoutMarginsStyle = .inset(top: 8, left: 20, bottom: 4, right: 20)
        image?.layoutMarginsStyle = .inset(top: 8, left: 20, bottom: 8, right: 20)
        userInfo.layoutMarginsStyle = .inset(top: 16, left: 20, bottom: 8, right: 16)
        return all
    }

}

struct MediumPost {
    let userInfo: UserInfo
    let title: String
    let detail: String?
    let image: UIImage?
    let hearts: Int
    let responses: Int
}

struct UserInfo {
    let img: UIImage
    let authorTitle: String
    let dateAndReadTime: String
}

class UserInfoComponent: ComponentOf<UserInfo> {
    override func shouldElementUpdate(oldProps: UserInfo, newProps: UserInfo) -> Bool {
        return oldProps.authorTitle != newProps.authorTitle
    }
    
    override func render() -> StackProps {
        let img = ElementOfImageView(props: self.props.img).styles { (imv) in
            imv.al_fixedSize(width: 44, height: 44)
            imv.layer.cornerRadius = 22
            imv.layer.masksToBounds = true
        }
        let author = ElementOfLabel(props: self.props.authorTitle).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 16)
            lb.textColor = UIColor.darkText
        }
        let date = ElementOfLabel(props: self.props.dateAndReadTime).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 12)
            lb.textColor = UIColor.gray
        }
        let more = ElementOfButton(props: "...").styles { (bttn) in
            bttn.setTitleColor(UIColor.gray, for: .normal)
            bttn.setTitleColor(UIColor.blue, for: .highlighted)
            bttn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            bttn.al_fixedWidth(width: 44)
        }
        return HorizontalStack(distribute: .fill, align: .top, spacing: 8, [
                img,
                VerticalStack(distribute: .fill, align: .leading, spacing: 2, [
                    author,
                    date
                    ]),
                more,
            ])
    }
}

typealias ActionsPanelProps = (hearts: Int, responses: Int)

class MediumActionsPanelComponent: ComponentOf<ActionsPanelProps> {
    override func shouldElementUpdate(oldProps: ActionsPanelProps, newProps: ActionsPanelProps) -> Bool {
        return oldProps != newProps
    }
    
    override func render() -> StackProps {
        let heartEl = ElementOfButton(props: "Heart \(self.props.hearts)").styles { (bttn) in
            bttn.setTitleColor(UIColor.gray, for: .normal)
            bttn.setTitleColor(MediumTheme.green, for: .highlighted)
            bttn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        let responsesEl = ElementOfLabel(props: "\(self.props.responses) responses").styles { (lb) in
            lb.numberOfLines = 1
            lb.font = UIFont.systemFont(ofSize: 13)
        }
        
        let bmEl = ElementOfButton(props: "BM").styles { (bttn) in
            bttn.setTitleColor(UIColor.gray, for: .normal)
            bttn.setTitleColor(MediumTheme.green, for: .highlighted)
            bttn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        return HorizontalStack(distribute: .fill, align: .center, spacing: 8, [
            heartEl,
            responsesEl,
            FlexibleSpace(),
            bmEl,
        ])
    }
}
