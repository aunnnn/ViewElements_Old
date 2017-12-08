# ViewElements

A framework to manage and reuse UIViews in iOS apps.

````swift

// 0. Subclass TableModelViewController
class ViewController: TableModelViewController {

  override func setup() {
  
    // 1. Create a Row, this is a built-in label element, support multiple lines by default
    let titleRow = Row(ElementOfLabel(props: "Hello!"))

    // 2. You can customize
    let messageRow = Row(ElementOfLabel(props: "This is awesome").styles({ (lb) in
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
        lb.numberOfLines = 1
    }))
    messageRow.backgroundColor = .gray
    messageRow.layoutMarginStyle = .each(vertical: 4, horizontal: 12)
    messageRow.rowHeight = 44
        
    // 3. For a custom element, you will need to declare type of props in MyCustomView, it can be anything, like a tuple.
    let customProps = ("Wow", "This", "Is so flexible!")
    let customRow = Row(ElementOf<MyCustomView>(props: customProps))
    ...

    // 4. To create a section header
    let header = SectionHeader(ElementOfLabel(props: "Easy header"))

    // 5. Building up Section
    let section = Section(header: header, footer: nil, rows: [titleRow, messageRow, ...])

    // 6. Building up Table
    let table = Table(sections: [section]])

    // 7. Then it works from this moment on!
    self.table = table
  }
}
````

## Features
- Setup a view once, use everywhere :tada: as:
  - Row (UITableViewCell)
  - SectionHeader, SectionFooter (UITableHeaderFooterView)
  - tableHeaderView
- Built-in keyboard avoiding
- Solve these common problems for you:
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
Most UIs in iOS can be solved by UITableView. This framework abstracts various types of views into an easy-to-use view models like Row, SectionHeader, SectionFooter, which you can compose them to get a UITableView up real fast.

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
