/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Image cache.
*/

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public class ImageCache {
    
    public static let publicCache = ImageCache()
    private let cachedImages = NSCache<NSURL, ImageWrapper>()
    private var loadingResponses = [NSURL: [(OpenSeaAsset, ImageWrapper?) -> Swift.Void]]()
    
    private init() {}
    
    public final func image(url: NSURL) -> ImageWrapper? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, item: OpenSeaAsset, completion: @escaping (OpenSeaAsset, ImageWrapper?) -> Swift.Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        print("ENTRANCE")
        // Go fetch the image.
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            print("RESPONSE")
            // Check for the error, then data and try to create the image.
            guard let responseData = data else {
                return
            }
            
            #if os(macOS)
            guard let image = NSImage(data: responseData) else {
                return
            }
            let imageWrapper = ImageWrapper(image: image)
            #else
            guard let image = UIImage(data: responseData) else {
                return
            }
            let imageWrapper = ImageWrapper(image: image)
            #endif
            
            
            guard let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(item, nil)
                }
                return
            }
            
            // Cache the image.
            self.cachedImages.setObject(imageWrapper, forKey: url, cost: responseData.count)
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                DispatchQueue.main.async {
                    block(item, imageWrapper)
                }
            }
        }.resume()
    }
}
