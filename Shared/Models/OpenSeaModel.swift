//
//  OpenSeaModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import Foundation
import SwiftUI

class OpenSeaModel: ObservableObject {
    
    static let shared = OpenSeaModel()
    
    // The account that has been "signed in"
    @Published var activeAccount: OpenSeaAccount? {
        didSet {
            if let account = activeAccount {
                AccountPersister.persist(account: account)
            }
        }
    }
    
    // The asset to show in a full screen view
    @Published var activeAsset: OpenSeaAsset?
    
    @Published var showSlideshow: Bool = false
    
    @Published var showSettings: Bool = false
    
    var slideshowModel: SlideshowModel?
        
    var slideshowActive: Bool {
        return slideshowModel != nil
    }
    
    private init() {
        // Check if we have an account already signed in. We'll take the user directly to the account screen, but we'll need
        // to fetch the assets.
//        self.activeAccount = OpenSeaAccount(address: "0xc3a8b0ee40098e32c1d749ebcdc6c144ada911cd")
//        return
    
        guard let account = AccountPersister.fetchPersistedAccount() else {
            return
        }
        
        self.activeAccount = account
        
        OpenSeaAPI.fetchAssets(for: account.accountInfo.address) { result in
            switch result {
            case .success(let accountData):
                DispatchQueue.main.async {
                    self.setAccountData(for: account, data: accountData)
                }
                
            case .failure(let error):
                print("OpenSeaModel.swift: Error getting assets - \(error.localizedDescription)")
                
            }
        }
        
//        activeAccount = OpenSeaAccount(address "0x51906b344eae66a8bc3db3efb2da3d79507aa06e")
    }
    
    func attemptSignIn(for address: String, completion: @escaping  ((Error?) -> Void)) {
        OpenSeaAPI.fetchAssets(for: address) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let account = OpenSeaAccount(address: address)
                    self.activeAccount = account
                    
                    self.setAccountData(for: account, data: data)
                    
                    completion(nil)
                }
                
            case .failure(let error):
                print("OpenSeaModel.swift: Error getting assets - \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    func beginSlideshow() {
        guard let activeAccount = activeAccount else {
            return
        }
        
        slideshowModel = SlideshowModel(assets: activeAccount.assets)
        slideshowModel?.beginSlideshow()
    }
    
    func endSlideshow() {
        slideshowModel  = nil
        activeAsset = nil
    }
    
    func signOutAccount() {
        activeAccount = nil
        showSettings = false
        AccountPersister.clearPersistedData()
    }
    
    func exitSettings() {
        showSettings = false
    }
    
    private func setAccountData(for account: OpenSeaAccount, data: (AccountInfo, [OpenSeaAsset])) {
        account.accountInfo = data.0
        account.assets = data.1
        
        account.accountInfo.fetchProfile()
    }
}
