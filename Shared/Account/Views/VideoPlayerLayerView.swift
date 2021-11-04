//
//  VideoPlayerLayerView.swift
//  VideoPlayerTest
//
//  Created by Alex Mason on 11/4/21.
//

#if os(iOS) || os(tvOS)
import AVKit
import UIKit
import SwiftUI

class UIPlayerLayerView: UIView {
    // Make AVPlayerLayer the view's backing layer
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    private var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}

// A view that plays a video using an AVPlayerLayer
struct VideoPlayerLayerView: UIViewRepresentable {

    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIPlayerLayerView {
        let view = UIPlayerLayerView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: UIPlayerLayerView, context: Context) {
        //
    }
}
#endif
