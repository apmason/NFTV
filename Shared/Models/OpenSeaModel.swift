//
//  OpenSeaModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/25/21.
//

import Foundation

class ProfilePersister {
    
    static private let addressKey: String = "addressKey"
    static private let usernameKey: String = "usernameKey"
    
    static func persist(profile: OpenSeaProfile) {
        UserDefaults.standard.set(profile.address, forKey: addressKey)
        UserDefaults.standard.set(profile.username, forKey: usernameKey)
    }
    
    static func fetchProfile() -> OpenSeaProfile? {
        // We only want to continue if we have a address
        guard let address = UserDefaults.standard.string(forKey: addressKey) else {
            return nil
        }
        
        let username = UserDefaults.standard.string(forKey: usernameKey)
        
        return OpenSeaProfile(address: address, username: username)
    }
}

class OpenSeaModel: ObservableObject {
    
    static let shared = OpenSeaModel()
    
    @Published var activeProfile: OpenSeaProfile? {
        didSet {
            if let profile = activeProfile {
                ProfilePersister.persist(profile: profile)
            }
        }
    }
    
    private init() {
        activeProfile = ProfilePersister.fetchProfile()
    }
}
