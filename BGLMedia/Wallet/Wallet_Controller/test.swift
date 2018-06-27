//func setWalletData(){
//    //        var walletResults = [MarketTradingPairs]()
//    var list = [String]()
//    let coinSelected = realm.objects(MarketTradingPairs.self)
//    for asset in allResult{
//        if list.contains(asset.coinAbbName) == false{
//            list.append(asset.coinAbbName)
//            let filterName = "coinAbbName = '" + asset.coinAbbName + "' "
//            let objects = realm.objects(AllTransactions.self).filter(filterName)
//            let coinObject = MarketTradingPairs()
//            coinObject.coinAbbName = (objects.first?.coinAbbName)!
//            coinObject.coinName = (objects.first?.coinName)!
//            let coinSelected = coinSelected.filter(filterName)
//            if coinSelected.count == 0{
//                coinObject.tradingPairsName = asset.tradingPairsName
//                coinObject.exchangeName = asset.exchangName
//            } else {
//                for result in coinSelected{
//                    coinObject.exchangeName = result.exchangeName
//                    coinObject.tradingPairsName = result.tradingPairsName
//                }
//            }
//
//            for coinValue in objects{
//                if coinValue.status == "Buy"{
//                    coinObject.coinAmount += coinValue.amount
//                    for result in coinValue.currency{
//                        if result.name == priceType.first{
//                            coinObject.transactionPrice += result.price * asset.amount
//                        }
//                    }
//                }else if coinValue.status == "Sell"{
//                    coinObject.coinAmount -= coinValue.amount
//                    for result in coinValue.currency{
//                        if result.name == priceType.first{
//                            coinObject.transactionPrice -= result.price * asset.amount
//                        }
//                    }
//                }
//            }
//
//            
//            CryptoCompareClient().getTradePrice(from: asset.coinAbbName, to: asset.tradingPairsName, exchange: asset.exchangName){ result in
//                switch result{
//                case .success(let resultData):
//                    for results in resultData!{
//                        let single = Double(results.value)
//
//                        GetDataResult().getCryptoCurrencyApi(from: asset.coinAbbName, to: self.priceType, price: single, completion: { (success, jsonResult) in
//                            var price:Double = 0
//                            for currency in jsonResult{
//                                price = currency.value
//                            }
//                            coinObject.singlePrice = price
//                            coinObject.totalPrice = price * coinObject.coinAmount
//                            coinObject.totalRiseFall = coinObject.totalPrice - coinObject.transactionPrice
//                            coinObject.totalRiseFallPercent = (coinObject.totalRiseFall / coinObject.transactionPrice) * 100
//
//                            self.realm.beginWrite()
//                            let realmData:[Any] = [coinObject.coinName,coinObject.coinAbbName,coinObject.exchangeName,coinObject.tradingPairsName,coinObject.coinAmount,coinObject.totalRiseFall,coinObject.singlePrice,coinObject.totalPrice,coinObject.totalRiseFallPercent,coinObject.transactionPrice,self.priceType]
//                            if self.realm.object(ofType: MarketTradingPairs.self, forPrimaryKey: coinObject.coinAbbName) == nil {
//                                self.realm.create(MarketTradingPairs.self, value: realmData)
//                            } else {
//                                self.realm.create(MarketTradingPairs.self, value: realmData, update: true)
//                            }
//                            try! self.realm.commitWrite()
//                        })
//                    }
//                case .failure(let error):
//                    print("the error \(error.localizedDescription)")
//                }
//            }
//
//
//
//        }
//
//
//    }
//}
