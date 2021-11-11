//
//  SlideshowModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import Foundation
import AVFoundation
import SwiftUI

class SlideshowModel: ObservableObject {
    
    var assets: [OpenSeaAsset] = []
    
    @Published var activeAsset: OpenSeaAsset = OpenSeaAsset(assetName: "", collectionName: "", imageURL: nil, animationURL: nil)
    
    // What asset in the array to show
    private var assetIndex: Int = 0
    
    var secondsPerSlide: TimeInterval
    
    var timer: Timer?
    
    weak var observedPlayer: AVPlayer?
    
    init(secondsPerSlide: TimeInterval) {
        self.secondsPerSlide = secondsPerSlide
    }
    
    func beginSlideshow() {
        guard assets.count > 0 else {
            return
        }
        
        assetIndex = 0
        
        setNewAsset()
        
        createAndStartTimer()
    }
    
    private var videoPlaying = false
    
    private func createAndStartTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: secondsPerSlide, repeats: true) { [weak self] timer in
            print("NEXT")
            self?.nextSlide()
        }
    }
        
    // A video has been started
    func videoStarted() {
        guard !videoPlaying else {
            return
        }
        
        self.videoPlaying = true
        
        // clear out the timer
        timer?.invalidate()
        timer = nil
    }
    
    func observe(player: AVPlayer) {
        guard observedPlayer == nil else {
            return
        }
        
        self.observedPlayer = player
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            // video is over, restart regular timer
            self?.removeNotif()
            self?.observedPlayer = nil
            self?.videoPlaying = false
            
            self?.createAndStartTimer()
            self?.nextSlide()
        }
    }
    
    func removeNotif() {
        guard let player = self.observedPlayer else { return }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player)
    }
    
    func stop() {
        removeNotif()
        timer?.invalidate()
        timer = nil
        assetIndex = 0
        observedPlayer = nil
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
        self.activeAsset = assets[assetIndex]
    }
}
