//
//  AssetOverviewView.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI

struct AssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
        
    init(asset: OpenSeaAsset) {
        self.asset = asset
        self.asset.retrieveURL()
    }
    
    var body: some View {
        if let wrapper = asset.imageWrapper {
            Button.init {
                print("button tapped")
            } label: {
            #if os(macOS)
                Image(nsImage: wrapper.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            #else
                Image(uiImage: wrapper.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            #endif
            }.buttonStyle(CardButtonStyle())

        } else {
            Image(systemName: "wifi.slash")
        }
        
    }
}

struct AssetOverviewView: View {
    
    var columns = [
        GridItem(spacing: 50),
        GridItem(spacing: 50),
        GridItem(spacing: 50)
    ]
    
    let assets: [OpenSeaAsset]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(assets) { asset in
                    AssetView(asset: asset)
                }
            }
            .padding(20)
        }
        .focusSection()
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView(assets: [])
    }
}
