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
    
    /// If this is a vertical stack, this value tells whether subviews also fill horizontal axis.
    public var verticalStackAlsoFillsHorizontalAxis = true
    
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
        
//        if self.axis == .vertical && verticalStackAlsoFillsHorizontalAxis {
//            subviews.forEach({ (sv) in
//                sv.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//                sv.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
//            })
//        }
        
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
    public init(distribute: UIStackViewDistribution, align: UIStackViewAlignment, spacing: CGFloat, _ elements: @escaping @autoclosure () -> [ViewBuildable]) {
        super.init(.vertical, elements)
        self.distribution = distribute
        self.alignment = align
        self.spacing = spacing
    }
}

public final class HorizontalStack: StackProps {
    public init(distribute: UIStackViewDistribution, align: UIStackViewAlignment, spacing: CGFloat, _ elements: @escaping @autoclosure () -> [ViewBuildable]) {
        super.init(.horizontal, elements)
        self.distribution = distribute
        self.alignment = align
        self.spacing = spacing
    }
}
