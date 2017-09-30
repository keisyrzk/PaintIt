//
//  MyColorsVC.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class MyColorsVC: UIViewController, MainColorsDelegate
{
    @IBOutlet weak var collectionView: MainColorsCollectionView!

    
    var myColors = [Color]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
        getData()        
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
        removeButtonState = .Normal
    }

    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        navBarTitle = NSLocalizedString("_myColors", comment: "")
        collectionView.mainColorsDelegate = self
    }
    
    func setupLayout()
    {
        collectionView.blurred(style: .dark, alpha: 0.7, cornerRadius: nil, corners: nil)
    }
    
    func getData()
    {
        CoreDataManager.sharedInstance.fetchColors { (result) in
            switch result
            {
            case .success(let colors):
                self.myColors = colors
                collectionView.inputDataSource = colors
                collectionView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showMainController()
    {
        if let _parent = self.parent
        {
            if let container = (_parent as! MainNavigationContainer).mainContainer
            {
                if container.subviews.count > 1
                {
                    navBarTitle = NSLocalizedString("_paintIt", comment: "")
                    (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).lockedModeButton]
                    (self.parent as! MainNavigationContainer).listAlertType = .PaintIt

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
