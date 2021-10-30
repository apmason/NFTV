//
//  AssetOverviewView.swift
//  NFTV
//
//  Created by Alex Mason on 10/26/21.
//

import SwiftUI

private extension AssetView {
    struct WidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

struct CustomCardStyle: ButtonStyle {
    @Environment(\.isFocused) var focused: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(focused ? 1.1 : 1)
            .animation(.easeInOut, value: focused)
    }
}

struct InnerImage: View {
    
    @ObservedObject var asset: OpenSeaAsset
    @Binding var viewWidth: CGFloat?
    
    var body: some View {
        ZStack {
            Image(uiImage: asset.imageWrapper?.image ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(height: viewWidth)
                .cornerRadius(5)
                .background(
                    Color.white
                )
            
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

struct AssetView: View {
    
    @ObservedObject var asset: OpenSeaAsset
    
    @State private var viewWidth: CGFloat?
        
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
            InnerImage(asset: asset, viewWidth: $viewWidth)
                .clipped()
            #endif
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: WidthPreferenceKey.self,
                                       value: geo.size.width)
        })
        .onPreferenceChange(WidthPreferenceKey.self) {
            viewWidth = $0
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
