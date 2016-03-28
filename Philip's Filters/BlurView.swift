//
//  BlurView.swift
//  Philip's Filters
//
//  Created by Филипп Белов on 2/24/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBlur (blurEffectStyle : UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurView, atIndex: 0)
        let blurViewConstraintHeight = NSLayoutConstraint(item: blurView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let blurViewConstraintWidth = NSLayoutConstraint(item: blurView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let blurViewConstraintBottom = NSLayoutConstraint(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        if let sView = self.superview {
            sView.addConstraints([blurViewConstraintHeight, blurViewConstraintWidth, blurViewConstraintBottom])
        } else {
            NSLayoutConstraint.activateConstraints([blurViewConstraintHeight, blurViewConstraintWidth, blurViewConstraintBottom])
        }

    }
}
