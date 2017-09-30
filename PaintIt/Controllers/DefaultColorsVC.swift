//
//  DefaultColors.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class DefaultColorsVC: UIViewController, MainColorsDelegate
{
    @IBOutlet weak var collectionView: MainColorsCollectionView!
    
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setupLayout()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        navBarTitle = NSLocalizedString("_defaultColors", comment: "")
        collectionView.mainColorsDelegate = self
        collectionView.inputDataSource = DefaultColors().colors
    }
    
    func setupLayout()
    {
        collectionView.blurred(style: .dark, alpha: 0.7, cornerRadius: nil, corners: nil)
    }
    
    func showMainController()
    {
        if let _parent = self.parent
        {
            if let container = (_parent as! MainNavigationContainer).mainContainer
            {
                if container.subviews.count > 1
                {
                    (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).lockedModeButton]
                    navBarTitle = NSLocalizedString("_paintIt", comment: "")

                    UIView.animate(withDuration: 0.5, animations: {
                        container.subviews[1].alpha = 0
                    }, completion: { (_) in
                        container.subviews[1].removeFromSuperview()
                    })
                }
            }
        }
    }
    
    /// FUNCTIONS ///
    /////////////////

    
    
    /////////////////
    /// DELEGATES ///
    
    func colorDidSelect()
    {
        showMainController()
    }
    
    /// DELEGATES ///
    /////////////////
    
    
    
    ///////////////
    /// ACTIONS ///


    
    /// ACTIONS ///
    ///////////////


}//end of class
