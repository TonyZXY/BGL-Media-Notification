//
//  CryptoCompareCoinsRealm.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 8/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

final class CryptoCompareCoinsRealm: Object {
    @objc dynamic var Id: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var CoinName: String = ""
    @objc dynamic var FullName: String = ""
    @objc dynamic var Algorithm: String = ""
    @objc dynamic var ProofType: String = ""
    @objc dynamic var ImageUrl: String = ""
    @objc dynamic var TotalCoinSupply: String = ""
    override static func primaryKey() -> String? {
        return "Id"
    }
}

extension CryptoCompareCoin: Persistable {
    public init(managedObject: CryptoCompareCoinsRealm) {
        Id = managedObject.Id
        Name = managedObject.Name
        CoinName = managedObject.CoinName
        FullName = managedObject.FullName
        Algorithm = managedObject.Algorithm
        ProofType = managedObject.ProofType
        ImageUrl = managedObject.ImageUrl
        TotalCoinSupply = managedObject.TotalCoinSupply
    }
    public func managedObject() -> CryptoCompareCoinsRealm {
        let coin = CryptoCompareCoinsRealm()
        coin.Id = Id ?? ""
        coin.Name = Name ?? ""
        coin.CoinName = CoinName ?? ""
        coin.FullName = FullName ?? ""
        coin.Algorithm = Algorithm ?? ""
        coin.ProofType = ProofType ?? ""
        coin.ImageUrl = ImageUrl ?? ""
        coin.TotalCoinSupply = TotalCoinSupply ?? ""
        return coin
    }
}
