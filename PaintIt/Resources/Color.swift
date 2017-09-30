//
//  Color.swift
//  RoomPainter
//
//  Created by keisyrzk on 23.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit
import CoreData

struct Color
{
    var name: String?
    var color: UIColor?
    var object: NSManagedObject!
    
    init(name: String, color: UIColor)
    {
        self.name = name
        self.color = color
    }
}
