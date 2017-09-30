//
//  UISwitchExtension.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch
{
    func onlyBorder(color: UIColor)
    {
        self.onTintColor = UIColor.clear
        self.tintColor = UIColor.clear
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 16
    }
}
