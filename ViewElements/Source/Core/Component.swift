//
//  Component.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/25/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

public protocol Component: class, ElementOfView {
    func render() -> StackProps
    var cachedStackProps: StackProps? { get set }
}

open class ComponentOf<T: Props>: Component, TypedPropsShouldElementUpdate {
    
    public let unTypedProps: Props
    
    // render() will always return the same Stackprops for a given Component, unless:
    // - different StackProps is returned based on condition (e.g. of props) inside render().
    public var cachedStackProps: StackProps?

    public init(props: T) {
        self.unTypedProps = props
    }
    
    public final var viewIdentifier: String {
        return "\(type(of: self))"
    }
    
    public final func build() -> UIView {
        return self.render().build()
    }
    
    open func render() -> StackProps {
        fatalError("'render()' in ComponentOf must be subclassed.")
    }
    
    internal func invalidateCachedStackProps() {
        self.cachedStackProps = nil
    }

    open func shouldElementUpdate(oldProps: T, newProps: T) -> Bool {
        return true
    }
}

private class ComponentOfStackView: ComponentOf<StackProps> {
    
    override init(props: StackProps) {
        super.init(props: props)
    }
    
    override func render() -> StackProps {
        return self.props
    }
}

/// Internal scroll view used to wrap stack view to make it scrollable.
internal class _ScrollView: UIScrollView, ElementDisplayable {
    var element: ElementOfView?
    
    static func buildMethod() -> ViewBuildMethod {
        return .init
    }
    
    func setup() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.clipsToBounds = false
    }
    
    func update() {
        if let subview = self.subviews.first as? ElementDisplayable {
            subview.element = self.element
            subview.update()
        } else {
            fatalError("No subview of _ScrollView found.")
        }
    }
}

/// Internal stack view used to build Component.
internal class _StackView: UIStackView, ElementDisplayable {
    
    var element: ElementOfView?
    
    static func buildMethod() -> ViewBuildMethod {
        return .init
    }
    
    func setup() {}
    
    func update() {
        
        let subviews: [ElementDisplayable] = self.subviews.map { (v) -> ElementDisplayable in
            guard let d = v as? ElementDisplayable else {
                fatalError("Found arranged subview ('\(type(of: v))') that is not 'ElementDisplayable'.")
            }
            return d
        }
        guard let component = (self.element as? Component) else {
            fatalError("Found non-Component (\(type(of: self.element))) in _StackView.")
        }
        let stackProps: StackProps; do {
            if let cached = component.cachedStackProps {
                stackProps = cached
            } else {
                stackProps = component.render()
                component.cachedStackProps = stackProps
            }
        }
        
        guard subviews.count == stackProps.elements.count else { fatalError("Unequal number of subviews and stackProps elements.") }
        
        // Iterate child elements & subviews (assuming order of subviews is preserved).
        zip(stackProps.elements, subviews).forEach { (el, sv) in
            let old = sv.element
            let new = el
            sv.element = el
            
            if let oldProps = old?.unTypedProps {
                let newProps = new.unTypedProps
                guard new.unTypedShouldElementUpdate(oldProps: oldProps, newProps: newProps) else {
                    return
                }
            }
            sv.update()
        }
    }
    
    internal func setAllChildrenOpaqueBackgroundColor(color: UIColor) {
        self.arrangedSubviews.forEach { (v) in
            if let st = v as? _StackView {
                st.setAllChildrenOpaqueBackgroundColor(color: color)
            } else {
                v.backgroundColor = color
            }
        }
    }
}

//internal class WrapperStackView: UIView, ElementDisplayable {
//    
//    var element: ElementOfView?
//    var wrappedStackView: _StackView?
//    
//    func setup() {
//        if debugMode {
//            self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
//            self.layer.borderWidth = 1
//            self.layer.borderColor = UIColor.darkGray.cgColor
//        }
//        self.setContentHuggingPriority(1, for: .horizontal)
//        self.setContentHuggingPriority(1, for: .vertical)
//    }
//    
//    func update() {
//        self.wrappedStackView?.element = element
//        self.wrappedStackView?.update()
//    }
//}

public class StackProps: ViewBuildable {

    public var distribution: UIStackViewDistribution = .fill
    public var alignment: UIStackViewAlignment = .top
    public var axis: UILayoutConstraintAxis = .horizontal
    public var spacing: CGFloat = 0
    
    private(set) internal lazy var elements: [ElementOfView] = {
        return self.elementsBlock().map({ (buildable) -> ElementOfView in
            switch buildable {
            case let element as ElementOfView:
                return element
            case let stackProps as StackProps:
                return ComponentOfStackView(props: stackProps)
            default:
                fatalError("Found invalid type of buildable(\(type(of: buildable))).")
            }
        })
    }()
    
    private let elementsBlock: () -> [ViewBuildable]
    
    public init(_ axis: UILayoutConstraintAxis, _ elements: @escaping @autoclosure () -> [ViewBuildable]) {
        self.axis = axis
        self.elementsBlock = elements
    }

    public func build() -> UIView {
        let subviews = self.elements.map { $0.build() }
        let stackView = _StackView(arrangedSubviews: subviews)
        stackView.axis = self.axis
        stackView.distribution = self.distribution
        stackView.alignment = self.alignment
        stackView.spacing = self.spacing

        return stackView
//        let root = WrapperStackView()
//        root.setup()
//        root.addSubview(stackView)
//        stackView.al_pinToEdges(ofView: root)
//        
//        root.wrappedStackView = stackView
//        root.layoutIfNeeded()
        
//        return root
    }
}

public final class VerticalStack: StackProps {
    
    /// Whether each of subviews is stretched to fill horizontal axis.
    public var fillsHorizontally = false
    
    public init(distribute: UIStackViewDistribution, align: UIStackViewAlignment, spacing: CGFloat, _ elements: @escaping @autoclosure () -> [ViewBuildable]) {
        super.init(.vertical, elements)
        self.distribution = distribute
        self.alignment = align
        self.spacing = spacing
    }
    
    public func fillsHorizontally(_ value: Bool) -> VerticalStack {
        self.fillsHorizontally = value
        return self
    }
    
    public override func build() -> UIView {
        let stackView = super.build()
        let subviews = stackView.subviews
        if self.axis == .vertical && self.fillsHorizontally {
            subviews.forEach({ (sv) in
                sv.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
                sv.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
            })
        }
        return stackView
    }
}

public final class HorizontalStack: StackProps {
    
    /// Whether the stack view is scrollable when the content is larger than a stack space. 
    /// If true, the stack view will be wrapped inside a scroll view.
    public var scrollable = false
    
    public init(distribute: UIStackViewDistribution, align: UIStackViewAlignment, spacing: CGFloat, _ elements: @escaping @autoclosure () -> [ViewBuildable]) {
        super.init(.horizontal, elements)
        self.distribution = distribute
        self.alignment = align
        self.spacing = spacing
    }
    
    public override func build() -> UIView {
        let stackView = super.build() as! UIStackView
        if scrollable {
            let scrollView = _ScrollView()
            scrollView.setup()
            scrollView.addSubview(stackView)
            stackView.al_pinToEdges(ofView: scrollView)
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            return scrollView
        } else {
            return stackView
        }
    }
    
    public func scrollable(_ value: Bool) -> HorizontalStack {
        self.scrollable = value
        return self
    }
}
