# ViewElements
![Travis](https://travis-ci.org/aunnnn/ViewElements.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)
[![License](https://img.shields.io/cocoapods/l/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)
[![Platform](https://img.shields.io/cocoapods/p/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)

A framework to manage and reuse UIViews in iOS apps.

*IMPORTANT: This is still a work in progress. Can be used in production but with care.*

## Features
- Supported view types:
  - Row (`UITableViewCell`)
  - SectionHeader, SectionFooter (`UITableHeaderFooterView`)
  - TableHeaderView
  - StretchyHeader :sparkles:
- Keyboard avoiding
- Also handles these easily:
  - Hide trailing separator (by default)
  - Separator styles
  - AutoLayout (If you create a custom view, you must setup the autolayout yourself correctly though)
  - Center the tableview's content (& disable scrolling if possible)
  - Automatically update estimatedRowHeight after a cell is displayed

## Installation
Add this to your Podfile:
````
pod 'ViewElements'
````

## Table of Contents
- [Installation](#installation)
- [Overview](#overview)
- [Usecases](#usecases)
  - [Creating a basic table](#creating-a-basic-table)
  - [Section Header and Footer](#section-header-and-footer)
  - [Table Header View](#table-header-view)
  - [Stretchy Header](#stretchy-header)
  - [Fetching data from API](#fetching-data-from-api)
  - [Tail loading](#tail-loading)
 - [How to make a custom view](#how-to-make-a-custom-view)
 - [Built-in Elements](#built-in-elements)
  - [Customizing Built-in Elements](#customizing-built-in-elements)
 - [Terminologies](#terminologies)
  - [Element](#element)
  - [Component](#component)
 - [Limitations](#limitations)
 - [Roadmap](#roadmap)

## Overview
All iOS apps use `UITableView`, but it's quite a hassle to set that up everytime. 
This framework does the heavy lifting for you.
It abstracts views into view models like Row, SectionHeader, SectionFooter. You can compose the model to make a table.
Want to change rows order? Just change the order in the array. Want 10 label rows?:
```swift
let rows = (0..<10).map { Row(ElementOfLabel("Label no. \($0)")) }
```
Manipulate them like a primitive data!

## Usecases

### Creating a basic table

1. Make `ElementOf<SomeViewClass>`:
```swift
let el = ElementOf<Label>(props: "Yay!") // = a general view
```
Note1: `Label` is a subclass of `UILabel` that works with this framework. [How to make your own](#how-to-make-a-custom-view).

Note2: You can use `ElementOfLabel(props: "Yay!")` instead which wrap the above code. See [built-in elements](#built-in-elements).


2. Wrap it with `Row`:
```swift
let labelRow = Row(el) // = a table view cell
```
You can also customize `Row` properties:
```swift
labelRow.backgroundColor = .gray
labelRow.separatorStyle = .none
labelRow.rowHeight = 60 // fixed height, instead of AutoLayout
labelRow.layoutMarginStyle = .all(inset: 8)
```

3. Make a section from array of `Row`:
```swift
let s = Section(row: [labelRow, ...]) // = a section in table view
```

4. Make a table from array of `Section`:
```swift
let table = Table(sections: [s, ...]) // = a table view
```
You already got a complete model to present a table, next you just have to put it to the view controller that knows how to interpret this model.

5. Subclass `TableModelViewController`, this is the most important class in this framework. It knows how to parse a `Table` model into final result. You can override `setupTable()` and set a table there (you can also do it in `viewDidLoad`):
```swift
class MyViewController: TableModelViewController {

  /// Initial table
  override setupTable() {
    // Build a Table instance like above steps.
    let table = ...   
    
    // Set a table model
    self.table = table
  }
}
```
And that's it, you've got a view controller ready to use!

6. You can set the table model anytime, just make sure to call `reload()`:
```swift
class MyViewController: TableModelViewController {
  ...
  
  func reloadTable() {
    self.table = getTableModel() // build some table model from state
    self.reload() // reload the whole table
  }
}
```
### Section Header and Footer
1. Wrap an element with `SectionHeader` or `SectionFooter`:
```swift
let sh = SectionHeader(ElementOfLabel(props: "Section header"))
let sf = SectionHeader(ElementOfLabel(props: "Section footer"))
```
2. Set it to `Section`:
```swift
let s = Section(rows: rows)
s.header = sh
s.footer = sf
```

### Table Header View
1. Wrap an element with `TableHeaderView`:
```swift
let th = TableHeaderView(ElementOfLabel(props: "Table header view"))
```
2. Set it to `Table`:
```swift
let table = Table(sections: sections)
table.tableHeaderView = th
```

### Stretchy Header
1. Wrap an element with `StretchyHeader`, two modes are supported:
```swift
// Mode 1: Scrolls up with content
let sh1 = StretchyHeader(behavior: .scrollsUpWithContent, element: ElementOfLabel(props: "stretchy header"))
sh1.restingHeight = nil // By default (nil) it uses AutoLayout to determine fitted size.
sh1.restingHeight = 200 // But you can give it fixed height here.

// Mode 2: Shrink and then stick at the top
let sh2 = StretchyHeader(behavior: .shrinksToMinimumHeight(60), element: ElementOfLabel(props: "stretchy header"))
sh.restingHeight = 200 // Initial height is 200, it then reduces as it scrolls up, and then stop at 60
```
**IMPORTANT:** `StretchyHeader` can't be used together with `TableHeaderView`. Setting one automatically sets another to `nil`

### Fetching data from API
You can easily show a loading indicator for a section while waiting for remote data using `ElementOfActivityIndicator(props: true)`. 
I suggest breaking parts of the table into functions that return element based on app states:
```swift
func listOfUsersSection() -> Section {
  guard let users = self.usersList else { 
    return Section(rows: [Row(ElementOfActivityIndicator(props: true))]) // show loading if no data
  }
  let userRows = users.map { u in
    return Row(ElementOf<UserView>(props: user))
  }
  return Section(rows: userRows)
}
```

If you don't want to show anything, you can simply return `nil`:
```swift
func listOfUsersSection() -> Section? {
  guard let users = self.usersList else { 
    return nil
  }
  let userRows = users.map { u in
    return Row(ElementOf<UserView>(props: user))
  }
  return Section(rows: userRows)
}
```
Then figure out whether to show or not:
```swift
let allPossibleSections: [Section?] = [
  someSection(),
  listOfUsesSection(),
  someOtherSection(),
  ...
]

let visibleSections: [Section] = allPossibleSections.compactMap { $0 } // filter out nil section
```
### Tail Loading
1. Add a loading section at the end:
```swift
override func setupTable() {
  let loadingSection = Section(rows: [{
    let row = Row(ElementOfActivityIndicator())
    row.rowHeight = 44
    row.tag = "loading" // give a tag, so it can be referenced easily later
    return row
   }()])
  let table = Table(sections: [
    someListOfThingsSection(),
    loadingSection // loading at the bottom
  ])
  self.table = table
}
```
2. Override `func tableModelViewControllerWillDisplay(row: Row, at indexPath: IndexPath)`, which is called whenever a row will be displayed:
```swift
// Keep track of isLoading, so that we don't call API everytime this row enters the screen!
var isLoading = false

// Pagination states
var fromId: Int = 0
let kPaginationSize = 100

override func tableModelViewControllerWillDisplay(row: Row, at indexPath: IndexPath) {
  if row.tag == "loading" && !isLoading {
    self.isLoading = true // start loading
    APIService.fetchPaginationData(from: self.fromId, size: self.kPaginationSize) { [weak self] data in
      guard let `self` = self else { return }
      
      // Dirty check if loading is there or not by counting lol
      if data.isEmpty {
        if self.table.sections.count == 2 {
          // Remove loading section as we run out of data
          self.table.sections.removeLast()
        }
      } else {
        // You can build an entirely new Table, but I will just mutate and reload here, dirty but work
        self.table.sections[0].rows.append(contentsOf: rowsFromData(data))
      }
      self.tableView.reloadData()
      self.isLoading = false // end loading     
    }
  }
}
```

## Difference between `reload()` and `tableView.reloadData()`
The only difference is that `reload()` will also reload `TableHeaderView` and `StretchyHeader`. One downside of this is that the `contentOffset` and `contentInsets` will be reset to zero.

Calling `tableView.reloadData()` will reload all rows and sections (but not `TableHeaderView` and `StretchyHeader`), which might be just what you want. For example, in [tail loading](#tail-loading), you should call `tableView.reloadData()` only so that the incoming data is reload correctly at the tail. If you call `reload()`, the `tableView` jumps to the top.

## How to make a custom view
To be able to use `ElementOf<ViewClass>`, `ViewClass` must conform to `BaseView` (or `BaseNibView` if you use nib file), **AND** `OptionalPropsTypeAccessible`. **Be sure to use the same class name as the nib file.** The framework automatically figures out how to load between different kinds of views:

```swift

/// IMPORTANT: Must be same name as nib file (SomeView.xib).
public final class SomeView: BaseNibView, OptionalTypedPropsAccessible {

  /// Better use struct instead of tuple if it gets complicated!
  public typealias PropsType = (title: String, image: UIImage)

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  /// Initial setup, equivalent to `awakeFromNib`
  public override func setup() {
    self.label.textAlignment = .center
  }

  /// Update view based on props
  public override func update() {
    self.label.text = self.props?.title
    self.imageView.image = self.props?.image
  }
}

```

## Built-in Elements
These are default elements that ship with this framework, wrapped in a creator function, such as:
```swift
public func ElementOfLabel(props: String) -> ElementOf<Label> {
    return ElementOf<Label>.init(props: props)
}
```
With them you can get started quickly. These are the complete list of built-in elements:
- `ElementOfLabel(props: String)`
- `ElementOfTextField(props: (text: String?, placeholder: String?))`
- `ElementOfImageView(props: UIImage)`
- `ElementOfButtonWithAction(props: (buttonTitle: String, handler: () -> Void))`
- `ElementOfActivityIndicator(props: Bool)` // Bool is animating or not
- `FlexibleSpace() // or ElementOf<EmptyView>(props: ())` <-- just an empty view made to control dummy spacing

There is only one built-in `Row`:
```swift
func RowOfEmptySpace(height: CGFloat) -> Row
```
This is convenience when you want to add an empty space `Row`.

### Customizing Built-in Elements
These built-in elements are very bland by default (e.g., it's just a default `UILabel()`). You can `styles` them up:
```swift
let el = ElementOfLabel(props: "Yay!").styles { lb in
  lb.font = ...
  lb.textColor = .red
  lb.textAlignment = .center
  lb.numberOfLines = 1 // **by default it's 0**
}
```

### Suggest for improvements? Open an issue!
These choice of built-in elements and props are far from perfect. You can create a issue if you want to improve, e.g., which kind of props we should support. As an example, I think `ElementOfButtonWithAction(props: (buttonTitle: String, handler: () -> Void))` is quite ugly...

## Terminologies
### Element
ViewElement provides a universal abstraction for a UIView, **Element**. Element contains **Props**, a data structure used to configure that view.
This framework already provides basic UIKit elements like UILabel, UIImageView, UIButton, UITextField, UIAcivityIndicator.
(You'll be surprised of how much you could accomplish only by stacking these basic elements on top of each other.)

Then, an element can be used in a table view by wrapping it with ElementContainers: 
- Row(element)
- SectionHeader(element)
- SectionFooter(element)
- TableHeaderView(element)
- StretchyHeader(element)

Most containers use AutoLayout by default. But you can set rowHeight on these containers if you know the height beforehand.

### Component
*Note: This is still an experimental feature.*
Component allows you to make complex view by composing other elements. The framework do this by heavily relying on `UIStackViews` nesting together. This is very experimental feature.
Beware that internally it creates UIStackView for each StackProps and nests them together.

Unlike `ElementOf<SomeViewClass>`, you make a `Component` by subclassing `ComponentOf<SomeProps>`.

For example, to make a component with image view and label aligned horizontally:
```swift
class ImageWithLabelComponent: ComponentOf<(img: UIImage, title: String)> {
  override func shouldElementUpdate(oldProps: (UIImage, String), newProps: (UIImage String)) -> Bool {
    return oldProps.title != newProps.title
  }
  
  override func render() -> StackProps {
    let imgElement= ElementOfImageView(props: props.img)
    let lbElement = ElementOfLabel(props: props.title)
    return HorizontalStack(
            distribute: .equalSpacing,
            align: .center,
            spacing: 20,
            [imgElement, lbElement]) // composing them with stack view
  }
}
```
**IMPORTANT:** In `override func render() -> StackProps `, it looks like you can do what React does, returning arbitrary elements based on props state. However, this framework actually clears the `UIView` and rebuild them. So it's not really performant!

## Limitations
This framework is (at the moment) suitable for creating static pages, e.g. not much animations/interactions on the content.
At the end of the day it's just a `UITableView`.
For highly interactive page with many gestures, consider other options.

## Roadmap
1. I'm thinking on combining this with RxSwift, which allows us to use ViewElements on creating data-driven pages (e.g., any kinds of input forms, with reactivity). The idea is to use Rx setup block in propsType, instead of a fixed, stateful variable like String. For example (Reactive<RxLabel>) -> [Disposable]. 
  
  **Probably in a separated module. Don't what this to bloat further than this.**
  
2. Support UICollectionView. Probably will support only simple horizontal collection view (in a separated library), which is pretty common use-cases.

## Examples
See 'ViewElements/Examples'. It's not polished though, more like a playground for myself while developing this framework (sry lol).

## Alternatives
You could look into these instead, probably more elegant that this framework lol:
- [Eureka](https://github.com/xmartlabs/Eureka), for form building
- [SwiftForms](https://github.com/ortuman/SwiftForms), for form building
- [Leego](https://github.com/wangshengjia/LeeGo), general-purpose, very similar to this, not diving deep into this yet
- [BrickKit](https://github.com/wayfair/brickkit-ios), super general-purpose, built with collection view, as it should be

### Then Why ViewElements?
It's easy to use and understand (I hope). Not much magic. If you know how to use UITableView, then you can get started right away.
