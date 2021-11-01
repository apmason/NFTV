//
//  SlideshowModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import Foundation
import AVFoundation

class SlideshowModel {
    
    let assets: [OpenSeaAsset]
    
    // What asset in the array to show
    private var assetIndex: Int = 0
    
    // Grab from EnvironmentObject?
    // Time per slide in seconds
    let timePerSlide: TimeInterval = 5
    
    var timer: Timer?
    
    init(assets: [OpenSeaAsset]) {
        self.assets = assets
    }
    
    func beginSlideshow() {
        guard assets.count > 0 else {
            return
        }
        
        setNewAsset()
        
        createAndStartTimer()
    }
    
    private var videoPlaying = false
    
    private func createAndStartTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timePerSlide, repeats: true) { [weak self] timer in
            self?.nextSlide()
        }
    }
    
    var observedPlayer: AVPlayer?
    
    // A video has been started
    func videoStarted() {
        self.videoPlaying = true
        
        // clear out the timer
        timer?.invalidate()
        timer = nil
    }
    
    func observe(player: AVPlayer) {
        self.observedPlayer = player
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            // can continue
            self?.removeNotif()
            self?.observedPlayer = nil
            self?.videoPlaying = false
            
            self?.createAndStartTimer()
            self?.nextSlide()
        }
    }
    
    private func removeNotif() {
        guard let player = self.observedPlayer else { return }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player)
    }
    
    @objc private func nextSlide() {
        // We want to go to the next slide but a video is playing. We'll wait for the callback to tell us when the video is over, then proceed
        guard !videoPlaying else {
            return
        }
                
        assetIndex += 1
        
        // don't overflow, reset
        if assetIndex == assets.count {
            assetIndex = 0
        }
        
        setNewAsset()
    }
    
    private func setNewAsset() {
        OpenSeaModel.shared.activeAsset = assets[assetIndex]
    }
}
