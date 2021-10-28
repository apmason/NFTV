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
            print("hey")
        } label: {
            if let wrapper = asset.imageWrapper {
                //                Image(uiImage: wrapper.image)
                //                        .resizable()
                //                        .scaledToFit()
                //                Color.clear
                //                    .aspectRatio(1, contentMode: .fill)
                //                    .background(
                //                        Image(uiImage: wrapper.image)
                //                                .resizable()
                //                                .scaledToFill()
                //                    )
                //ZStack {
                Image(uiImage: wrapper.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                
            } else {
                //ZStack {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                //}
            }
        }
        .buttonStyle(DefaultButtonStyle())
        //.frame(width: 400, height: 400)
        

       // if let wrapper = asset.imageWrapper {
//            Color.clear
//                .background(
//                    Image(uiImage: wrapper.image)
//                        .resizable()
//                        .scaledToFit()
//                )
//                Button {
//                    print("button tapped")
//
//                } label: {
//                    #if os(macOS)
//                    Image(nsImage: wrapper.image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    #else
//                    Color.clear
//                        .background(
//                            Image(uiImage: wrapper.image)
//                                .resizable()
//                                .scaledToFill()
//                        )
//
//                    #endif
//                }
//                .buttonStyle(CardButtonStyle())
//        } else {
//            Color.gray
//        }
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
        .focusSection()
    }
}

struct AssetOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AssetOverviewView(assets: [])
    }
}
