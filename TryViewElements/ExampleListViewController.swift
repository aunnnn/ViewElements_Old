//
//  ExampleListViewController.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/23/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit
import ViewElements
import TryViewElements_UI

class ExampleListViewController: TableModelViewController {

    override func viewDidLoad() {
        self.title = "Examples"

        let el = ElementOf<TestView>(props: "Test Nib View from another target.")
        let rows: [Row] = (0...8).map {
            Row(ElementOfLabel(props: Menu(rawValue: $0)!.name))
        } + [Row(el)]
        let section = Section(
            header: nil,
            footer: nil,
            rows: rows
        )
        
        let table = Table.init(sections: [section])
        
        table.sections.flatMap { $0.rows }.forEach { (row) in
            row.selectionStyle = .default
            row.separatorStyle = .fullWidth
//            row.rowHeight = 44
        }
        
        self.table = table
        
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let menu = Menu(rawValue: indexPath.row)!
        guard let vc = menu.vc else { return }
        vc.title = menu.name
        self.show(vc, sender: nil)
    }
}

private enum Menu: Int {
    
    case centeredContent = 0
    case twitterComponent
    case twitterNib
    case twitterProfile
    
    case medium
    case appStore
    
    case loading
    case tapToLoadMore
    case tailLoading
    
    var name: String {
        switch self {
        case .centeredContent: return "Centered Content"
        case .twitterComponent: return "Twitter (Component)"
        case .twitterNib: return "Twitter (Nib)"
        case .twitterProfile: return "Twitter Profile"
            
        case .medium: return "Medium"
        case .appStore: return "App Store"
            
        case .loading: return "Loading"
        case .tapToLoadMore: return "Tap to load more"
        case .tailLoading: return "Tail loading"
        }
    }
    
    var vc: UIViewController? {
        switch self {
        case .centeredContent: return CenteredContentViewController()
        case .twitterComponent: return TwitterFeedViewController()
        case .twitterNib: return TwitterFeedWithNibViewController()
        case .medium: return MediumFeedViewController()
        case .appStore: return AppStoreDetailViewController()
        case .loading: return LoadingViewController()
        case .tapToLoadMore: return TapToLoadMoreViewController()
        case .tailLoading: return TailLoadingViewController()
        case .twitterProfile: return TwitterProfileViewController()
        }
    }
}
