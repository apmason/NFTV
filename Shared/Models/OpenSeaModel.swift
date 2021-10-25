//
//  OpenSeaModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import Foundation

class OpenSeaModel: ObservableObject {
    
    static let shared = OpenSeaModel()
    
    @Published var activeProfile: OpenSeaProfile?
    
    private init() {}
}
