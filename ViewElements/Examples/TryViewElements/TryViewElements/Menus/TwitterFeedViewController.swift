//
//  TwitterFeedViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TwitterFeedViewController: TableModelViewController {
    
    override func setupTableViewModel() {
        let section1 = Section(
            header: nil,
            footer: nil,
            rowsBlock: {
                let spc = RowOfEmptySpace(height: 22)
                
                let all = [getMockPostRow(),
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
        self.tableViewModel = Table.init(sections: [section1, section2])
        self.tableViewModel.guessesSimilarHeightForCellsWithSameType = true
        self.tableViewModel.headerView = TableHeaderView(ElementOfLabel(props: "Note: Here you will notice that scrolling is not smooth. It seems that complex component is kind of expensive. Basically it's just nested UIStackViews. \n\nWith table header view it's even more slow (significantly) with reason I don't know yet.\n\nIf you have any tips on how to improve this, let me know. For now, avoid complex Component!").styles({ (lb) in
            lb.font = UIFont.italicSystemFont(ofSize: 14)
            lb.textColor = .gray
        }))
        self.tableViewModel.headerView?.layoutMarginsStyle = .inset(top: 12, left: 22, bottom: 12, right: 22)
        self.tableViewModel.headerView?.backgroundColor = .lightText
        
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
            ])
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
            lb.setContentCompressionResistancePriority(100, for: .horizontal)
        }
        
        let elDate = ElementOfLabel(props: self.props.2).styles { (lb) in
            lb.font = UIFont.systemFont(ofSize: 12)
            lb.textColor = .gray
            lb.numberOfLines = 1
            lb.setContentCompressionResistancePriority(1000, for: .horizontal)
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
