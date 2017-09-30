//
//  ColorCell.swift
//  RoomPainter
//
//  Created by keisyrzk on 28.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell
{
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellColorView: UIView!

    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.clear
        cellColorView.layer.cornerRadius = 10
        cellColorView.backgroundColor = UIColor.clear
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            cellTitle.font = UIFont(name: cellTitle.font.fontName, size: 20)
        }
        else
        {
            cellTitle.font = UIFont(name: cellTitle.font.fontName, size: 15)
        }
    }
    
    func config(color: Color)
    {
        cellTitle.text = color.name
        cellColorView.backgroundColor = color.color
    }
    
    override func prepareForReuse()
    {
        cellColorView.backgroundColor = UIColor.clear
        cellTitle.text = ""
    }
}
