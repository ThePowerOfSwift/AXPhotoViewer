//
//  PhotosConfiguration.swift
//  AXPhotoViewer
//
//  Created by Alex Hill on 6/1/17.
//  Copyright © 2017 Alex Hill. All rights reserved.
//

@objc(AXPhotosDataSource) open class PhotosDataSource: NSObject {
    
    @objc(AXPhotosPrefetchBehavior) public enum PhotosPrefetchBehavior: Int {
        case conservative = 0
        case regular      = 2
        case aggressive   = 4
    }
    
    /// The fetching behavior that the `PhotosViewController` should take action with.
    /// Setting this property to `conservative`, only the current photo will be loaded.
    /// Setting this property to `regular` (default), the current photo, the previous photo, and the next photo will be loaded.
    /// Setting this property to `aggressive`, the current photo, the previous two photos, and the next two photos will be loaded.
    fileprivate(set) var prefetchBehavior: PhotosPrefetchBehavior
    
    /// The photos to display in the PhotosViewController.
    fileprivate var photos: [PhotoProtocol]
    
    // The initial photo index to display upon presentation.
    private(set) var initialPhotoIndex: Int = 0
    
    // MARK: - Initialization
    public init(photos: [PhotoProtocol], initialPhotoIndex: Int, prefetchBehavior: PhotosPrefetchBehavior) {
        self.photos = photos
        self.prefetchBehavior = prefetchBehavior
        
        assert(photos.count > initialPhotoIndex, "Invalid initial photo index provided.")
        self.initialPhotoIndex = initialPhotoIndex
        
        super.init()
    }
    
    public convenience init(photos: [PhotoProtocol]) {
        self.init(photos: photos, initialPhotoIndex: 0, prefetchBehavior: .regular)
    }
    
    public convenience init(photos: [PhotoProtocol], initialPhotoIndex: Int) {
        self.init(photos: photos, initialPhotoIndex: initialPhotoIndex, prefetchBehavior: .regular)
    }
    
    // MARK: - DataSource
    public var numberOfPhotos: Int {
        return self.photos.count
    }
    
    @objc(photoAtIndex:)
    public func photo(at index: Int) -> PhotoProtocol? {
        if index < self.photos.count {
            return self.photos[index]
        }
        
        return nil
    }
    
    func purge(excluding range: CountableClosedRange<Int>?) {
        for (index, photo) in self.photos.enumerated() {
            if range?.contains(index) ?? false {
                continue
            }
            
            photo.imageData = nil
            photo.image = nil
            photo.ax_loadingState = .notLoaded
        }
    }

}
