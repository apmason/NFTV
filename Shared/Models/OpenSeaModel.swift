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
    
    @Published var showSlideshow: Bool = false
        
    @Published var slideshowModel: SlideshowModel
        
    // How long to show each slide, in seconds
    var secondsPerSlide: TimeInterval = AccountPersister.fetchPersistedSecondsPerSlide() ?? 5 {
        didSet {
            AccountPersister.persist(secondsPerSlide: secondsPerSlide)
            slideshowModel.secondsPerSlide = secondsPerSlide
        }
    }
    
    private init() {
        self.slideshowModel = SlideshowModel(secondsPerSlide: secondsPerSlide)
        
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
                    self.setAccountDataAndMakeSlideshowModel(for: account, data: accountData)
                }
                
            case .failure(let error):
                print("OpenSeaModel.swift: Error getting assets - \(error.localizedDescription)")
                
            }
        }
    }
    
    func attemptSignIn(for address: String, completion: @escaping  ((Error?) -> Void)) {
        OpenSeaAPI.fetchAssets(for: address) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let account = OpenSeaAccount(address: address)
                    self.activeAccount = account
                    
                    self.setAccountDataAndMakeSlideshowModel(for: account, data: data)
                    
                    completion(nil)
                }
                
            case .failure(let error):
                print("OpenSeaModel.swift: Error getting assets - \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    func signOutAccount() {
        activeAccount = nil
        AccountPersister.clearPersistedData()
    }
    
    private func setAccountDataAndMakeSlideshowModel(for account: OpenSeaAccount, data: (AccountInfo, [OpenSeaAsset])) {
        account.accountInfo = data.0
        account.assets = data.1
        
        account.accountInfo.fetchProfile()
     
        slideshowModel.assets = account.assets
    }
}
