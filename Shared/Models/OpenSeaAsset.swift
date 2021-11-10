//
//  OpenSeaAsset.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI
import Foundation
import AVFoundation

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
        
        //DispatchQueue.global(qos: .userInteractive).async {
            ImageCache.publicCache.load(url: (imageURL as NSURL), item: self) { asset, wrapper in
                DispatchQueue.main.async {
                    self.imageWrapper = wrapper
                }
            }
        //}
    }
    
    var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    
    // Attempt to create a player. If we're creating a player for a slideshow we won't loop the player.
    func attemptToCreatePlayer(forSlideshow: Bool) -> AVPlayer? {
        print("attempt player")
        guard let animationURL = animationURL else {
            return nil
        }
        
        // return player right away if possible
        if let player = self.player {
            return player
        }

        if forSlideshow {
            self.player = AVPlayer(url: animationURL)
        } else {
            // Loop the video
            let playerItem = AVPlayerItem(url: animationURL)
            let queuePlayer = AVQueuePlayer(playerItem: playerItem)
            self.player = queuePlayer
            self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        }
        
        return self.player
    }
    
    // stop player
    func clearPlayer() {
        self.playerLooper?.disableLooping()
        self.player?.pause()
        self.playerLooper = nil
        self.player = nil
    }

}
