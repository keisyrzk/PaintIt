//
//  MainMenu.swift
//  RoomPainter
//
//  Created by keisyrzk on 19.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit



class KeiMainMenu: UIViewController
{
    ////////////////////////
    // CREATE A SINGLETON //
    
    class var shared: KeiMainMenu
    {
        struct Singleton
        {
            static let instance = KeiMainMenu()
        }
        return Singleton.instance
    }
    
    // CREATE A SINGLETON //
    ////////////////////////

    
    
    private let blurEffectView = UIVisualEffectView()
    private var currentParentCtrl: UIViewController?
    private let animationDuration: Double = 0.5
    private let blurMaxAlpha: CGFloat = 0.7
    
    var MainMenuCtrl = UIViewController()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redraw()
    {
        if let parentCtrl = self.currentParentCtrl
        {
            //hide without animation
            if let _parentCtrl = self.currentParentCtrl
            {
                for subview in _parentCtrl.view.subviews
                {
                    if subview.isKind(of: UIVisualEffectView.self)
                    {
                        subview.removeFromSuperview()
                        
                        self.MainMenuCtrl.willMove(toParentViewController: nil)
                        self.MainMenuCtrl.view.removeFromSuperview()
                        self.MainMenuCtrl.removeFromParentViewController()
                    }
                }
            }
            
            //show without animation
            //cache teh current parent controller
            currentParentCtrl = parentCtrl
            
            //add pan gesture recognizer
            let panRec = UIPanGestureRecognizer()
            panRec.addTarget(self, action:  #selector(self.menuDragged(sender:)))
            MainMenuCtrl.view.addGestureRecognizer(panRec)
            
            //add a blurr effect to parrent controller's view
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurEffectView.effect = blurEffect
            blurEffectView.frame = parentCtrl.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            blurEffectView.alpha = blurMaxAlpha
            
            let tapRec = UITapGestureRecognizer()
            tapRec.numberOfTapsRequired = 1
            tapRec.addTarget(self, action: #selector(blurredViewTapped(sender:)))
            blurEffectView.addGestureRecognizer(tapRec)
            
            
            //set the menu's width and add it to parent controller's view
            let shorterSide = parentCtrl.view.frame.width < parentCtrl.view.frame.height ? parentCtrl.view.frame.width : parentCtrl.view.frame.height
            let newWidth = shorterSide * 0.7
            let newSize = CGSize(width: newWidth, height: parentCtrl.view.frame.height)
            
            
            MainMenuCtrl.view.frame.size = newSize
            MainMenuCtrl.view.frame.origin.x = 0
            
            
            parentCtrl.view.addSubview(blurEffectView)
            parentCtrl.addChildViewController(MainMenuCtrl)
            parentCtrl.view.addSubview(MainMenuCtrl.view)
            MainMenuCtrl.didMove(toParentViewController: parentCtrl)
        }
        
    }
    
    func show(parentCtrl: UIViewController, menuWidth: CGFloat?)
    {
            //cache teh current parent controller
        currentParentCtrl = parentCtrl
        
            //add pan gesture recognizer
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action:  #selector(self.menuDragged(sender:)))
        MainMenuCtrl.view.addGestureRecognizer(panRec)
        
            //add a blurr effect to parrent controller's view
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = parentCtrl.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0
        
        let tapRec = UITapGestureRecognizer()
        tapRec.numberOfTapsRequired = 1
        tapRec.addTarget(self, action: #selector(blurredViewTapped(sender:)))
        blurEffectView.addGestureRecognizer(tapRec)
        
        
            //set the menu's width and add it to parent controller's view
        let shorterSide = parentCtrl.view.frame.width < parentCtrl.view.frame.height ? parentCtrl.view.frame.width : parentCtrl.view.frame.height
        let newWidth = menuWidth != nil ? menuWidth! : shorterSide * 0.7
        let newSize = CGSize(width: newWidth, height: parentCtrl.view.frame.height)

        
        MainMenuCtrl.view.frame.size = newSize
        MainMenuCtrl.view.frame.origin.x = -MainMenuCtrl.view.frame.size.width
        
        
        parentCtrl.view.addSubview(blurEffectView)
        parentCtrl.addChildViewController(MainMenuCtrl)
        parentCtrl.view.addSubview(MainMenuCtrl.view)
        MainMenuCtrl.didMove(toParentViewController: parentCtrl)
        

            //show with animation
        UIView.animate(withDuration: animationDuration, animations: {
            self.MainMenuCtrl.view.frame.origin.x = 0
            self.blurEffectView.alpha = self.blurMaxAlpha
        })
        
    }//end of show
    
    
    func hide()
    {
        let currentWidth = MainMenuCtrl.view.frame.width
        
            //hide menu with animation and completion
        UIView.animate(withDuration: animationDuration, animations: {
            self.MainMenuCtrl.view.frame.origin.x = -currentWidth
            self.blurEffectView.alpha = 0
        }) { (_) in
                //when finished - remove the blurr efect from parent controller's view
            if let _parentCtrl = self.currentParentCtrl
            {
                for subview in _parentCtrl.view.subviews
                {
                    if subview.isKind(of: UIVisualEffectView.self)
                    {
                        subview.removeFromSuperview()
                        
                        self.MainMenuCtrl.willMove(toParentViewController: nil)
                        self.MainMenuCtrl.view.removeFromSuperview()
                        self.MainMenuCtrl.removeFromParentViewController()
                    }
                }
            }
        }
    }//end of hide
    
    
    
    
    @objc private func blurredViewTapped(sender: UITapGestureRecognizer)
    {
        if sender.location(in: blurEffectView).x > MainMenuCtrl.view.frame.width
        {
            hide()
        }
    }
    
    @objc private func menuDragged(sender: UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: self.MainMenuCtrl.view)
        
        if translation.x < 0
        {
            self.MainMenuCtrl.view.frame.origin.x = translation.x
            self.blurEffectView.alpha = self.blurMaxAlpha + self.blurMaxAlpha * translation.x/self.MainMenuCtrl.view.frame.width
            
            if sender.state == .ended
            {
                if translation.x < -self.MainMenuCtrl.view.frame.width * 0.5
                {
                    hideWithPan(translation: translation.x)
                }
                else
                {
                    showWithPan()
                }
            }
        }
    }
    
    
    private func hideWithPan(translation: CGFloat)
    {
        UIView.animate(withDuration: animationDuration, animations: {
            self.MainMenuCtrl.view.frame.origin.x = -self.MainMenuCtrl.view.frame.width + translation
            self.blurEffectView.alpha = 0
        }) { (_) in
                //when finished - remove the blurr efect from parent controller's view
            if let _parentCtrl = self.currentParentCtrl
            {
                for subview in _parentCtrl.view.subviews
                {
                    if subview.isKind(of: UIVisualEffectView.self)
                    {
                        subview.removeFromSuperview()
                        
                        self.MainMenuCtrl.willMove(toParentViewController: nil)
                        self.MainMenuCtrl.view.removeFromSuperview()
                        self.MainMenuCtrl.removeFromParentViewController()
                    }
                }
            }
        }
    }
    
    private func showWithPan()
    {
        UIView.animate(withDuration: animationDuration, animations: {
            self.MainMenuCtrl.view.frame.origin.x = 0
            self.blurEffectView.alpha = self.blurMaxAlpha
        })
    }

}//end of class
