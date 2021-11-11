//
//  AccountPersister.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import Foundation

class AccountPersister {
    
    static private let addressKey: String = "addressKey"
    static private let usernameKey: String = "usernameKey"
    
    static private let secondsPerSlideKey: String = "secondsPerKey"
    
    static func persist(account: OpenSeaAccount) {
        UserDefaults.standard.set(account.accountInfo.address, forKey: addressKey)
        UserDefaults.standard.set(account.accountInfo.username, forKey: usernameKey)
    }
    
    static func fetchPersistedAccount() -> OpenSeaAccount? {
        // We only want to continue if we have a address
        guard let address = UserDefaults.standard.string(forKey: addressKey) else {
            return nil
        }
        
        let username = UserDefaults.standard.string(forKey: usernameKey)
        
        return OpenSeaAccount(address: address, username: username)
    }
    
    static func clearPersistedData() {
        UserDefaults.standard.set(nil, forKey: addressKey)
        UserDefaults.standard.set(nil, forKey: usernameKey)
    }
    
    static func persist(secondsPerSlide: TimeInterval) {
        UserDefaults.standard.set(secondsPerSlide, forKey: secondsPerSlideKey)
    }
    
    static func fetchPersistedSecondsPerSlide() -> TimeInterval? {
        let fetchedValue = UserDefaults.standard.double(forKey: secondsPerSlideKey)
        return fetchedValue > 0.0 ? fetchedValue : nil
    }
}
