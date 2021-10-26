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
            #if os(macOS)
            Image(nsImage: wrapper.image)
            #else
            Image(uiImage: wrapper.image)
            #endif
        } else {
            Image(systemName: "wifi.slash")
        }
        
    }
}

struct AssetOverviewView: View {
    
    var columns = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    let assets: [OpenSeaAsset]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(assets) { asset in
                    AssetView(asset: asset)
                }
            }
        }
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView(assets: [])
    }
}
