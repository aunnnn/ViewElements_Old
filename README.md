# ViewElements
[![Version](https://img.shields.io/cocoapods/v/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)
[![License](https://img.shields.io/cocoapods/l/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)
[![Platform](https://img.shields.io/cocoapods/p/ViewElements.svg?style=flat)](http://cocoapods.org/pods/ViewElements)

A framework to manage and reuse UIViews in iOS apps.

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

## Overview
All iOS apps use `UITableView`, but it's quite a hassle to set that up everytime. 
This framework does the heavy lifting for you.
It abstracts views into view models like Row, SectionHeader, SectionFooter. You can compose the model to make a table.
Want to change rows order? Just change the order in the array. Want 10 label rows?:
```swift
let rows = (0..<10).map { Row(ElementOfLabel("Label no. \($0)")) }
```
Manipulate them like a primitive data!

## Brief Tour
### Creating a simple table

1. Make `ElementOf<SomeViewClass>`:
```swift
let el = ElementOf<Label>(props: "Yay!") // = a general view
```
Note: `Label` is a subclass of `UILabel` that works with this framework. [How to make your own](#how-to-make-a-custom-view).

2. Wrap it with `Row`:
```swift
let labelRow = Row(el) // = a table view cell
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


## How to make a custom view
// TBD

## Terminologies
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

## Limitations
This framework is (at the moment) suitable for creating static pages, e.g. no states/interactions on the content.
At the end of the day it's just a UITableView.
For highly interactive page with many gestures, consider other options.

## Roadmap
1. I'm working on combining this with RxSwift, which allows us to use ViewElements on creating data-driven pages (e.g., any kinds of input forms, with reactivity). The idea is to use Rx setup block in propsType, instead of a fixed, stateful variable like String. For example (Reactive<RxLabel>) -> [Disposable].   
2. Support UICollectionView
  
Then you can setup all your Rx things there at the element creation time. You have to implement RxLabel yourself though, and manage the DisposeBag there.

## Getting Started

### 1. Create a view to use with this framework
- Make a UIView nib that subclasses BaseNibView (for programmatically-created UIView, subclass BaseView)
- Define *PropsType*
- Implements setup/update functions

(...in progress, for now, see Examples first)

## Examples
See 'ViewElements/Examples'.

## Alternatives
You could look into these instead, probably more elegant that this framework lol:
- [Eureka](https://github.com/xmartlabs/Eureka), for form building
- [SwiftForms](https://github.com/ortuman/SwiftForms), for form building
- [Leego](https://github.com/wangshengjia/LeeGo), general-purpose, very similar to this, not diving deep into this yet
- [BrickKit](https://github.com/wayfair/brickkit-ios), super general-purpose, built with collection view, as it should be

### Then Why ViewElements?
It's easy to use and understand (I hope). Not much magic. If you know how to use UITableView, then you can get started right away.
