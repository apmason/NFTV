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
    
    init(asset: OpenSeaAsset) {
        self.asset = asset
        print("wrapper is nil: \(asset.imageWrapper == nil)")
        self.imageWrapper = asset.imageWrapper
    }
    
    var body: some View {
        if let wrapper = self.imageWrapper {
            ZStack {
                /* Background */
                Color.black
                    .ignoresSafeArea()
                
                Group {
                    /* Image */
#if os(macOS)
                    Image(nsImage: wrapper.image)
                        .resizable()
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                        .opacity(fadeOut ? 0 : 1)
#else
                    Image(uiImage: wrapper.image)
                        .resizable()
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                        .opacity(fadeOut ? 0 : 1)
#endif
                    
                    VStack(alignment: .leading) {
                        /* Close button on left side */
                        HStack(alignment: .top) {
                            Button {
                                OpenSeaModel.shared.slideshowModel  = nil
                                OpenSeaModel.shared.activeAsset = nil
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
                    withAnimation(.easeOut(duration: 1)) {
                        self.fadeOut = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.imageWrapper = newWrapper // set new image without animation
                            self.assetName = asset.assetName
                            self.collectionName = asset.collectionName
                            
                            withAnimation(.easeInOut(duration: 1)) {
                                self.fadeOut = false // fade image in
                            }
                        }
                    }
                }
            }
        } else {
            Color.gray
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
        FullAssetView(asset: asset)
    }
}
