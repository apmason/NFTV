//
//  AssetView.swift
//  NFTV
//
//  Created by Alex Mason on 10/28/21.
//

import AVKit
import SwiftUI

struct FullAssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
    
    @State var assetName: String = ""
    @State var collectionName: String = ""
    @State var imageWrapper: ImageWrapper?
    @State var fadeOut: Bool = false
    private var useSlideshow: Bool = false
    
    private var player: AVPlayer?
    var playerLooper: AVPlayerLooper?
    
    @Namespace var fullViewSpace
    
    init(asset: OpenSeaAsset, useSlideshow: Bool) {
        self.asset = asset
        self.useSlideshow = useSlideshow
        
        if let animationURL = asset.animationURL {
            if useSlideshow {
                self.player = AVPlayer(url: animationURL)
            } else {
                // Loop the video
                let playerItem = AVPlayerItem(url: animationURL)
                let queuePlayer = AVQueuePlayer(playerItem: playerItem)
                self.player = queuePlayer
                self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            }
        }
        
        if self.useSlideshow {
            // Start faded out and then fade back in.
            self.fadeOut = true
            withAnimation {
                self.fadeOut = false
            }
        }
        
        self.imageWrapper = asset.imageWrapper
    }
        
    var body: some View {
        ZStack {
            /* Background (extends to sides of screen) */
            Color.black
                .ignoresSafeArea()
            
            /* Image */
            if let player = player {
                UIVideoPlayerLayerView(player: player)
                    .onAppear {
                        player.play()
                        if useSlideshow {
                            OpenSeaModel.shared.slideshowModel?.observe(player: player)
                            OpenSeaModel.shared.slideshowModel?.videoStarted()
                        }
                    }
                    .ignoresSafeArea()
            } else {
#if os(macOS)
                Image(nsImage: imageWrapper?.image ?? NSImage())
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea() // extend to edge
                    .opacity(fadeOut ? 0 : 1)
#else
                Image(uiImage: imageWrapper?.image ?? UIImage())
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea() // extend to edge
                    .opacity(fadeOut ? 0 : 1)
#endif
            }
            
            VStack(alignment: .leading) {
                /* Close button on left side */
                HStack(alignment: .top) {
                    Button {
                        OpenSeaModel.shared.endSlideshow()
                    } label: {
                        Image(systemName: "xmark")
                    }

                    Spacer()
                }

                Spacer()

                /* Asset info on bottom left */
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(assetName)
                            .font(.body)
                            .foregroundColor(.white)
                        Text(collectionName)
                            .font(.footnote)
                            .foregroundColor(.white)
                    }.opacity(fadeOut ? 0 : 1)
                        .padding()
                    Spacer()
                }
            }
            .focusSection()
            .zIndex(1)
        }
        .onReceive(asset.$imageWrapper) { newWrapper in
            guard self.useSlideshow else {
                // This is the case for a single asset being selected
                self.imageWrapper = newWrapper
                self.assetName = asset.assetName
                self.collectionName = asset.collectionName
                return
            }
            
            // Fade the current asset out
            withAnimation(.easeOut(duration: 0.5)) {
                self.fadeOut = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Update to the next asset (opacity is still 0 here)
                    self.imageWrapper = newWrapper
                    self.assetName = asset.assetName
                    self.collectionName = asset.collectionName
                    
                    // Fade new asset in
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.fadeOut = false // fade image in
                    }
                }
            }
        }
    }
}

struct FullAssetView_Previews: PreviewProvider {
    
    static var asset: OpenSeaAsset {
        let asset = OpenSeaAsset(assetName: "Pyramid Man",
                                 collectionName: "100 Pyramids",
                                 imageURL: nil,
                                 animationURL: nil)        
        return asset
    }
    
    static var previews: some View {
        FullAssetView(asset: asset, useSlideshow: false)
    }
}
