//
//  AssetView.swift
//  NFTV
//
//  Created by Alex Mason on 10/28/21.
//

import SwiftUI

struct FullAssetView: View {
    @ObservedObject var asset: OpenSeaAsset
    
    var body: some View {
        if let wrapper = asset.imageWrapper {
            ZStack {
                /* Background */
                Color.black
                    .ignoresSafeArea()
                
                /* Image */
                #if os(macOS)
                Image(nsImage: wrapper.image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                #else
                Image(uiImage: wrapper.image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                #endif
                
                /* Image */
                VStack(alignment: .leading) {
                    // Button on left side
                    HStack(alignment: .top) {
                        // Close button
                        Button {
                            print("close")
                        } label: {
                            Image(systemName: "xmark")
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    /* Push to left side*/
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(asset.assetName)
                            Text(asset.collectionName)
                        }
                        .padding()
                        Spacer()
                    }
                }
                .focusSection()
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
