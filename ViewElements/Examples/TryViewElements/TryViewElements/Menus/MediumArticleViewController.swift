//
//  MediumArticleViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class MediumArticleViewController: TableModelViewController {
    override func setupTable() {
        let f1 = SectionFooter(MediumArticleComponent.ActionPanel(props: (376, 5)))
        f1.backgroundColor = MediumTheme.lightGray
        f1.layoutMarginsStyle = .inset(top: 8, left: 12, bottom: 8, right: 12)
        
        let s1 = Section(
            header: nil,
            footer: f1,
            rowsBlock: {
                
                let mockUser = MediumArticleUserInfo.init(
                    img: #imageLiteral(resourceName: "user1.jpg"),
                    name: "Framer Team",
                    detail: "Design everything with the power of code. Start you free trial at www.framer.com.",
                    dateAndReadTime: "April 26 - 4 min read",
                    hr: (376, 5))
                let user = Row(MediumArticleComponent.AuthorInfo(props: mockUser))
                let title = Row(MediumArticleComponent.Title(s: "Designing the all-new Framer"))
                
                let ps = [
                    "What do all these have in common? White, male, mostly dead (as in, Higgs and Hawking are not dead; not the Princess Bride sense: we’re not about to revive Dirac by sticking a chocolate-coated ball down his throat. No: all we can do now is go through their pockets and look for loose change). (Loved the film? Read the book; it’s beautiful. Read the book? Watch Stardust; a noble attempt to capture the same adult fairy-tale aesthetic).",
                    "Where were we? Ah yes: White, male, mostly dead. And theoretical physicist. Every single one.",
                    #imageLiteral(resourceName: "cog.jpg"),
                    "-Building blocks front and center.",
                    "A modern lament in science is “Where are the Einsteins?” Which roughly translates as: “where are the lone geniuses who revolutionise research?” We’ve just met the answer. Lone geniuses who revolutionise research are all theorists. But no field other than physics takes theory as the bedrock of its research. So no other field recognises its lone geniuses — all our Einsteins are lost.",
                    "Neuroscience had one, who flamed brightly but all too briefly. His body of work is jaw-dropping. I’d never met him, and you’ve never heard of him.",
                    "He was David Marr.",
                    #imageLiteral(resourceName: "img1.png"),
                    "-Canvas and code, united.",
                    "Let’s do the Einstein checklist. Miraculous achievements in rapid succession at a young age? Check.\nIn three years Marr published three extraordinary sole-author papers, on computational models of the cerebellum (1969), cortex (1970), and hippocampus (1971). Each proposed a ground-breaking theory: that cerebellum learnt to correct motor errors; that cortex can act as a general purpose learning device; that hippocampus can act as a temporary storage for events, and recall them even if some information is missing. All these theories have found their way into the very foundations of research on these brains regions, even if the current practitioners have no idea where they came from.",
                    "There is no standard and universal way to define mixins in JavaScript. In fact, several features to support mixins were dropped from ES6 today. There are a lot of libraries with different semantics. We think that there should be one way of defining mixins that you can use for any JavaScript class. React just making another doesn’t help that effort.",
                    "-Utility Functions",
                    "This case is a no-brainer. If you use mixins to share utility functions, extract them to modules and import and use them directly.",
                    "-Lifecycle Hooks and State Providers",
                    "This is the main use case for mixins. If you’re not very familiar with React’s mixin system, it tries to be smart and “merges” lifecycle hooks. If both the component and the several mixins it uses define the componentDidMount lifecycle hook, React will intelligently merge them so that each method will be called. Similarly, several mixins can contribute to the getInitialState result.",
                    ].map { (s: Any) -> Row in
                        switch s {
                        case let s as String:
                            if s.characters.first! == "-" {
                                let start = s.index(s.startIndex, offsetBy: 1)
                                let end = s.index(s.endIndex, offsetBy: 0)
                                let sub = s.substring(with: start..<end)
                                return Row(MediumArticleComponent.Header(s: sub))
                            }
                            return Row(MediumArticleComponent.Paragraph(s: s, italic: false))
                        case let img as UIImage:
                            return Row(MediumArticleComponent.Image(img: img))
                        default:
                            fatalError("What!?")
                        }
                }
                
                let ending = Row(MediumArticleComponent.Paragraph(s: "If you liked this, please click the 💚 below so other people can read about it on Medium.", italic: true))
                
                let spc1 = RowOfEmptySpace(height: 8)
                let spc2 = RowOfEmptySpace(height: 18)
                let allRows: [Row] = [spc1, user, spc2, title] + ps + [ending, spc1]
                
                allRows.background(color: .white)
                allRows.childrenHaveSameBackgroundColorAsContainer(value: true)
                allRows.inset(left: 18, right: 18)
                return allRows
                
        })

        let s2 = Section(header: nil, footer: nil) { () -> [Row] in
            let en1 = Row(MediumArticleComponent.EntityDetail(props: (
                #imageLiteral(resourceName: "logo.png"),
                "PUBLISHED IN",
                "Framer",
                "Exploring ideas at the intersection of code, design and tech. The official blog for www.framer.com")))
            let en2 = Row(MediumArticleComponent.EntityDetail(props: (
                #imageLiteral(resourceName: "user1.jpg"),
                "WRITTEN BY",
                "Framer Team",
                "Design everything with the power of code. Start your free trial at www.framer.com.")))
            let ens = [en1, en2]
            ens.inset(left: 18, right: 18)
            
            let spc22 = RowOfEmptySpace(height: 22)
            let trailingspc = RowOfEmptySpace(height: 22)
            trailingspc.separatorStyle = .fullWidth
            
            [en1, en2, spc22, trailingspc].background(color: .white)
            
            return [spc22, en1, spc22, en2, trailingspc]
        }
        
        let s3 = Section(header: nil, footer: nil, rowsBlock: { () -> [Row] in
            let spc16 = RowOfEmptySpace(height: 16)
            let header = Row(MediumArticleComponent.OuterSectionHeader(s: "More stories from freeCodeCamp"))
            
            [spc16, header].background(color: MediumTheme.lightGray)
            header.separatorStyle = .fullWidth
            
            let card1 = Row(ElementOf<MediumStoryCardView>.init(props: ("Create Android Recyclerview adapters like a boss with MultiViewAdaptor", "Riyas Ahamed", 182, 23, #imageLiteral(resourceName: "cog.jpg"))))
            let card2 = Row(ElementOf<MediumStoryCardView>.init(props: ("What's the tallest Lego building you can make with these 4 pieces", "yolpos", 23, 0, #imageLiteral(resourceName: "user3.jpg"))))
            let card3 = Row(ElementOf<MediumStoryCardView>.init(props: ("Why do so few people major in computer science?", "Quincy Larson", 117, 7, #imageLiteral(resourceName: "img1.png"))))
            let card4 = Row(ElementOf<MediumStoryCardView>.init(props: ("What if title is short?", "Wirawit Rueopas", 0, 7, #imageLiteral(resourceName: "logo.png"))))
            let cards = [card1, card2, card3, card4]
            cards.background(color: .white)
            cards.childrenHaveSameBackgroundColorAsContainer()
            cards.separator(style: .fullWidth)
            cards.row(height: 80)
            cards.inset(left: 0, right: 0)
            return [spc16, header] + cards
        })
        
        
        
        // CREATE TABLE
        
        let table = Table(sections: [s1, s2, s3])
        table.guessesSimilarHeightForCellsWithSameType = true
        table.headerView = TableHeaderView(ElementOfLabel(props: "Tips: You can set a table header view like here, although you never actually need it since you can use a Row instead.\n\nPS: I actually don't understand how a table header view works with autolayout yet. Prepare that it might break!").styles({ (lb) in
            lb.font = UIFont.italicSystemFont(ofSize: 14)
            lb.textColor = .gray
        }))
        table.headerView?.layoutMarginsStyle = .inset(top: 12, left: 22, bottom: 12, right: 22)
        table.headerView?.backgroundColor = .lightText
        self.table = table
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = MediumTheme.lightGray
    }
    
    override func viewDidLayoutSubviews() {
        self.refreshFooterBorder()
        super.viewDidLayoutSubviews()
    }
    
    // prevent repeatedly updating layer
    var previouslyFloating = false
    var border: CALayer?
    
    func refreshFooterBorder() {
        guard let footer = self.tableView.footerView(forSection: 0) else { return }
        
        if isSectionFooterFloating(section: 0) {
            
            // floating
            if !previouslyFloating {
                self.border = self.border ?? footer.layer.addBorder(edge: .top, color: UIColor.lightGray.withAlphaComponent(0.6), thickness: 1)
                self.border?.isHidden = false
                previouslyFloating = true
            }
        } else {
            
            // un-floating
            if previouslyFloating {
                self.border?.isHidden = true
                previouslyFloating = false
            }
        }
    }
    
    //    var stickyHeaderBar: UIView?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.refreshFooterBorder()
        
//        let trueFooterRectOnScreen = self.view.convert(unfloatingRect.origin, from: scrollView)
//        
//        if trueFooterRectOnScreen.y <= 64 {
//            let stickyHeader: UIView; do {
//                if let h = self.stickyHeaderBar {
//                    stickyHeader = h
//                } else {
//                    let header = footer.element.build()
//                    
//                    let container = footer.buildContainerViewAndWrap(elementView: header)
//                    self.view.addSubview(container)
//                    container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
//                    container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//                    container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//                    container.heightAnchor.constraint(equalToConstant: f.bounds.height).isActive = true
//                    
//                    self.stickyHeaderBar = container
//                    stickyHeader = container
//                }
//            }
//            
//            stickyHeader.isHidden = false
//        } else {
//            self.stickyHeaderBar?.isHidden = true
//        }
    }
}

extension CALayer {
    
    @discardableResult
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) -> CALayer {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
        return border
    }
}
