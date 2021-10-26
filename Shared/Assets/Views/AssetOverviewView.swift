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
        //self.asset.retrieveURL()
    }
    
    var body: some View {
        Color.black
        
//        if asset.imageWrapper != nil {
//            Color.black
////            #if os(macOS)
////            //Image(nsImage: wrapper.image)
////            Color.gray
////            #else
////            //Image(uiImage: wrapper.image)
////            #endif
//        } else {
//            Color.gray
//        }
    }
}

struct AssetOverviewView: View {
    
    var columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
    let assets: [OpenSeaAsset] = [
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(assets) { asset in
                    NavigationLink(destination: AssetView(asset: asset)) {
                        AssetView(asset: asset)
                    }
                }
            }
        }
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView()
    }
}
