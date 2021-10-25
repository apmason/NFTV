//
//  OpenSeaProfile.swift
//  NFTV
//
//  Created by Alexander Mason on 10/22/21.
//

import Foundation

class OpenSeaProfile {
    
    let ethAddress: String
    var assets: [OpenSeaAsset] = []
    
    init(ethAddress: String) {
        self.ethAddress = ethAddress
        
    }
}
