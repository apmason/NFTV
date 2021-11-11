//
//  AssetOverviewView.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI

struct AssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
    
    @State private var viewWidth: CGFloat?
        
    init(asset: OpenSeaAsset) {
        self.asset = asset
        self.asset.retrieveURL()
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: asset.imageWrapper?.image ?? UIImage())
                .resizable()
                .scaledToFit()
                .background(Color.white)
            
            if asset.animationURL != nil {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .foregroundStyle(.white)
                    .scaleEffect(0.5)
            }
            
            /* Description section */
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(asset.assetName)
                            .foregroundColor(.white)
                            .font(.body)
                        Text(asset.collectionName)
                            .foregroundColor(.white)
                            .font(.footnote)
                    }
                    .padding()
                    Spacer()
                }
                .background(
                    Color.black.opacity(0.4)
                )
            }
        }
    }
}

struct AssetOverviewView: View {
    
    var columns = [
        GridItem(spacing: 100),
        GridItem(spacing: 100),
        GridItem(spacing: 100)
    ]
    
    let assets: [OpenSeaAsset]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(assets) { asset in
                    NavigationLink {
                        FullAssetView(asset: asset, useSlideshow: false)
                    } label: {
                        AssetView(asset: asset)
                            .background(Color.white)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .buttonStyle(.plain)
                }
            }
            .padding(32)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.automatic)
        .navigationBarBackButtonHidden(true)
#if os(tvOS)
        .focusSection()
#endif
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView(assets: [])
    }
}
