//
//  EmptyRow.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//


public func RowOfEmptySpace(height: CGFloat) -> Row {
    let el = ElementOf<EmptyView>.init(props: ())
    let row = Row(el)
    row.rowHeight = height
    row.pinToEdgesInsteadOfLayoutMarginsGuide = true
    return row
}
