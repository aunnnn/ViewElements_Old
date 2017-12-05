//
//  Props.swift
//  ViewElements
//
//  Created by Wirawit Rueopas on 5/30/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

// MARK: - Variable

public typealias Props = Any

/// Anything that has 'unTypedProps' variable.
public protocol UnTypedPropsAccessible {
    var unTypedProps: Props { get }
}

/// Anything that has typed props.
public protocol TypedPropsAccessible: UnTypedPropsAccessible {
    associatedtype PropsType: Props
    var props: PropsType { get }
}

// Default implementation.
public extension TypedPropsAccessible {
    var props: PropsType {
        let utp = self.unTypedProps
        guard let tp = utp as? Self.PropsType else {
            fatalError("Wrong props type (Expect '\(PropsType.self)', but found '\(type(of: utp))').")
        }
        return tp
    }
}

/// Anything that has 'unTypedProps' variable.
public protocol OptionalUnTypedPropsAccessible {
    var unTypedProps: Props? { get }
}

/// Anything that has typed props.
public protocol OptionalTypedPropsAccessible: OptionalUnTypedPropsAccessible {
    associatedtype PropsType: Props
    var props: PropsType? { get }
}

// Default implementation.
public extension OptionalTypedPropsAccessible {
    var props: PropsType? {
        guard let utp = self.unTypedProps else { return nil }
        guard let tp = utp as? Self.PropsType else {
            fatalError("Wrong props type (Expect '\(PropsType.self)', but found '\(type(of: utp))').")
        }
        return tp
    }
}

// MARK:- Update

public protocol UnTypedPropsShouldElementUpdate {
    func unTypedShouldElementUpdate(oldProps: Props, newProps: Props) -> Bool
}

/// Whether the Element (and UIView) associated with this component should update with received new Props.
public protocol TypedPropsShouldElementUpdate: TypedPropsAccessible {
    associatedtype PropsType: Props
    func shouldElementUpdate(oldProps: PropsType, newProps: PropsType) -> Bool
}

public extension TypedPropsShouldElementUpdate {
    public func unTypedShouldElementUpdate(oldProps: Props, newProps: Props) -> Bool {
        guard let _oldProps = oldProps as? PropsType, let _newProps = newProps as? PropsType else { return true }
        return self.shouldElementUpdate(oldProps: _oldProps, newProps: _newProps)
    }
}
