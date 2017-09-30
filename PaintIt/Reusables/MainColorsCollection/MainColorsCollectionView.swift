//
//  MainColorsCollectionView.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

protocol MainColorsDelegate
{
    func colorDidSelect()
}


class MainColorsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var inputDataSource: [Color] = []
    var mainColorsDelegate: MainColorsDelegate? = nil
    
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
        return CGSize(width: self.frame.width * 100/320, height: (self.frame.width * 100/320) * 130/100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        
        cell.config(color: inputDataSource[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch removeButtonState
        {
        case .Normal:
            currentColor = inputDataSource[indexPath.row]
            mainColorsDelegate?.colorDidSelect()
            
        case .Remove:
            CoreDataManager.sharedInstance.delete(object: inputDataSource[indexPath.row].object, completion: { (result) in
                switch result
                {
                case .success(_):
                    inputDataSource.remove(at: indexPath.row)
                    self.reloadData()
                    
                    reloadMyColorsCollectionViews()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            
        }
    }
    
        //get main controller (MainNavigationContainer), loop over it's childs and refetch data in those controllers
    private func reloadMyColorsCollectionViews()
    {
        if let topController = UIApplication.shared.keyWindow?.rootViewController
        {
            for child in (topController as! MainNavigationContainer).childViewControllers
            {
                if child.isKind(of: PaintMain.self)
                {
                    (child as! PaintMain).getData()
                }
                if child.isKind(of: MyColorsVC.self)
                {
                    (child as! MyColorsVC).getData()
                }
            }
        }
    }

}//end of class
