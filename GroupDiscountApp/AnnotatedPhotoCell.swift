//
//  PinterestLayout.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    
    var event: Event? {
        didSet {
            if let event = event {
                //imageView.image = event.image!.decompressedImage
                let request = URLRequest(url: event.imageUrl!)
                imageView.setImageWith(
                    request,
                    placeholderImage: nil,
                    success: { (request, response, image) -> Void in
                        
                        // response will be nill if the image is cached
                        if response != nil {
                            //print("Image was NOT cached, fade in image")
                            self.imageView.alpha = 0.0
                            self.imageView.image = image
                            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                self.imageView.alpha = 1.0
                            })
                        } else {
                            //print("Image was cached so just update the image")
                            self.imageView.image = image
                        }
                },
                    failure: { (request, response, image) -> Void in
                })
                captionLabel.text = event.name!
                commentLabel.text = event.comment
            }
        }
    }
    
    override func apply(_ layoutAttributes: (UICollectionViewLayoutAttributes!)) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
