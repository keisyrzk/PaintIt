//
//  GlobalVars.swift
//  RoomPainter
//
//  Created by keisyrzk on 11.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import CoreData


//////////////////////
/// NAVIGATION BAR ///

    //navigation bar title
var navBarTitle: String = ""
{
    didSet
    {
        if let topController = UIApplication.shared.keyWindow?.rootViewController
        {
            (topController as! MainNavigationContainer).navItem.title = navBarTitle
        }
    }
}

/// NAVIGATION BAR ///
//////////////////////


//////////////
/// COLORS ///

    //currently chosen color
var currentColor: Color? = nil
{
    didSet  //when color set than change the shadow color under the navigation bar
    {
        if let topController = UIApplication.shared.keyWindow?.rootViewController, let color = currentColor?.color
        {
            (topController as! MainNavigationContainer).navBar.layer.shadowColor = color.cgColor
            (topController as! MainNavigationContainer).navBar.layer.shadowColor = color.cgColor
            (topController as! MainNavigationContainer).navBar.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            (topController as! MainNavigationContainer).navBar.layer.shadowRadius = 10.0
            (topController as! MainNavigationContainer).navBar.layer.shadowOpacity = 1.0
        }
    }
}

/// COLORS ///
//////////////


/////////////
/// IMAGE ///

    //currently chosen image
var currentImageObject: NSManagedObject?    //current image core data object
var currentImage: UIImage?                  //current color photo
var currentImageCopy: UIImage?              //current image copy to painting reset possibility
var currentEdgesDetectedImage: UIImage?     //current photo edges detected image (to spread the paint)
var currentEdgesDetectedImageCopy: UIImage? //copy of edged image to show it in adjustments
var currentGalleryImage: UIImage?           //currently selected image in the gallery
var currentScale: CGFloat?                  //current scroll view scale
var currentMinimumScale: CGFloat?           //current scroll view minimum scale

/// IMAGE ///
/////////////


//////////////////////
/// COLORS & IMAGE ///

    //colors/images removal button state
enum RemoveButtonState
{
    case Remove
    case Normal
}

enum LockedButtonState
{
    case Locked
    case Normal
}

var removeButtonState: RemoveButtonState = .Normal
var lockedButtonState: LockedButtonState = .Normal

/// COLORS & IMAGE ///
//////////////////////


////////////////
/// SETTINGS ///

var currentSettings = SettingsModel()     //current settings structure

/// SETTINGS ///
////////////////


