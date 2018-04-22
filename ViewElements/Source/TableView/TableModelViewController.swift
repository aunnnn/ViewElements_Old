//
//  TableModelViewController.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/23/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

/// View controller that knows how to present `Table`. Extends this and sets the `table` value.
open class TableModelViewController: UIViewController {
    
    public let tableView: UITableView

    /// Space between first responder and keyboard when it's up. Default is 8.0.
    public var keyboardToFirstResponderSpacing: CGFloat = 8.0
    public var table = Table()
    
    fileprivate var displayedIndexPaths: Set<IndexPath> = []
    fileprivate var cellIDsToGuessedHeights: [String: CGFloat] = [:]
    
    private var previousTableViewContentInset: UIEdgeInsets?
    private weak var previousActiveResponder: UIResponder?
    private var latestViewWidth: CGFloat = 0.0

    /// This is the internal view that moves with scroll view. It is only used for AutoLayout with StretchyHeaderView.
    private var tableViewTopMostLayoutGuideView: UIView?
    private var tableViewTopMostLayoutGuideViewTopConstraint: NSLayoutConstraint?

    /// Active table header view.
    private var _tableHeaderView: UIView?
    /// Active stretchy header view.
    private var _stretchyHeaderView: UIView?
    
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

    /// Setup `table` here. Note: This is called in `viewDidLoad`.
    open func setupTable() {
    
    }

