//
//  SideColorsCollectionView.swift
//  RoomPainter
//
//  Created by keisyrzk on 22.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class SideColorsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var inputDataSource: [Color] = []
  
    override func awakeFromNib()
    {
        delegate = self
        dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return inputDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let shorterSize = self.frame.width < self.frame.height ? self.frame.width : self.frame.height
        return CGSize(width: shorterSize - 10, height: shorterSize - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) 
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = inputDataSource[indexPath.row].color

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {        
        if let topController = UIApplication.shared.keyWindow?.rootViewController
        {
            if let colorName = inputDataSource[indexPath.row].name
            {
                (topController as! MainNavigationContainer).view.makeToast(colorName, duration: 1, position: .center)
            }
        }
        currentColor = inputDataSource[indexPath.row]
    }
    
}//end of class
