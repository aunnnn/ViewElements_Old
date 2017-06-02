//
//  TableViewModelViewController.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/23/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import UIKit

open class TableViewModelViewController: UIViewController {
    
    public let tableView: UITableView
    
    fileprivate var registeredReuseIds: [String] = []
    
    public var tableViewModel = TableViewModel()
    
    /// If true (default), each FormRow's estimatedRowHeight will be updated with actual value after displaying the cell.
    public var updateEstimatedRowHeights = true
    
    /// If true, the keyboard will be hidden on table view scroll. Default is false.
    public var hidesKeyboardOnScroll = false
    
    /// If true (default), tableview will hides keyboard on tap.
    public var hidesKeyboardOnTap = true
    
    /// If true (default), tableview will hide trailing empty cells separators.
    public var hidesTrailingEmptyRowSeparators = true
    
    /// If true, tableview insets are adjusted to center the content, 
    /// vertical scroll indicator is hidden, scroll is disabled (unless the keyboard appears).
    /// Note that if contentSize is more than tableview's bound, it will reset to insets with all zeros.
    /// Default is false.
    public var centersContentIfPossible = false
    
    private var previousTableViewContentInset: UIEdgeInsets?
    private weak var previousActiveResponder: UIResponder?
    
    public func getRow(indexPath: IndexPath) -> Row {
        return tableViewModel.sections[indexPath.section].rows[indexPath.row]
    }
    
    public init(style: UITableViewStyle = .plain) {
        self.tableView = UITableView(frame: .zero, style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        
        do {
            let tableView = self.tableView
            
            self.view.addSubview(tableView)
            tableView.frame = self.view.bounds
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableView.backgroundColor = .white
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView))
            tapGesture.numberOfTapsRequired = 1
            tableView.addGestureRecognizer(tapGesture)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.keyboardDismissMode = .interactive
            
            if hidesTrailingEmptyRowSeparators {
                tableView.tableFooterView = UIView(frame: .zero)
            }
        }
    }
    
    final internal func didTapOnTableView() {
        guard hidesKeyboardOnTap else { return }
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Centering Content
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard centersContentIfPossible else { return }
        self.centerTableView(with: self.view.bounds.size)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard centersContentIfPossible else { return }
        self.centerTableView(with: self.view.bounds.size)
    }
    
    private func centerTableView(with tableSize: CGSize) {
        let tableVerticalInset = (tableSize.height - self.tableView.contentSize.height)/2
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

        if centersContentIfPossible {
            self.tableView.isScrollEnabled = true
        }
        
        self.tableView.contentInset = contentInsets
//        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.previousActiveResponder = nil
        
        if centersContentIfPossible {
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
}

extension TableViewModelViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDatasource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.sections[section].rows.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = getRow(indexPath: indexPath)
        let cell: RowTableViewCell
        
        do /* Retrieving Cell */ {
            let reuseId = row.element.viewIdentifier
            if let reusedCell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? RowTableViewCell {
                cell = reusedCell
            } else {
                cell = RowTableViewCell(element: row.element, reuseIdentifier: reuseId)
            }
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.backgroundColor = .clear
        
        cell.contentView.preservesSuperviewLayoutMargins = false
        cell.contentView.layoutMargins = row.cellLayout.layoutMarginsStyle.value
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = row.cellAppearance.selectionStyle
        
        // This triggers cell update
        cell.row = row
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }
    
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        return row.cellLayout.estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        return row.cellLayout.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard updateEstimatedRowHeights else { return }
        let row = getRow(indexPath: indexPath)
        let newEstimatedHeight = cell.bounds.height
        row.cellLayout.estimatedRowHeight = newEstimatedHeight
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = getRow(indexPath: indexPath)
        row.didSelectRow?(row)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard hidesKeyboardOnScroll else { return }
        self.view.endEditing(true)
    }
}

private weak var currentFirstResponder: UIResponder?

extension UIResponder {
    
    static func firstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(self.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    func findFirstResponder(sender: AnyObject) {
        currentFirstResponder = self
    }
}
