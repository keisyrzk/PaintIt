//
//  Gallery.swift
//  RoomPainter
//
//  Created by keisyrzk on 30.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import iCarousel
import CoreData
import SwiftSpinner

class Gallery: UIViewController, iCarouselDelegate, iCarouselDataSource
{
    @IBOutlet weak var carousel: iCarousel!

    
    var photos = [NSManagedObject]()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
        getData()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        navBarTitle = NSLocalizedString("_gallery", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        removeButtonState = .Normal
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.view.setNeedsDisplay()
        carousel.setNeedsDisplay()
    }
    
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .rotary
        carousel.isPagingEnabled = true
    }
    
    func setupLayout()
    {
        self.view.blurred(style: .dark, alpha: 0.7, cornerRadius: nil, corners: nil)
    }
    
    func getData()
    {
        CoreDataManager.sharedInstance.fetchImages(completion: { (result) in
            switch result
            {
            case .success(let images):

                photos = images
                carousel.reloadData()
                
                if let _first = photos.first
                {
                    currentGalleryImage = CoreDataManager.sharedInstance.objectToUIImage(object: _first)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
                    (self.parent as! MainNavigationContainer).listAlertType = .PaintIt

                    navBarTitle = NSLocalizedString("_paintIt", comment: "")
                    
                    for child in (self.parent as! MainNavigationContainer).childViewControllers
                    {
                        if child.isKind(of: PaintMain.self)
                        {
                            SwiftSpinner.show(NSLocalizedString("_processing", comment: ""))
                            DispatchQueue.main.async(execute: {
                                (child as! PaintMain).doNeccessaryActions()
                            })
                        }
                    }
 
                    UIView.animate(withDuration: 0.5, animations: {
                        container.subviews[1].alpha = 0
                    }, completion: { (_) in
                        SwiftSpinner.hide()
                        container.subviews[1].removeFromSuperview()
                    })
                }
            }
        }
    }
    
    /// FUNCTIONS ///
    /////////////////
    
    
    
    ////////////////
    /// CAROUSEL ///
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return photos.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        let shorterSide = carousel.frame.width < carousel.frame.height ? carousel.frame.width : carousel.frame.height
        let frame = CGRect(x: 0,
                           y: 0,
                           width: shorterSide * 0.8,
                           height: shorterSide * 0.8)
        let carouselImageView = UIImageView(frame: frame)
        carouselImageView.contentMode = .scaleAspectFit
        carouselImageView.image = CoreDataManager.sharedInstance.objectToUIImage(object: photos[index])
        
        return carouselImageView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if option == .spacing
        {
            return 1.2
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int)
    {
        if removeButtonState == .Remove
        {
            CoreDataManager.sharedInstance.delete(object: photos[index], completion: { (result) in
                switch result
                {
                case .success(_):
                    self.photos.remove(at: index)
                    self.carousel.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        else
        {
            currentImage = CoreDataManager.sharedInstance.objectToUIImage(object: photos[index])
            currentImageObject = self.photos[index]
            showMainController()
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel)
    {
        if carousel.currentItemIndex < photos.count && photos.count > 0
        {
            currentGalleryImage = CoreDataManager.sharedInstance.objectToUIImage(object: photos[carousel.currentItemIndex])
        }
    }
    
    /// CAROUSEL ///
    ////////////////

    

}//end of class
