//
//  OpenSeaModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import Foundation

class AccountPersister {
    
    static private let addressKey: String = "addressKey"
    static private let usernameKey: String = "usernameKey"
    
    // TODO: - Maybe we just need to save the address and we'll pull the username from the API?
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
    
    @Published var activeAsset: OpenSeaAsset?
        
    private init() {
        // Check if we have an account already signed in. We'll take the user directly to the account screen, but we'll need
        // to fetch the assets.
        guard let account = AccountPersister.fetchPersistedAccount() else {
            return
        }
        
        self.activeAccount = account
        
        OpenSeaAPI.fetchAssets(for: account.accountInfo.address) { result in
            switch result {
            case .success(let account):                
                DispatchQueue.main.async {
                    self.activeAccount?.accountInfo = account.0
                    self.activeAccount?.assets = account.1
                    
                    self.activeAccount?.accountInfo.fetchProfile()
                }
                
            case .failure(let error):
                print("OpenSeaModel.swift: Error getting assets - \(error.localizedDescription)")
                
            }
        }
        
        //AccountPersister.clearPersistedData()
//        activeAccount = OpenSeaAccount(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e",
//                                       username: "zeent",
//                                       profileImageURL: URL(string: "https://storage.googleapis.com/opensea-static/opensea-profile/32.png")!)
    }
}
