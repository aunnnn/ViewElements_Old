//
//  TableModelViewController.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/23/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

open class TableModelViewController: UIViewController {
    
    public let tableView: UITableView
    
    public var table = Table()
    
    fileprivate var displayedIndexPaths: Set<IndexPath> = []
    fileprivate var cellIDsToGuessedHeights: [String: CGFloat] = [:]
    
    private var previousTableViewContentInset: UIEdgeInsets?
    private weak var previousActiveResponder: UIResponder?
    
    public final func getRow(indexPath: IndexPath) -> Row {
        return table.sections[indexPath.section].rows[indexPath.row]
    }
    
    public final func getHeader(section: Int) -> SectionHeader? {
        return table.sections[section].header
    }
    
    public final func getFooter(section: Int) -> SectionFooter? {
        return table.sections[section].footer
    }
    
    public init(style: UITableViewStyle = .plain) {
        self.tableView = UITableView(frame: .zero, style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
 
    open func setupTable() {
    
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setupTable()
        
        self.registerForKeyboardNotifications()
        
        do {
            let tableView = self.tableView
            
            self.view.addSubview(tableView)
            tableView.frame = self.view.bounds
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableView.backgroundColor = .clear
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = true
            
            if table.hidesTrailingEmptyRowSeparators {
                tableView.tableFooterView = UIView(frame: .zero)
            }
            
            if let header = table.headerView {
                
                let headerView = header.element.build()
                let containerView = UIView()
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(headerView)
                
                header.setOpaqueBackgroundColorForContainerAndChildrenElementsIfNecessary(containerView: containerView, elementView: headerView)
                headerView.al_pinToLayoutMarginsGuide(ofView: containerView)
                header.prepare(containerView: containerView)
                
                self.tableView.tableHeaderView = containerView
                
                // ** Must setup AutoLayout after set tableHeaderView.
                containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                containerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Centering Content
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if table.centersContentIfPossible {
            self.centerTableView(with: self.view.bounds.size)
        }
        
        // update scroll indicator to use guessed heights
        if table.guessesSimilarHeightForCellsWithSameType {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // all guessed heights are invalid
        if self.view.bounds.size != size {
            displayedIndexPaths.removeAll()
            cellIDsToGuessedHeights.removeAll()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // keep tract to update once
        var shouldUpdateTableHeight = false
        
        if let headerView = tableView.tableHeaderView {
            let previousHeight = headerView.bounds.height
            headerView.layoutIfNeeded()
            let newHeight = headerView.bounds.height
            
            // update table header view's height
            shouldUpdateTableHeight = previousHeight != newHeight || shouldUpdateTableHeight
        }
        
        if table.centersContentIfPossible {
            self.centerTableView(with: self.view.bounds.size)
        }

        // update scroll indicator to use guessed heights
        shouldUpdateTableHeight = table.guessesSimilarHeightForCellsWithSameType || shouldUpdateTableHeight
        
        if shouldUpdateTableHeight {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func centerTableView(with viewSize: CGSize) {
        
        tableView.layoutIfNeeded()
        
        let tableVerticalInset = (viewSize.height - self.tableView.contentSize.height)/2
        if tableVerticalInset < 0 {
            tableView.contentInset = .zero
            tableView.alwaysBounceVertical = true
            tableView.isScrollEnabled = true
            tableView.showsVerticalScrollIndicator = true
            return
        } else {
            tableView.alwaysBounceVertical = false
            tableView.isScrollEnabled = false
            tableView.showsVerticalScrollIndicator = false
        }
        let inset = UIEdgeInsets(top: tableVerticalInset,
                                 left: 0,
                                 bottom: tableVerticalInset,
                                 right: 0)
        self.tableView.contentInset = inset
    }
    
    // MARK: Keyboard Notifications
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        // if keyboard is up for the first time
        // E.g., tapping other textfields while keyboard was shown will also trigger this notification.
        guard previousActiveResponder == nil else { return }
        guard let info = notification.userInfo else { return }
        guard let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let responderView = UIResponder.firstResponder() else { return }
        
        /* Save previous settings */
        self.previousTableViewContentInset = self.tableView.contentInset
        
        /* Adjust tableview's inset */
        previousActiveResponder = responderView
        let keyboardFrame = tableView.convert(kbFrame, from: nil)
        let intersection = keyboardFrame.intersection(tableView.bounds)

        // Not interest with table bounds.
        guard !intersection.isNull else { return }
        
        // Bottom inset already make the table above keyboard than 8 pts.
        if self.tableView.contentInset.bottom >= intersection.height + 8 { return }
    
        let contentInsets = UIEdgeInsets(top: tableView.contentInset.top, left: 0, bottom: intersection.height + 8, right: 0)

        if table.centersContentIfPossible {
            self.tableView.isScrollEnabled = true
        }
        
        self.tableView.contentInset = contentInsets
//        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.previousActiveResponder = nil
        
        if table.centersContentIfPossible {
            UIView.animate(withDuration: 0.2) {
                self.centerTableView(with: self.view.bounds.size)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.tableView.contentInset = self.previousTableViewContentInset ?? .zero
//                self.tableView.scrollIndicatorInsets = .zero
            }
        }
    }
    
    open func tableModelViewControllerWillDisplay(row: Row, at indexPath: IndexPath) {
        
    }

}

extension TableModelViewController {
    
    public func isSectionHeaderFloating(section: Int) -> Bool {
        // no header
        guard self.getHeader(section: section) != nil else { return false }
        
        // not visible
        guard let headerView = self.tableView.headerView(forSection: section) else {
            return false
        }
        
        let headerDrawingArea = tableView.rectForHeader(inSection: section)
        let floatingRect = headerView.frame
        return floatingRect.origin.y > headerDrawingArea.origin.y
    }
    
    public func isSectionFooterFloating(section: Int) -> Bool {
        // no footer
        guard self.getFooter(section: section) != nil else { return false }
        
        // not visible
        guard let footerView = self.tableView.footerView(forSection: section) else {
            return false
        }

        let footerDrawingArea = tableView.rectForFooter(inSection: section)
        let floatingRect = footerView.frame
        return floatingRect.origin.y < footerDrawingArea.origin.y
    }
}

extension TableModelViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDatasource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return table.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.sections[section].rows.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = getRow(indexPath: indexPath)
        let cell: TableRowViewCell
        
        do /* Retrieving Cell */ {
            let reuseId = row.element.viewIdentifier
            if let reusedCell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TableRowViewCell {
                cell = reusedCell
            } else {
                cell = TableRowViewCell(row: row, reuseIdentifier: reuseId)
            }
        }
        
        row.prepare(rootView: cell)
        cell.selectionStyle = row.selectionStyle
        
        row.prepare(containerView: cell.contentView)
        
        if debugMode {
            cell.contentView.border(width: 1, color: .red)
            cell._elementView?.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        }
        
        // This triggers cell update
        cell.row = row
        return cell
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        
        guard table.guessesSimilarHeightForCellsWithSameType else { return row.estimatedRowHeight }
        
        // if already displayed, use estimatedRowHeight
        if  displayedIndexPaths.contains(indexPath) {
            return row.estimatedRowHeight
        } else {
            return self.cellIDsToGuessedHeights[row.element.viewIdentifier] ?? row.estimatedRowHeight
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        return row.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = getRow(indexPath: indexPath)
        let newEstimatedHeight = cell.bounds.height
        
        if table.updatesEstimatedRowHeights {            
            guard newEstimatedHeight >= 1 else {
                print("Warning: Found new estimated height < 1 (\(newEstimatedHeight)) for view \(row.element.viewIdentifier). This value will be ignored.")
                return
            }
            row.estimatedRowHeight = newEstimatedHeight
        }
        
        if table.guessesSimilarHeightForCellsWithSameType {
            displayedIndexPaths.insert(indexPath)
            self.cellIDsToGuessedHeights[row.element.viewIdentifier] = newEstimatedHeight
        }
        self.tableModelViewControllerWillDisplay(row: row, at: indexPath)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = getRow(indexPath: indexPath)
        row.didSelectRow?(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Section Header
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = getHeader(section: section) else { return nil }
        let element = header.element
        
        let reuseId = element.viewIdentifier
        let headerView: TableSectionHeaderFooterView
        
        if let reusedHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? TableSectionHeaderFooterView {
            headerView = reusedHeader
        } else {
            headerView = TableSectionHeaderFooterView(headerFooter: header, reuseIdentifier: reuseId)
        }
        
        // We set these two properties instead of using .configure(rootView:)
        // because it's not recommended to set backgroundColor of header footer view.
        headerView.preservesSuperviewLayoutMargins = false
        headerView.layoutMargins = .zero

        header.prepare(containerView: headerView.contentView)
        headerView.headerFooter = header

        if debugMode {
            headerView.contentView.border(width: 1, color: .blue)
            headerView._elementView?.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let header = getHeader(section: section) else { return 0 }
        return header.estimatedSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = getHeader(section: section) else { return 0 }
        return header.sectionHeaderHeight
    }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard table.updatesEstimatedRowHeights else { return }
        guard let header = getHeader(section: section) else { return }
        let newEstimatedHeight = view.bounds.height
        header.estimatedSectionHeaderHeight = newEstimatedHeight
    }
    
    // MARK: Section Footer
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = getFooter(section: section) else { return nil }
        let element = footer.element
        
        let reuseId = element.viewIdentifier
        let footerView: TableSectionHeaderFooterView
        
        if let reusedFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? TableSectionHeaderFooterView {
            footerView = reusedFooter
        } else {
            footerView = TableSectionHeaderFooterView(headerFooter: footer, reuseIdentifier: reuseId)
        }
        
        footerView.preservesSuperviewLayoutMargins = false
        footerView.layoutMargins = .zero
        
        footer.prepare(containerView: footerView.contentView)
        footerView.headerFooter = footer
        
        if debugMode {
            footerView.contentView.border(width: 1, color: .blue)
            footerView._elementView?.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        }
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let footer = getFooter(section: section) else { return 0 }
        return footer.estimatedSectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = getFooter(section: section) else { return 0 }
        return footer.sectionFooterHeight
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard table.updatesEstimatedRowHeights else { return }
        guard let footer = getFooter(section: section) else { return }
        let newEstimatedHeight = view.bounds.height
        footer.estimatedSectionFooterHeight = newEstimatedHeight
    }
}

private weak var currentFirstResponder: UIResponder?

extension UIResponder {
    
    static func firstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(self.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc func findFirstResponder(sender: AnyObject) {
        currentFirstResponder = self
    }
}
