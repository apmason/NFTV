//
//  OpenSeaAsset.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI
import Foundation

enum OpenSeaAssetType {
    case photo
    case video
    case animation
}

class OpenSeaAsset: Identifiable, ObservableObject {
    
    let imageURL: URL
    
    @Published var imageWrapper: ImageWrapper?
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    func retrieveURL() {
        print("url is \(imageURL.absoluteString)")
        
        ImageCache.publicCache.load(url: (imageURL as NSURL), item: self) { asset, wrapper in
            print("have it here")
            DispatchQueue.main.async {
                self.imageWrapper = wrapper
            }
        }
    }
}
