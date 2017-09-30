//
//  MainMenuTableView.swift
//  RoomPainter
//
//  Created by keisyrzk on 19.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

protocol MainMenuDelegate
{
    func optionBeenChosen(option: MainMenuOption)
}

enum MainMenuOption
{
    case PaintIt
    case MyColors
    case DefaultColors
    case Gallery
    case Settings
}

class MainMenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var inputDataSource: [String] = [NSLocalizedString("_paintIt", comment: ""),
                                     NSLocalizedString("_myColors", comment: ""),
                                     NSLocalizedString("_defaultColors", comment: ""),
                                     NSLocalizedString("_gallery", comment: ""),
                                     NSLocalizedString("_settings", comment: "")]
    let menuIcons: [UIImage] = [#imageLiteral(resourceName: "paintitIcon"),
                                #imageLiteral(resourceName: "rightColors"),
                                #imageLiteral(resourceName: "leftColors"),
                                #imageLiteral(resourceName: "galleryIcon"),
                                #imageLiteral(resourceName: "settingsIcon")]
    
    var mainMenuDelegate: MainMenuDelegate?
    
    override func awakeFromNib()
    {
        delegate = self
        dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return 100
        }
        else
        {
            return 50
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return inputDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MainMenuTableViewCell
        
        cell.config(title: inputDataSource[indexPath.row], icon: menuIcons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        MainMenu.shared.hide()
        
        switch indexPath.row
        {
        case 0:
            mainMenuDelegate?.optionBeenChosen(option: .PaintIt)
        case 1:
            mainMenuDelegate?.optionBeenChosen(option: .MyColors)
        case 2:
            mainMenuDelegate?.optionBeenChosen(option: .DefaultColors)
        case 3:
            mainMenuDelegate?.optionBeenChosen(option: .Gallery)
        case 4:
            mainMenuDelegate?.optionBeenChosen(option: .Settings)
        default:
            print("")
        }
    }
    

}//end of class
