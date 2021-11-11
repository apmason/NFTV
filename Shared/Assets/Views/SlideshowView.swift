//
//  SlideshowView.swift
//  NFTV
//
//  Created by Alex Mason on 11/9/21.
//

import SwiftUI

struct SlideshowView: View {
    
    @ObservedObject var model: SlideshowModel = OpenSeaModel.shared.slideshowModel
    
    var body: some View {
        FullAssetView(asset: model.activeAsset, useSlideshow: true, slideshowModel: model)
            .onAppear(perform: {
                model.beginSlideshow()
            })
            .onDisappear {
                model.stop()
            }
    }
}

struct SlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowView()
    }
}