    /// When create view controller programmatically, this is needed to prevent the system
    /// automatically search for nib files (which could result to a hard-to-debug crash).
    /// https://developer.apple.com/documentation/uikit/uiviewcontroller/1621487-nibname?language=swift
    open override func loadView() {
        super.loadView()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupTable()
        do {
            let tableView = self.tableView
            tableView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(tableView)
            tableView.al_pinToEdges(ofView: self.view, insets: .zero, priority: UILayoutPriority(1000))
            tableView.backgroundColor = .clear
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = true
            
            if table.hidesTrailingEmptyRowSeparators {
                tableView.tableFooterView = UIView(frame: .zero)
            }

            // We don't support `stretchyHeader` with `headerView`
            // This gives preference to `stretchyHeader` first. If it is nil, then check `headerView` next.
            if table.stretchyHeaderView != nil {
                self.reloadStretchyHeaderViewIfNeeded()
            } else if let header = table.headerView {

            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotifications()
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

        // *If view width doesn't change, table header view shouldn't change*
        // Note: If we don't do this we'll call `layoutIfNeeded` below everytime we scroll!
        let hasViewWidthChanged = latestViewWidth != self.view.bounds.width
        if let headerView = tableView.tableHeaderView, hasViewWidthChanged {

            // Update
            latestViewWidth = self.view.bounds.width

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

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewTopMostLayoutGuideViewTopConstraint?.constant = -scrollView.contentOffset.y
        if let stretchyHeader = table.stretchyHeaderView,
            stretchyHeader.adjustsTableViewScrollIndicatorInsetsBelowStretchyHeaderView,
            let stretchyHeaderView = self._stretchyHeaderView {

            let stretchyHeight = stretchyHeaderView.bounds.height
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: stretchyHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func centerTableView(with viewSize: CGSize) {
        
        tableView.layoutIfNeeded()
        
        let tableVerticalInset = (viewSize.height - self.tableView.contentSize.height)/2
        if tableVerticalInset < 0 {
            warn("Found tableView's content height more than view's height on `centersContentIfPossible` mode. Resetting back to default display mode.")
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
        self.tableView.scrollIndicatorInsets = inset
    }
    
    // MARK: Keyboard Notifications
    private func registerForKeyboardNotifications() {
        // For safety, unregister first
        unregisterForKeyboardNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
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

        // Keyboard frame in tableView coordinate space
        let keyboardFrame = tableView.convert(kbFrame, from: nil)

        // This is the actual bounds of content of table view, with estimated x and width, since it's not relevant.
        let tableContentBounds = CGRect(
            x: tableView.bounds.minX,
            y: tableView.bounds.minY + tableView.contentInset.top,
            width: tableView.bounds.width,
            height: tableView.contentSize.height)
        let intersection = keyboardFrame.intersection(tableContentBounds)

        // Not intersect.
        if intersection.isNull { return }

        let contentInsets = UIEdgeInsets(
            top: max(tableView.contentInset.top - (intersection.height + keyboardToFirstResponderSpacing), 0.0),
            left: 0,
            bottom: intersection.height + keyboardToFirstResponderSpacing,
            right: 0)

        if table.centersContentIfPossible {
            self.tableView.isScrollEnabled = true
        }

        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.previousActiveResponder = nil

        if table.centersContentIfPossible {
            self.centerTableView(with: self.view.bounds.size)
        } else {
            self.tableView.contentInset = self.previousTableViewContentInset ?? .zero
            self.tableView.scrollIndicatorInsets = self.previousTableViewContentInset ?? .zero
        }
    }
    
    open func tableModelViewControllerWillDisplay(row: Row, at indexPath: IndexPath) {
        
    }
}

extension TableModelViewController {

    /// Reload the whole UI.
    public func reload() {
        tableView.reloadData()
        reloadTableHeaderViewIfNeeded()
        reloadStretchyHeaderViewIfNeeded()
    }

    private func clearStretchyHeaderView() {
        _stretchyHeaderView?.removeFromSuperview()
        _stretchyHeaderView = nil
        tableViewTopMostLayoutGuideViewTopConstraint = nil
        tableViewTopMostLayoutGuideView?.removeFromSuperview()
        tableViewTopMostLayoutGuideView = nil
    }

    private func clearTableHeaderView() {
        _tableHeaderView?.removeFromSuperview()
        _tableHeaderView = nil
    }

    public func reloadTableHeaderViewIfNeeded() {
        guard let header = table.headerView else {
            clearTableHeaderView()
            return
        }

        clearTableHeaderView()

        let headerView = header.element.build()
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerView)

        header.prepare(rootView: headerView)
        header.prepare(contentView: containerView)
        headerView.al_pinToLayoutMarginsGuide(ofView: containerView)

        self.tableView.tableHeaderView = containerView
        self._tableHeaderView = containerView

        // ** Must setup AutoLayout after set tableHeaderView.
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true

        if header.childrenHaveSameBackgroundColorAsContainer {
            header.setOpaqueBackgroundColorForContainerAndChildrenElements(containerView: containerView, elementView: headerView)
        }
    }

    func reloadStretchyHeaderViewIfNeeded() {
        guard let stretchyHeader = table.stretchyHeaderView else {
            clearStretchyHeaderView()
            return
        }

        clearStretchyHeaderView()

        if (table.centersContentIfPossible) {
            warnAndAssertionFailure("Stretchy header must not be used with content centering mode. To use stretchy header, you must set `table.centersContentIfPossible` to false.")
            return
        }

        let guideView: UIView
        do {
            let gv = UIView()
            gv.translatesAutoresizingMaskIntoConstraints = false
            gv.isUserInteractionEnabled = false

            self.view.insertSubview(gv, belowSubview: tableView)
            gv.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            gv.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            gv.heightAnchor.constraint(equalToConstant: 0).isActive = true

            tableViewTopMostLayoutGuideViewTopConstraint = gv.topAnchor.constraint(equalTo: self.view.topAnchor)
            tableViewTopMostLayoutGuideViewTopConstraint?.constant = stretchyHeader.restingHeight
            tableViewTopMostLayoutGuideViewTopConstraint?.isActive = true
            self.tableViewTopMostLayoutGuideView = gv

            guideView = gv
        }

        let stretchyHeaderView: UIView
        do {
            let headerView = stretchyHeader.element.build()
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                containerView.insetsLayoutMarginsFromSafeArea = false
            }
            containerView.addSubview(headerView)
            stretchyHeader.prepare(contentView: containerView)
            headerView.al_pinToLayoutMarginsGuide(ofView: containerView)
            self._stretchyHeaderView = containerView

            if stretchyHeader.childrenHaveSameBackgroundColorAsContainer {
               stretchyHeader.setOpaqueBackgroundColorForContainerAndChildrenElements(containerView: containerView, elementView: headerView)
            }

            // Use containerView as headerView for the rest of function
            stretchyHeaderView = containerView
        }
        
        self.view.insertSubview(stretchyHeaderView, aboveSubview: tableView)

        let hv = stretchyHeaderView

        /* Pin to root view's left, right */
        hv.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hv.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        let stretchyBottomAnchorGuide = guideView.topAnchor

        switch stretchyHeader.stretchyBehavior {
        case .scrollsUpWithContent:

            /* Default minimum height */
            let heightAnchor = hv.heightAnchor.constraint(equalToConstant: stretchyHeader.restingHeight)
            heightAnchor.priority = UILayoutPriority(999)
            heightAnchor.isActive = true

            /*
             Top of hv must be at the top of root view *or above it.*
             This makes the header respects minimum height and shifts
             up the content when it reaches the top.
             */
            hv.topAnchor.constraint(lessThanOrEqualTo: self.view.topAnchor).isActive = true

            /* Pin bottom of header image to top of guide */
            let bottomToTableAnchor = hv.bottomAnchor.constraint(
                equalTo: stretchyBottomAnchorGuide)
            bottomToTableAnchor.priority = UILayoutPriority(1000)
            bottomToTableAnchor.isActive = true

        case .shrinksToMinimumHeight(let minimumHeight):

            /* Pin stretchy's top to top of root */
            hv.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

            /* Keep stretchy's bottom below root's top + minHeight (to stick view at top) */
            let stickyHeight = hv.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: minimumHeight)
            stickyHeight.priority = UILayoutPriority(1000)
            stickyHeight.isActive = true

            /* Pin bottom of header image to top of tableHeaderView */
            let bottomToTableAnchor = hv.bottomAnchor.constraint(
                equalTo: stretchyBottomAnchorGuide)
            bottomToTableAnchor.priority = UILayoutPriority(999)
            bottomToTableAnchor.isActive = true
        }

        self.tableView.contentInset = .init(top: stretchyHeader.restingHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = .init(x: 0, y: -stretchyHeader.restingHeight)
    }
    
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
        
        row.prepare(contentView: cell.contentView)
        
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
                warn("Found new estimated height < 1 (\(newEstimatedHeight)) for view \(row.element.viewIdentifier). This value will be ignored.")
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

        header.prepare(contentView: headerView.contentView)
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
        
        footer.prepare(contentView: footerView.contentView)
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
