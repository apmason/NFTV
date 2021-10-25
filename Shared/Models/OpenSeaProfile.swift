//
//  OpenSeaProfile.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

struct AccountInfo {
    let address: String
    let username: String?
    let profileURL: URL?
    
    var displayableAddress: String {
        let startSequence = address.prefix(6) // get first 6 characters (0x + the first four characters)
        let endSequence = address.suffix(4) // get last 4 characters
        return startSequence + "..." + endSequence
    }
}

class OpenSeaProfile {
    
    let accountInfo: AccountInfo
    var assets: [OpenSeaAsset] = []
    
    // we would persist and save this?
    init(address: String, username: String? = nil) {
        self.accountInfo = AccountInfo(address: address, username: username, profileURL: nil)
    }
}
