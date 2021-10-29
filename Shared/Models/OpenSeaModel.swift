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

class SlideshowModel {
    
    let assets: [OpenSeaAsset]
    
    // What asset in the array to show
    private var assetIndex: Int = 0
    
    // Grab from EnvironmentObject?
    // Time per slide in seconds
    let timePerSlide: TimeInterval = 5
    
    var timer: Timer?
    
    init(assets: [OpenSeaAsset]) {
        self.assets = assets
    }
    
    func begin() {
        guard assets.count > 0 else {
            return
        }
        
        OpenSeaModel.shared.activeAsset = assets[assetIndex]
        
        // start timer
        timer = Timer.scheduledTimer(timeInterval: timePerSlide,
                                         target: self,
                                         selector: #selector(nextSlide),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc private func nextSlide() {
        assetIndex += 1
        
        // don't overflow, reset
        if assetIndex == assets.count {
            assetIndex = 0
        }
        
        // set new asset
        OpenSeaModel.shared.activeAsset = assets[assetIndex]
    }
}

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
    
    var slideshowModel: SlideshowModel?
        
    private init() {
        // Check if we have an account already signed in. We'll take the user directly to the account screen, but we'll need
        // to fetch the assets.
//        self.activeAccount = OpenSeaAccount(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e")
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
        slideshowModel?.begin()
    }
    
    private func setAccountData(for account: OpenSeaAccount, data: (AccountInfo, [OpenSeaAsset])) {
        account.accountInfo = data.0
        account.assets = data.1
        
        account.accountInfo.fetchProfile()
    }
}
