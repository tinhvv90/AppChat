//
//  Color.swift
//  AppChat
//
//  Created by CenHomes on 5/18/19.
//  Copyright © 2019 Simson. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
}
