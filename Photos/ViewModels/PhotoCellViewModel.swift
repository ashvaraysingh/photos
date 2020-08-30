//
//  PhotoCellViewModel.swift
//  Photos
//
//  Created by Ashvarya Singh on 30/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import UIKit

class PhotoCellViewModel {
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var authorName: String {
        return photo.author
    }
    
    var heightToWidthRatio: CGFloat {
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        return ratio
    }
    
    var imageUrl: URL? {
        let width = UIScreen.main.bounds.width
        let height = width * heightToWidthRatio
        let imageURL = "https://picsum.photos/id/\(photo.id)/\(Int(width))/\(Int(height))"
        return URL(string: imageURL)
    }
}
