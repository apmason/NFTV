//
//  OpenSeaProfile.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

struct UserData {
    let address: String
    let username: String?
    let profileURL: URL?
}

class OpenSeaProfile {
    
    let address: String
    let username: String?
    var assets: [OpenSeaAsset] = []
    
    /// Returns an ETH address in the form of 0x1234...5678
    var displayableAddress: String {
        let startSequence = address.prefix(6) // get first 6 characters (0x + the first four characters)
        let endSequence = address.suffix(4) // get last 4 characters

        return startSequence + "..." + endSequence
    }
    
    init(address: String, username: String? = nil) {
        self.address = address
        self.username = username
    }
}
