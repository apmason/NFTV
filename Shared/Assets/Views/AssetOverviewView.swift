//
//  AssetOverviewView.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI

private extension AssetView {
    struct HeightPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

struct AssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
    
    @State private var customHeight: CGFloat?
        
    init(asset: OpenSeaAsset) {
        self.asset = asset
        self.asset.retrieveURL()
    }
    
    var body: some View {
        Button.init {
            OpenSeaModel.shared.activeAsset = asset
        } label: {
            #if os(macOS)
            Text("Mac") // TODO: - fix for Mac
            #else
            if let wrapper = asset.imageWrapper {
                Image(uiImage: wrapper.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                
            } else {
                Color.gray
                    .scaledToFill()
                    .cornerRadius(5)
            }
            #endif
        }
        .buttonStyle(DefaultButtonStyle())
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
                    ZStack {
                        AssetView(asset: asset)
                    }
                }
            }
            .padding(20)
        }
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
