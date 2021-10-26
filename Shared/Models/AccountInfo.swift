//
//  AccountInfo.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// Utility to wrap images for cross platform use
public class ImageWrapper {
#if os(macOS)
    let image: NSImage
    
    init(image: NSImage) {
        self.image = image
    }
#else
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
#endif
    
    
}

class AccountInfo: ObservableObject {
    let address: String
    let username: String?
    
    var profileImageURL: URL?
    
    @Published var imageWrapper: ImageWrapper?
    
    var displayableAddress: String {
        let startSequence = address.prefix(6) // get first 6 characters (0x + the first four characters)
        let endSequence = address.suffix(4) // get last 4 characters
        return startSequence + "..." + endSequence
    }
    
    init(address: String, username: String?, profileImageURL: URL?) {
        self.address = address
        self.username = username
        self.profileImageURL = profileImageURL
        guard let profileURL = self.profileImageURL else {
            return
        }
        
        // pull image
        fetchProfileImage(at: profileURL, completion: { imageWrapper in
            DispatchQueue.main.async {
                self.imageWrapper = imageWrapper
            }
        })
    }
    
    // Pull the profile image from the network and return if possible
    private func fetchProfileImage(at url: URL, completion: @escaping (ImageWrapper?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                print("Image fetch failing silently")
                return
            }
            
            #if os(macOS)
            guard let image = NSImage(data: data) else {
                completion(nil)
                return
            }
            #else
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            #endif
            
            completion(ImageWrapper(image: image))
        }.resume()
    }
}
