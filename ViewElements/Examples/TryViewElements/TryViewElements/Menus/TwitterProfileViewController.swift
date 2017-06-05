//
//  TwitterProfileViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 6/5/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

class TwitterProfileViewController: TableModelViewController {
    
    private weak var capturedNavigationController: UINavigationController?
    
    private var headerImageView: UIImageView?
    private var navTitlesView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        self.view.backgroundColor = .white
        
        /* Manually manage the tableView's content inset */
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        do /* Make header image view */ {
            
            let headerImageView = UIImageView(image: #imageLiteral(resourceName: "background.png"))
            self.headerImageView = headerImageView
            headerImageView.translatesAutoresizingMaskIntoConstraints = false
            headerImageView.clipsToBounds = true
            headerImageView.contentMode = .scaleAspectFill
            headerImageView.isUserInteractionEnabled = false
            self.view.insertSubview(headerImageView, belowSubview: self.tableView)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            headerImageView.addSubview(blurEffectView)
            blurEffectView.al_pinToEdges(ofView: headerImageView)
            blurEffectView.alpha = 0.1
            
            do {
                let nameLabel = UILabel()
                nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
                nameLabel.textAlignment = .center
                nameLabel.textColor = .white
                nameLabel.text = "Wirawit Rueopas"
                
                let tweetCountLabel = UILabel()
                tweetCountLabel.font = UIFont.systemFont(ofSize: 12)
                tweetCountLabel.textAlignment = .center
                tweetCountLabel.textColor = .white
                tweetCountLabel.text = "25.2K Tweets"
                
                let titlesView = UIStackView(arrangedSubviews: [nameLabel, tweetCountLabel])
                titlesView.distribution = .fill
                titlesView.axis = .vertical
                titlesView.alignment = .center
                
                blurEffectView.contentView.addSubview(titlesView)
                
                self.navTitlesView = titlesView
            }
            
            do /* AutoLayout */ {
                
                /* Keep top of header above top of root view (e.g., top anchor for stretchy effect)  */
                headerImageView.topAnchor.constraint(lessThanOrEqualTo: self.view.topAnchor).isActive = true
                
                /* Pin left, right */
                headerImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                headerImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                
                /* Keep bottom at least below top of root + 64 (nav bar's height) */
                headerImageView.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 64).isActive = true
                
                do /* Default height is 64+44, (nav+offset) */ {
                    let heightAnchor = headerImageView.heightAnchor.constraint(equalToConstant: 66+44)
                    heightAnchor.priority = 999
                    heightAnchor.isActive = true
                }
                
                do /* Pin bottom of header image with top of tableHeaderView + 44 (e.g. bottom anchor for stretchy effect) */ {
                    let bottomToTableHeaderAnchor = headerImageView.bottomAnchor.constraint(
                        equalTo: self.tableView.tableHeaderView!.topAnchor,
                        constant: 44)
                    bottomToTableHeaderAnchor.priority = 999
                    bottomToTableHeaderAnchor.isActive = true
                }
            }
            
        }
        
        do /* Not let the top of avatar pass the nav area (top + 70) */ {
            let c = (self.tableView.tableHeaderView!.subviews.first! as! TwitterProfileHeaderView).imageView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 70)
            c.priority = 999
            c.isActive = true
        }
    }
    
    override func setupTable() {
        let sheader = SectionHeader(TwitterProfileMenuComponent(props: ["TWEETS", "TWEETS & REPLIES", "MEDIA", "LIKES"]))
        let section1 = Section(header: sheader, footer: nil, rows: TwitterFeedWithNibViewController.mockFeedSection().rows)
        let table = Table(sections: [section1])
        table.headerView = { () -> TableHeaderView in
            let h = TableHeaderView(ElementOf<TwitterProfileHeaderView>.init(props: (#imageLiteral(resourceName: "logo.png"), "Wirawit Rueopas", "Hi, I'm developing ViewElements. It'll break for sure sometimes, but I know you'll help... Join me")))
            h.layoutMarginsStyle = .zero
            return h
        }()

        self.table = table
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerImageView = self.headerImageView else { return }
        
        do /* Make header image front most on y ~ -44 to simulate nav bar */ {
            
            let headerImageViewY = headerImageView.frame.origin.y
            if headerImageViewY <= -42 {
                headerImageView.layer.zPosition = 500
                tableView.layer.zPosition = 499
            } else {
                headerImageView.layer.zPosition = 499
                tableView.layer.zPosition = 500
            }
        }
        
        /* Increase alpha of blur effect when we drag down */
        headerImageView.subviews.first?.alpha = min(abs(min(scrollView.contentOffset.y + 64, 0)), 60)/60
        
        do {
            let header = (self.tableView.tableHeaderView!.subviews.first as! TwitterProfileHeaderView)
            if let nameLabel = header.nameLabel {
                
                // Name label's origin Y relative to self.view
                let nameLabelOriginY = header.convert(nameLabel.frame.origin, to: self.view).y
                
                let topNavTitlesY = headerImageView.bounds.height - 44
                let navTitlesViewYFollowingNameLabel = headerImageView.bounds.height + nameLabelOriginY - 64
                
                // Adjust navTitlesView, force to stuck at top
                navTitlesView?.frame = CGRect(x: 0, y: max(navTitlesViewYFollowingNameLabel, topNavTitlesY), width: self.view.bounds.width, height: 44)
                
                // Also increase alpha of blur effect when navTitles is going to show up.
                if nameLabelOriginY < 64 {
                    headerImageView.subviews.first?.alpha = min(abs(min(nameLabelOriginY - 64, 0)), 44)/44
                }
            }
        }
    }
    
    // MARK:- Navigation bar styles
    override func viewWillAppear(_ animated: Bool) {
        self.setTransparentNavigationBar()
        self.capturedNavigationController = self.navigationController
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.setDefaultNavigationBar()
        super.viewWillDisappear(animated)
    }
    
    private func setTransparentNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.backgroundColor = UIColor.clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isUserInteractionEnabled = false
    }
    
    private func setDefaultNavigationBar() {
        guard let navBar = self.capturedNavigationController?.navigationBar else { return }
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(nil, for: .default)
        navBar.shadowImage = nil
        navBar.isUserInteractionEnabled = true
    }
}

class TwitterProfileMenuComponent: ComponentOf<[String]> {
    override func shouldElementUpdate(oldProps: [String], newProps: [String]) -> Bool {
        return oldProps != newProps
    }
    
    override func render() -> StackProps {
        let els = self.props.map { (s) -> ElementOf<Label> in
            return ElementOfLabel(props: s).styles({ (lb) in
                lb.font = UIFont.systemFont(ofSize: 12)
            })
        }
        
        return HorizontalStack(
            distribute: .fill,
            align: .center,
            spacing: 4,
            els)
    }
}
