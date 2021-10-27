//
//  OpenSeaAccount.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

class OpenSeaAccount: ObservableObject {
    
    var accountInfo: AccountInfo
    @Published var assets: [OpenSeaAsset] = []
    
    // we would persist and save this?
    init(address: String, username: String? = nil, profileImageURL: URL? = nil) {
        self.accountInfo = AccountInfo(address: address, username: username, profileImageURL: profileImageURL)
    }

}
