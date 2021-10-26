//
//  OpenSeaModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import Foundation

// TODO: Should we persist the address URL? I think so, but will come back to that
class AccountPersister {
    
    static private let addressKey: String = "addressKey"
    static private let usernameKey: String = "usernameKey"
    
    static func persist(account: OpenSeaAccount) {
        UserDefaults.standard.set(account.accountInfo.address, forKey: addressKey)
        UserDefaults.standard.set(account.accountInfo.username, forKey: usernameKey)
    }
    
    static func fetchAccount() -> OpenSeaAccount? {
        // We only want to continue if we have a address
        guard let address = UserDefaults.standard.string(forKey: addressKey) else {
            return nil
        }
        
        let username = UserDefaults.standard.string(forKey: usernameKey)
        
        return OpenSeaAccount(address: address, username: username)
    }
}

class OpenSeaModel: ObservableObject {
    
    static let shared = OpenSeaModel()
    
    @Published var activeAccount: OpenSeaAccount? {
        didSet {
            if let account = activeAccount {
                AccountPersister.persist(account: account)
            }
        }
    }
    
    private init() {
        //activeAccount = AccountPersister.fetchAccount()
        
        activeAccount = OpenSeaAccount(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
                                       username: "zeent",
                                       profileImageURL: URL(string: "https://storage.googleapis.com/opensea-static/opensea-account/27.png")!)
    }
}
