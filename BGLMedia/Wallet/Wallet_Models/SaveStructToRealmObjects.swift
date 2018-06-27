//
//  SaveStructToRealmObjects.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 8/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Bool) {
        realm.add(value.managedObject(), update: update)
    }
}
// Implement the Container
public final class Container {
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
        throws {
            let transaction = WriteTransaction(realm: realm)
            try realm.write {
                try block(transaction)
            }
    }
}

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
