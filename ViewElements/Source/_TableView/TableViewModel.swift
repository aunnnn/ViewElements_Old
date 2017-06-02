//
//  TableViewModel.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

/// Represents a section in table view.
public final class Row {
    
    public let element: ElementOfView
    
    /// Store table view cell layout informations like cell height and layout margins.
    public var cellLayout: CellLayoutConfiguration
    
    /// Store appearance informations.
    public var cellAppearance: CellAppearanceConfiguration
    
    public var didSelectRow: ((Row) -> Void)?
    
    public init(_ element: ElementOfView) {
        self.element = element
        self.cellLayout = CellLayoutConfiguration()
        self.cellAppearance = CellAppearanceConfiguration()
    }
}

public final class SectionHeader {
    
    public let element: ElementOfView
    
    public init(_ element: ElementOfView) {
        self.element = element
    }
}

/// Represents a cell in table view.
public final class Section {
    
    public let rows: [Row]
    
    public init(rows: [Row] = []) {
        self.rows = rows
    }
}

/// Represents a table view.
public final class TableViewModel {
    
    public var sections: [Section]
    
    public init(sections: [Section] = []) {
        self.sections = sections
    }
    
    /// Single section table.
    public convenience init(rowsBlock: () -> [Row]) {
        let section = Section(rows: rowsBlock())
        self.init(sections: [section])
    }
}

public typealias Table = TableViewModel
