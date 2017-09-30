//
//  ListAlertCell.swift
//  RoomPainter
//
//  Created by keisyrzk on 30.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

class ListAlertCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!

    
    func setCellTitle(cellTitle: String)
    {
        self.selectionStyle = .none
        backgroundColor = UIColor.clear
        titleLabel.text = cellTitle
        titleLabel.textColor = UIColor.darkGray
    }
}
