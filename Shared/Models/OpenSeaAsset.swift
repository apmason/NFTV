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
    
    let assetName: String
    let collectionName: String
    let imageURL: URL?
    let animationURL: URL?
    
    @Published var imageWrapper: ImageWrapper?
    
    init(assetName: String, collectionName: String, imageURL: URL?, animationURL: URL?) {
        self.assetName = assetName
        self.collectionName = collectionName
        self.imageURL = imageURL
        self.animationURL = animationURL
    }
    
    func retrieveURL() {
        guard let imageURL = imageURL else {
            return
        }
        
        ImageCache.publicCache.load(url: (imageURL as NSURL), item: self) { asset, wrapper in
            DispatchQueue.main.async {
                self.imageWrapper = wrapper
            }
        }
    }
}
