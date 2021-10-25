//
//  OpenSeaProfile.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

class OpenSeaProfile {
    
    let address: String
    let username: String?
    var assets: [OpenSeaAsset] = []
    
    init(address: String, username: String? = nil) {
        self.address = address
        self.username = username
    }
}
