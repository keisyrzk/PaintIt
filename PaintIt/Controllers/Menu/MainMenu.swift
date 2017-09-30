//
//  MainMenu.swift
//  RoomPainter
//
//  Created by keisyrzk on 19.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit

class MainMenu: KeiMainMenu, MainMenuDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: MainMenuTableView!
    
    @IBOutlet weak var logoUpHeightLimit: NSLayoutConstraint!
    @IBOutlet weak var logoDownHeightLimit: NSLayoutConstraint!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setupLayoutForScreenOrientation()

        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        setupLayoutForScreenOrientation()
        MainMenu.shared.redraw()
    }
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        tableView.mainMenuDelegate = self
    }
    
    func setupLayoutForScreenOrientation()
    {
            //landscape
        if UIApplication.shared.statusBarOrientation != .portrait
        {
            logoUpHeightLimit.constant = UIScreen.main.bounds.height/4
            logoDownHeightLimit.constant = UIScreen.main.bounds.height/4
            
        }
        else    //portrait
        {
            logoUpHeightLimit.constant = 200
            logoDownHeightLimit.constant = 150
            
        }
        self.imageView.layoutIfNeeded()
    }
    
    func optionBeenChosen(option: MainMenuOption)
    {
        switch option
        {
        case .PaintIt:
            navBarTitle = NSLocalizedString("_paintIt", comment: "")
            (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).lockedModeButton]
            (self.parent as! MainNavigationContainer).listAlertType = .PaintIt

            showMainController()
            
        case .MyColors:
            (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).removeModeButton]
            (self.parent as! MainNavigationContainer).listAlertType = .MyColors
            
            let nextCtrl = UIStoryboard(name: "Colors", bundle: nil).instantiateViewController(withIdentifier: "MyColorsVC")
            show(controller: nextCtrl)
            
        case .DefaultColors:
            (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = nil
            let nextCtrl = UIStoryboard(name: "Colors", bundle: nil).instantiateViewController(withIdentifier: "DefaultColorsVC")
            show(controller: nextCtrl)
            
        case .Gallery:
            (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).removeModeButton]
            (self.parent as! MainNavigationContainer).listAlertType = .Gallery

            let nextCtrl = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: "Gallery")
            show(controller: nextCtrl)
            
        case .Settings:
            let nextCtrl = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "Settings")
            show(controller: nextCtrl)
        }
    }

    
    
    func show(controller: UIViewController)
    {
        if let _parent = self.parent
        {
            if let container = (_parent as! MainNavigationContainer).mainContainer
            {
                _parent.addChildViewController(controller)
                controller.view.alpha = 0
                container.addSubview(controller.view)
                controller.didMove(toParentViewController: _parent)
                
                UIView.animate(withDuration: 0.5, animations: {
                    controller.view.alpha = 1
                    if container.subviews.count > 2
                    {
                        container.subviews[1].alpha = 0
                    }
                }, completion: { (_) in
                    if container.subviews.count > 2
                    {
                        container.subviews[1].removeFromSuperview()
                    }
                })
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

    
    
    ///////////////
    /// ACTIONS ///
    
    
    /// ACTIONS ///
    ///////////////



}//end of class
