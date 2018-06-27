#  API Client usage

```swift
//
//  This is an sample ViewController shows how to use API Wrapper
//  
//

import UIKit

class ViewController: UIViewController {
    
    let cryptoCompareClient = CryptoCompareClient()
    let marketCapClient = MarketCapClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all coins from cryptocompare api
        cryptoCompareClient.getCoinList(){result in
            switch result{
            case .success(let resultData):
                guard let coinList = resultData?.Data else {return}
                for (key,value) in coinList{
                    print(key, value.FullName ?? "")
                }

            case .failure(let error):
                print("the error \(error.localizedDescription)")

            }
        }
        // Get all exchanges from cryptocompare api
        cryptoCompareClient.getExchangeList(){ result in
            switch result{
            case .success(let resultData):
                print(resultData?.AllExchanges["BTCMarkets"]?.TradingPairs["BTC"] ?? "")
                guard let exchangePairs = resultData?.AllExchanges else {return}
                for(exc, pairs) in exchangePairs{
                    print(exc, pairs)
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")

            }

        }

        // Get all trading price by given trading pairs or exchanges from cryptocompare api
        cryptoCompareClient.getTradePrice(from: "BTC"){ result in
            switch result{
            case .success(let resultData):
                for(currency, value) in resultData!{
                    print(currency, value)
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }

        }
        cryptoCompareClient.getTradePrice(from: "BTC", to: "AUD", exchange: "BTCMarkets"){ result in
            switch result{
            case .success(let resultData):
                for(currency, value) in resultData!{
                    print(currency, value)
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }

        }
        // Get all coins market capicities from CoinMarketCap API
        marketCapClient.getTickers(){ result in
            switch result{
            case .success(let resultData):
                for coinDetail in resultData!{
                    for (key,value) in coinDetail{
                        print(key, value ?? "")
                    }
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")

            }
        }
        // Get specified coin market Capitalization
        marketCapClient.getTrickerById(coinId: "bitcoin"){ result in
            switch result{
            case .success(let resultData):

                guard let coinDetail = resultData?[0] else {return}

                for (key,value) in coinDetail{
                    print(key, value ?? "")
                }

            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }
        }
        // Get global market Capitalization
        marketCapClient.getGlobalCap(convert: "CNY"){ result in
            switch result{
            case .success(let resultData):
                guard let globalCap = resultData else {return}
                for (key,value) in globalCap{
                    print(key, value ?? "")
                }
                
            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }
            
        }

        
        
    }
    
}


```

