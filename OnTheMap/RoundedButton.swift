//
//  RoundedButton.swift
//  OnTheMap
//
//  Created by CarlJohan on 04/04/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    private func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = 4
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        contentEdgeInsets = UIEdgeInsetsMake(3, 13, 3, 13)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    
}
