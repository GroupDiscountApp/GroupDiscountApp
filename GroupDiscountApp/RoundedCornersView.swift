//
//  RoundedCornersView.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
