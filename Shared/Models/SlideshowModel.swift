//
//  SlideshowModel.swift
//  NFTV
//
//  Created by Alex Mason on 10/30/21.
//

import Foundation

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
    
    func begin() {
        guard assets.count > 0 else {
            return
        }
        
        OpenSeaModel.shared.activeAsset = assets[assetIndex]
        
        Timer.scheduledTimer(withTimeInterval: timePerSlide, repeats: true) { [weak self] timer in
            self?.nextSlide()
        }
    }
    
    @objc private func nextSlide() {
        assetIndex += 1
        
        // don't overflow, reset
        if assetIndex == assets.count {
            assetIndex = 0
        }
        
        // set new asset
        OpenSeaModel.shared.activeAsset = assets[assetIndex]
    }
}
