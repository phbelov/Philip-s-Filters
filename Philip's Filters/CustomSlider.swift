//
//  CustomSlider.swift
//  Philip's Filters
//
//  Created by Филипп Белов on 2/25/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import Foundation
import UIKit

class CustomUISlider : UISlider
{
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        //keeps original origin and width, changes height, you get the idea
        //let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width * 0.8, height: 5.0))
        let customBounds = CGRectMake(bounds.origin.x, 13.0, bounds.size.width, 5.0)
        super.trackRectForBounds(customBounds)
        return customBounds
    }
    
    //while we are here, why not change the image here as well? (bonus material)
//    override func awakeFromNib() {
//        self.setThumbImage(UIImage(named: "customThumb"), forState: .Normal)
//        super.awakeFromNib()
//    }
}
