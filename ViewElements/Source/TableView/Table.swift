//
//  TableViewModel.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

/// Represents a section in table view.
public final class Row: ElementContainer {
    
    /// To reference later
    public var tag: String?
    
    private let elementBlock: () -> ElementOfView
    private(set) lazy public var element: ElementOfView = { () -> ElementOfView in
        return self.elementBlock()
    }()
    
    // MARK: Cell Layouts
    
    public var layoutMarginsStyle: LayoutMarginStyle = .all(inset: 8)
    public var estimatedRowHeight: CGFloat = 44
    public var rowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            // if fixed height, also set estimatedRowHeight to equal rowHeight
            guard hasFixedHeight else {
                return
            }
            estimatedRowHeight = rowHeight
        }
    }
    
    private var hasFixedHeight: Bool {
        return rowHeight != UITableViewAutomaticDimension
    }
    
    // MARK: Cell Appearances
    
    public var separatorStyle: SeparatorStyle                       = .none
    public var selectionStyle: UITableViewCellSelectionStyle        = .none
    public var backgroundColor: UIColor                             = .clear
    
    public var childrenHaveSameBackgroundColorAsContainer           = false
    
    public var didSelectRow: ((Row) -> Void)?
    
    /// Whether the view should pin to edges of UITableViewCell's contentView instead of layout margins guide. Default is false.
    /// This is for internal-use. Example use of this is RowOfEmptySpace.
    internal var pinToEdgesInsteadOfLayoutMarginsGuide = false
    
    public init(_ element: @escaping @autoclosure () -> ElementOfView) {
        self.elementBlock = element
    }
}

public final class SectionHeader: ElementContainer {
    
    private let elementBlock: () -> ElementOfView
    private(set) lazy public var element: ElementOfView = { () -> ElementOfView in
        return self.elementBlock()
    }()
    
    public var backgroundColor: UIColor = .clear
    public var childrenHaveSameBackgroundColorAsContainer = false
    
    public var layoutMarginsStyle: Row.LayoutMarginStyle = .all(inset: 8)
    public var sectionHeaderHeight: CGFloat = UITableViewAutomaticDimension
    public var estimatedSectionHeaderHeight: CGFloat = 32
    
    public init(_ element: @escaping @autoclosure () -> ElementOfView) {
        self.elementBlock = element
    }
}

public final class SectionFooter: ElementContainer {
    
    private let elementBlock: () -> ElementOfView
    private(set) lazy public var element: ElementOfView = { () -> ElementOfView in
        return self.elementBlock()
    }()
    
    public var backgroundColor: UIColor = .clear
    public var layoutMarginsStyle: Row.LayoutMarginStyle = .`default`
    public var childrenHaveSameBackgroundColorAsContainer = false
    
    public var sectionFooterHeight: CGFloat = UITableViewAutomaticDimension
    public var estimatedSectionFooterHeight: CGFloat = 32
    
    public init(_ element: @escaping @autoclosure () -> ElementOfView) {
        self.elementBlock = element
    }
}

/// Represents a cell in table view.
public final class Section {
    
    public var header: SectionHeader?
    public var footer: SectionFooter?
    public var rows: [Row]
    
    public init(header: SectionHeader?, footer: SectionFooter?, rows: [Row]) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }
    
    public init(header: SectionHeader?, footer: SectionFooter?, rowsBlock: () -> [Row]) {
        self.header = header
        self.footer = footer
        self.rows = rowsBlock()
    }
}

/// Represents a table header view.
public final class TableHeaderView: ElementContainer {

    private(set) lazy public var element: ElementOfView = { () -> ElementOfView in
        return self.elementBlock()
    }()
    
    public var backgroundColor: UIColor                         = .clear
    public var layoutMarginsStyle: Row.LayoutMarginStyle        = .`default`
    public var childrenHaveSameBackgroundColorAsContainer: Bool = false
    
    private let elementBlock: () -> ElementOfView
    
    public init(_ element: @autoclosure @escaping () -> ElementOfView) {
        self.elementBlock = element
    }
}

/// Represents a table view.
public final class Table {
    
    /// If true (default), each FormRow's estimatedRowHeight will be updated with actual value after displaying the cell.
    public var updatesEstimatedRowHeights = true
    
    /// Default is false. If true, a row height of first cell that is displayed will be used as estimatedRowHeight of subsequent cells (that have the same reuseID).
    ///
    /// This is useful when we don't set estimatedRowHeight manually.
    public var guessesSimilarHeightForCellsWithSameType = false
    
    /// If true (default), tableview will hide trailing empty cells separators.
    public var hidesTrailingEmptyRowSeparators = true
    
    /// If true, tableview insets are adjusted to center the content,
    /// vertical scroll indicator is hidden, scroll is disabled (unless the keyboard appears).
    /// Note that if contentSize is more than tableview's bound, it will reset to insets with all zeros.
    /// Default is false.
    public var centersContentIfPossible = false
    
    public var headerView: TableHeaderView?
    public var sections: [Section]
    
    public init(sections: [Section] = []) {
        self.sections = sections
    }
    
    /// Single section table.
    public convenience init(rowsBlock: () -> [Row]) {
        let section = Section(header: nil, footer: nil, rowsBlock: rowsBlock)
        self.init(sections: [section])
    }
}
