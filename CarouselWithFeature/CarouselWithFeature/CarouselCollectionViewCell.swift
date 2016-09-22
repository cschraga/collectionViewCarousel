//
//  CarouselCollectionViewCell.swift
//  CarouselWithFeature
//
//  Created by Christian Schraga on 9/22/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    let highlightColor = UIColor.yellow
    let lowlightColor  = UIColor.white
    
    var image: UIImage? {
        get{
           return imageView.image
        }
        set(newImage){
            imageView.image = newImage
        }
    }
    var text: String? {
        get{
            return label.text
        }
        set(newText){
            label.text = newText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 3.0
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        imageView.layer.cornerRadius = 3.0
    }

}
