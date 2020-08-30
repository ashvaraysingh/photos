//
//  PhotoCell.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      containerView.layer.cornerRadius = 6
      containerView.layer.masksToBounds = true
    }
        
    func configureCell(cellViewModel: PhotoCellViewModel) {
        
//        let width = Int(UIScreen.main.bounds.width)
//        let height = width * photo.height / photo.width
//        let imageURL = "https://picsum.photos/" + "\(width)/\(height)?image=\(photo.id)"
        //Created image url from height and width of image
   //     Log.info(imageURL)
        imageView.sd_setImage(with: cellViewModel.imageUrl, placeholderImage: UIImage(named: "placeholder"))
        authorLabel.text = cellViewModel.authorName
    }
}
