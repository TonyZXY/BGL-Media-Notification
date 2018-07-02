//
//  NetworkManager.swift
//  BGLMedia
//
//  Created by Victor Ma on 2/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    
    /****
     In the class above, we have defined a couple of helper functions that will help us get started with network status monitoring. We have a sharedInstance that is a singleton and we can call that if we do not want to create multiple instances of the NetworkManager class.
     
     In the init method, we create an instance of Reachability and then we register a notification using the NotificationCenter class. Now, every time the network status changes, the callback specified by NotificationCenter (which is networkStatusChanged) will be called. We can use this to do something global that is activated when the network is unreachable.
     
     We have defined other helper functions that will generally make running code depending on the status of our internet connection a breeze. We have *isReachable*, *isUnreachable*, *isReachableViaWWAN* and *isReachableViaWiFi*.
     
     The usage of one of these helpers will generally look like this:
     
     
         NetworkManager.isReachable { networkManagerInstance in
         print("Network is available")
         }
     
         NetworkManager.isUnreachable { networkManagerInstance in
         print("Network is Unavailable")
         }

     
     ****/
    
    
    var reachability: Reachability!
    
    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = Reachability()!
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}



