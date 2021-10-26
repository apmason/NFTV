//
//  AssetOverviewView.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI

struct AssetView: View {
    
    init(asset: OpenSeaAsset) {
        //print("get that wrap. \(asset.image == nil)")
        print("in here though")
    }
    
    var body: some View {
        Color.gray
    }
}

struct AssetOverviewView: View {
    
    var columns = [
        GridItem(GridItem.Size.fixed(300), spacing: 50)
    ]
    
    let assets: [OpenSeaAsset] = [
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!),
        OpenSeaAsset(imageURL: URL(string: "https://google.com")!)
    ]
    
    var body: some View {
        NavigationView {
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
        .navigationBarHidden(true)
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView()
    }
}
