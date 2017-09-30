//
//  MainMenuTableViewCell.swift
//  RoomPainter
//
//  Created by keisyrzk on 19.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell
{
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellImageHeight: NSLayoutConstraint!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = 8
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            cellTitle.font = UIFont(name: cellTitle.font.fontName, size: 30)
            cellImageHeight.constant = 50
        }
        else
        {
            cellTitle.font = UIFont(name: cellTitle.font.fontName, size: 15)
            cellImageHeight.constant = 25
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(title: String, icon: UIImage)
    {
        iconImageView.image = icon
        cellTitle.text = title
    }
    

}//end of class
