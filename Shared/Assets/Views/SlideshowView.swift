//
//  SlideshowView.swift
//  NFTV
//
//  Created by Alex Mason on 11/9/21.
//

import SwiftUI

struct SlideshowView: View {
    
    @ObservedObject var slideshowModel: SlideshowModel
    
    init(assets: [OpenSeaAsset], secondsPerSlide: Int) {
        self._slideshowModel = ObservedObject.init(initialValue: SlideshowModel(assets: assets, secondsPerSlide: secondsPerSlide))
    }
    
    var body: some View {
        FullAssetView(asset: slideshowModel.activeAsset, useSlideshow: true, slideshowModel: slideshowModel)
            .onAppear(perform: {
                self.slideshowModel.beginSlideshow()
            })
            .onDisappear {
                slideshowModel.stop()
            }
    }
}

struct SlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        SlideshowView(assets: [], secondsPerSlide: 6)
    }
}
