//
//  UIColorExtension.swift
//  RoomPainter
//
//  Created by keisyrzk on 10.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

extension UIColor
{
    var coreImageColor: CIColor
    {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}
