# ViewElements

(...In-progress)
A framework to manage and reuse UIViews in iOS apps.

## Features
- Setup once, use everywhere :tada: as:
  - UIView
  - UITableViewCell
  - UITableHeaderFooterView
  - tableHeaderView
  - UICollectionViewCell (coming soon)
- Less code for setting up tableview
- Builtin keyboard avoiding :relieved:
- Solve frequently-asked problems of table view:
  - Hide trailing separator :relaxed:
  - Configure separator styles by row
  - AutoLayout for tableHeaderView :wink:
  - Center table's content & disable scrolling (if possible)
  - Update estimatedRowHeight after a cell is displayed

## Overview

Most UIs in iOS can be solved by UITableView, this framework tries to make that easiest as possible.

### Element
ViewElement provides a universal abstraction for a UIView, **Element**. Element contains **Props**, a data structure used to configure that view.
This framework already provides basic UIKit elements like UILabel, UIImageView, UIButton, UITextField, UIAcivityIndicator.
(You'll be surprised of how much you could accomplish only by stacking these basic elements on top of each other.)

Then, an element can be used in a table view by wrapping it with ElementContainers: 
- Row(element)
- SectionHeader(element)
- SectionFooter(element)
- TableHeaderView(element).

Most containers use AutoLayout by default. But you can set rowHeight on these containers if you know the height beforehand.

### Component
Row of Element fills the cell horizontally, what if you need to place two elements next to each other?

You can stack elements horizontally with **Component**, a subclass of Element. It can be used everywhere that Element can be used. 
A component requires you to return an hierarchy of **StackProps**-- an abstraction for UIStackView.

Internally it creates UIStackView for each StackProps and nests them together.

PS: Though stack view solves a lot of AutoLayout problems, consider making element from nib file if a component is very complex.

PS2: *Right now Component doesn't support changes in views tree like in React. 
Component only serves as a way to compose elements by nesting them together.*

## Limitation
This framework is suitable for creating static pages, e.g. page that has no states / animations on the content.
At the end of the day it's just a UITableView.
For highly interactive page with many gestures, consider other options.

## Getting Started

### 1. Create a view compatible with this framework
- Make a UIView nib that subclasses BaseNibView (or BaseView if you create view programmatically)
- Define *PropsType*
- Implements setup/update functions

(...in progress, for now, see Examples first)

## Examples
See 'ViewElements/Examples'.
