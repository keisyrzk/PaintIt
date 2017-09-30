//
//  UserDefaultsManager.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsManager
{
    //////////////////
    /// PAINT MAIN ///
    
    func saveTreshold(treshold: Float)
    {
        UserDefaults.standard.set(treshold, forKey: "treshold")
    }
    
    func getTreshold() -> Float
    {
        if let treshold = UserDefaults.standard.value(forKey: "treshold")
        {
            return treshold as! Float
        }
        else
        {
            return 0.1
        }
    }
    
    func saveEdgeIntensity(intensity: Float)
    {
        UserDefaults.standard.set(intensity, forKey: "edgeIntensity")
    }
    
    func getEdgeIntensity() -> Float
    {
        if let edgeIntensity = UserDefaults.standard.value(forKey: "edgeIntensity")
        {
            return edgeIntensity as! Float
        }
        else
        {
            return 2
        }
    }
    
    func cacheCurrentImage()
    {
        if let _currentImage = currentImage
        {
            if let imageData = UIImageJPEGRepresentation(_currentImage, 1)
            {
                UserDefaults.standard.set(imageData, forKey: "cachedCurrentImage")
            }
        }
    }
    
    func getCachedCurrentImage() -> UIImage?
    {
        if let imageData = UserDefaults.standard.data(forKey: "cachedCurrentImage")
        {
            if let image = UIImage(data: imageData)
            {
                return image
            }
        }
        return nil
    }
    
    /// PAINT MAIN ///
    //////////////////

    
    
    ////////////////
    /// SETTINGS ///
    
    func saveSettings(brushSize: Float,
                      colorFillStyle: Bool)
    {
        let ud = UserDefaults.standard
        
        ud.set(brushSize, forKey: "brushSize")
        ud.set(colorFillStyle, forKey: "colorFillStyle")
        
        fetchSettings()
    }
    
    func fetchSettings()
    {
        let ud = UserDefaults.standard
        let settingsModel = SettingsModel()
        
        settingsModel.brushSize = ud.float(forKey: "brushSize")
        settingsModel.colorFillStyle = ud.bool(forKey: "colorFillStyle")
        
        currentSettings = settingsModel
    }
    
    /// SETTINGS ///
    ////////////////
}//end of class


