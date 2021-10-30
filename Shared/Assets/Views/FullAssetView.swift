//
//  AssetView.swift
//  NFTV
//
//  Created by Alex Mason on 10/28/21.
//

import SwiftUI

struct FullAssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
    
    @State var assetName: String = ""
    @State var collectionName: String = ""
    @State var imageWrapper: ImageWrapper?
    @State var fadeOut: Bool = false
    private var useSlideshow: Bool = false
    
    init(asset: OpenSeaAsset, useSlideshow: Bool) {
        self.asset = asset
        self.useSlideshow = useSlideshow
        
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
#if os(macOS)
            Image(nsImage: wrapper.image)
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
                .focusSection()
                
                Spacer()
                
                /* Asset info on bottom left */
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(assetName)
                        Text(collectionName)
                    }.opacity(fadeOut ? 0 : 1)
                        .padding()
                    Spacer()
                }
            }
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
            withAnimation(.easeOut(duration: 1)) {
                self.fadeOut = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Update to the next asset (opacity is still 0 here)
                    self.imageWrapper = newWrapper
                    self.assetName = asset.assetName
                    self.collectionName = asset.collectionName
                    
                    // Fade new asset in
                    withAnimation(.easeInOut(duration: 1)) {
                        self.fadeOut = false // fade image in
                    }
                }
            }
        }
    }
}

struct FullAssetView_Previews: PreviewProvider {
    
    static var asset: OpenSeaAsset {
        let url = Bundle.main.url(forResource: "example", withExtension: "jpeg")!
        let asset = OpenSeaAsset(assetName: "Pyramid Man",
                                 collectionName: "100 Pyramids",
                                 imageURL: url,
                                 animationURL: nil)
        
        asset.retrieveURL()
        return asset
    }
    
    static var previews: some View {
        FullAssetView(asset: asset, useSlideshow: false)
    }
}
