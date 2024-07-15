//
//  UIBuilder.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

fileprivate protocol Maker: AnyObject {
    associatedtype Object
    var returnObject: Object { get set }
}

extension Maker {
    func propertyAssigner<Property>(for keyPath: KeyPath<Object, Property>) -> PropertyAssigner<Object, Property, Self> {
        PropertyAssigner(keypathOwner: returnObject, keyPath: keyPath) { value, assignType in
            switch assignType {
            case .directAssign:
                break
            case .toParent:
                if Property.self is AnyClass {
                    return self
                }
                break
            case .error:
                return self
            }
            guard let writable = keyPath as? WritableKeyPath<Object, Property> else { return self }
            self.returnObject[keyPath: writable] = value
            return self
        }
    }
}

@dynamicMemberLookup
final class UIBuilder<Object: NSObject>: Maker {
    var returnObject: Object
    
    typealias ExtraBuild = (Object) -> ()
    
    init(_ object: Object) {
        returnObject = object
    }
    
    init() {
        returnObject = Object()
    }
    
    init(_ type: Object.Type) {
        returnObject = type.init()
    }
    
    subscript<Property>(dynamicMember keyPath: KeyPath<Object, Property>) -> PropertyAssigner<Object, Property, UIBuilder<Object>> {
        propertyAssigner(for: keyPath)
    }
    
    func build(_ extraBuild: ExtraBuild? = nil) -> Object {
        extraBuild?(returnObject)
        return returnObject
    }
}

enum AssigningType {
    case directAssign
    case toParent
    case error
}

@dynamicCallable
@dynamicMemberLookup
final class PropertyAssigner<Object, Property, ReturnValue> {
    var keypathOwner: Object
    var keyPath: KeyPath<Object, Property>
    var parentAsigning: (Property, AssigningType) -> ReturnValue
    
    init(
        keypathOwner: Object,
        keyPath: KeyPath<Object, Property>,
        whenAssigned parentAsigning: @escaping (Property, AssigningType) -> ReturnValue
    ) {
        self.keypathOwner = keypathOwner
        self.keyPath = keyPath
        self.parentAsigning = parentAsigning
    }
    
    // MARK: - @dynamicCallable ()
    
    func dynamicallyCall(withArguments arguments: [Property]) -> ReturnValue {
        parentAsigning(arguments[0], .directAssign)
    }
    
    // MARK: - @dynamicMemberLookup
    
    subscript<SubProperty>(
        dynamicMember keyPath: KeyPath<Property, SubProperty>
    ) -> PropertyAssigner<Property, SubProperty, ReturnValue> {
        var property = keypathOwner[keyPath: self.keyPath]
        return .init(keypathOwner: property, keyPath: keyPath) { value, assignType in
            switch assignType {
            case .directAssign:
                break
            case .toParent:
                if SubProperty.self is AnyClass {
                    return self.parentAsigning(property, .toParent)
                }
                break
            case .error:
                return self.parentAsigning(property, .error)
            }
            guard let writable = keyPath as? WritableKeyPath<Property, SubProperty> else {
                return self.parentAsigning(property, .toParent)
            }
            property[keyPath: writable] = value
            return self.parentAsigning(property, .toParent)
        }
    }
}
