//
//  TwitterFeedViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TwitterFeedViewController: TableModelViewController {
    
    override func setupTable() {
        let section1 = Section(
            header: nil,
            footer: nil,
            rowsBlock: {
                let spc = RowOfEmptySpace(height: 22)

                let guessHeightIntroLabel = Row(ElementOfLabel(props: "This example also demonstrates the use of `table.guessesSimilarHeightForCellsWithSameType`.\n\nSetting this to true will update estimated height for subsequent Rows to those (with same types) that are already on screen. This is quick and dirty way to alleviate the 'jumping scroll indicators problem' on the fully-AutoLayouted cells, *IFF you're confident that same type of cells will have similar heights*.").styles({ (lb) in
                    lb.textColor = .blue
                }))
                guessHeightIntroLabel.layoutMarginsStyle = .all(inset: 10)

                let all = [
                    guessHeightIntroLabel,
                    getMockPostRow(),
                    getMockPostRow(),
                    spc,
                    getMockPostRow(),
                    getMockPostRow(),
                    getMockPostRow(),
                    getMockPostRow(),
                    spc]
                all.forEach({ (r) in
                    r.layoutMarginsStyle = Row.LayoutMarginStyle.inset(top: 8, left: 12, bottom: 8, right: 8)
                    r.separatorStyle = .fullWidth
                })
                return all
            
        })

        let hd = SectionHeader(ElementOfLabel(props: "In case you've missed it").styles({ (lb) in
            lb.font = UIFont.systemFont(ofSize: 20)
        }))
        
        let section2 = Section.init(
        header: hd,
        footer: nil) { () -> [Row] in
            let spc = RowOfEmptySpace(height: 22)
            let all = [
                getMockPostRow(),
                getMockPostRow(),
                getMockPostRow(),
                spc,
            ] + (0...10).map { _ in getMockPostRow() }
            all.forEach({ (r) in
                r.layoutMarginsStyle = Row.LayoutMarginStyle.inset(top: 8, left: 12, bottom: 8, right: 8)
                r.separatorStyle = .fullWidth
            })
            return all
        }
        section1.rows.background(color: .white)
        section1.rows.childrenHaveSameBackgroundColorAsContainer()
        
        section2.rows.background(color: .white)
        section2.rows.childrenHaveSameBackgroundColorAsContainer()
        self.table = Table.init(sections: [section1, section2])
        self.table.guessesSimilarHeightForCellsWithSameType = true
        self.table.headerView = TableHeaderView(ElementOfLabel(props: "Twitter card created with Component.\n\nEach card here is created entirely from Component (nesting stack views together). It might be slower than using nib.").styles({ (lb) in
            lb.font = UIFont.italicSystemFont(ofSize: 14)
            lb.textColor = .gray
        }))
        self.table.headerView?.layoutMarginsStyle = .inset(top: 12, left: 22, bottom: 12, right: 22)
        self.table.headerView?.backgroundColor = .lightText
        
        self.tableView.backgroundColor = .lightText
    }
}

fileprivate func getMockPostRow() -> Row {
    return Row(PostComponent(props: mockPost()))
}

fileprivate class PostComponent: ComponentOf<TwitterPost> {
    fileprivate override func shouldElementUpdate(oldProps: TwitterPost, newProps: TwitterPost) -> Bool {
        return oldProps != newProps
    }
    
    fileprivate override func render() -> StackProps {
        let elUserPic = ElementOfImageView(props: self.props.userPic).styles { (imv) in
            imv.al_fixedSize(width: 50, height: 50)
            imv.layer.cornerRadius = 4
            imv.layer.masksToBounds = true
        }
        
        return HorizontalStack(distribute: .fill, align: .top, spacing: 8, [
                elUserPic,
                PostContentComponent(props: self.props),
            ])
    }
}

fileprivate class PostContentComponent: ComponentOf<TwitterPost> {
    fileprivate override func shouldElementUpdate(oldProps: TwitterPost, newProps: TwitterPost) -> Bool {
        return oldProps != newProps
    }
    
    fileprivate override func render() -> StackProps {
        let authorData: (String, String, String) = (self.props.author, self.props.username, self.props.relativeDate)
        let elContent = ElementOfLabel(props: self.props.content).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 13)
            lb.textColor = .black
        }
        
        let elImage = ElementOfImageView(props: self.props.image ?? #imageLiteral(resourceName: "img1.png")).styles { (imv) in
            imv.translatesAutoresizingMaskIntoConstraints = false
            imv.al_aspectRatio(width: 1, height: 0.6)
            imv.contentMode = .scaleAspectFill
            imv.layer.cornerRadius = 4
            imv.layer.masksToBounds = true
            imv.backgroundColor = .gray
        }
        return VerticalStack(distribute: .fill, align: .leading, spacing: 4, [
            AuthorTopRowComponent(props: authorData),
            elContent,
            elImage,
            ActionsPanelComponent(props: ()),
            ]).fillsHorizontally(true)
    }
}

fileprivate class AuthorTopRowComponent: ComponentOf<(String, String, String)> {
    fileprivate override func shouldElementUpdate(oldProps: (String, String, String), newProps: (String, String, String)) -> Bool {
        return oldProps != newProps
    }
    fileprivate override func render() -> StackProps {
        let elAuthor = ElementOfLabel(props: self.props.0).styles { (lb) in
            lb.font = UIFont.boldSystemFont(ofSize: 16)
            lb.numberOfLines = 1
        }
        
        let elUsername = ElementOfLabel(props: self.props.1).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 12)
            lb.textColor = .gray
            lb.numberOfLines = 1
            lb.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 100), for: .horizontal)
        }
        
        let elDate = ElementOfLabel(props: self.props.2).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 12)
            lb.textColor = .gray
            lb.numberOfLines = 1
            lb.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        }
        
        let elAction = ElementOfButton(props: "V").styles { (bt) in
            bt.setTitleColor(.gray, for: .normal)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            bt.titleLabel?.numberOfLines = 1
        }
        
        return HorizontalStack(distribute: .equalSpacing, align: .bottom, spacing: 2, [
                elAuthor,
                elUsername,
                elDate,
                FlexibleSpace(),
                elAction,
            ])
    }
}

fileprivate class ActionsPanelComponent: ComponentOf<Void> {
    
    fileprivate override func shouldElementUpdate(oldProps: Void, newProps: Void) -> Bool {
        return false
    }
    
    fileprivate override func render() -> StackProps {
        let reply = ElementOfButton(props: "Reply").styles { (bt) in
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            bt.setTitleColor(.gray, for: .normal)
            bt.setTitleColor(.blue, for: .highlighted)
        }
        let retweet = ElementOfButton(props: "Retweet").styles { (bt) in
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            bt.setTitleColor(.gray, for: .normal)
            bt.setTitleColor(.green, for: .highlighted)
        }
        let like = ElementOfButton(props: "Like").styles { (bt) in
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            bt.setTitleColor(.gray, for: .normal)
            bt.setTitleColor(.red, for: .highlighted)
        }
        let share = ElementOfButton(props: "Share").styles { (bt) in
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            bt.setTitleColor(.gray, for: .normal)
            bt.setTitleColor(.black, for: .highlighted)
        }
        return HorizontalStack(distribute: .fillEqually, align: .center, spacing: 4, [
            reply, retweet, like, share
        ])
    }
}
