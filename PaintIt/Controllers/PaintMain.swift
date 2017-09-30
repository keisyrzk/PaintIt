//
//  PaintMain.swift
//  RoomPainter
//
//  Created by keisyrzk on 19.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit



class PaintMain: UIViewController, UIScrollViewDelegate, MainNavigationContainerDelegate, ImageProcessingDelegate
{
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomUnderlay: UIView!
    
    @IBOutlet weak var leftColorsCollectionView: SideColorsCollectionView!
    @IBOutlet weak var rightColorsCollectionView: SideColorsCollectionView!
    
    @IBOutlet weak var leftCollectionWidth: NSLayoutConstraint!
    @IBOutlet weak var rightCollectionWidth: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    
    
    let paintPanRec = UIPanGestureRecognizer()
    var adjustments: Adjustments?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup()
        doNeccessaryActions()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        redrawLayout()
        
        bottomUnderlay.blurred(style: .dark, alpha: 1, cornerRadius: nil, corners: nil)
        leftColorsCollectionView.blurred(style: .dark, alpha: 0.7, cornerRadius: 10, corners: [.bottomRight, .topRight])
        rightColorsCollectionView.blurred(style: .dark, alpha: 0.7, cornerRadius: 10, corners: [.bottomLeft, .topLeft])
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setPaintingMode()
        (self.parent as! MainNavigationContainer).mainNavigationContainerDelegate = self
        (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = [(self.parent as! MainNavigationContainer).moreButton, (self.parent as! MainNavigationContainer).lockedModeButton]
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews()
    {
        setZoomScale()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        redrawLayout()
    }
    
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        navBarTitle = NSLocalizedString("_paintIt", comment: "")
     
        scrollView.delegate = self
        ImageProcessing.shared.imageProcessingDelegate = self
        
        leftCollectionWidth.constant = self.view.frame.width * 60/320
        rightCollectionWidth.constant = self.view.frame.width * 60/320
        
        leftColorsCollectionView.inputDataSource = DefaultColors().colors
        
        adjustments = Adjustments(parentView: bottomUnderlay)
        bottomBarHeight.constant = scrollView.frame.height
        self.view.bringSubview(toFront: bottomUnderlay)
    }
    
    func redrawLayout()
    {
        self.view.setNeedsDisplay()
        leftColorsCollectionView.setNeedsDisplay()
        rightColorsCollectionView.setNeedsDisplay()
        scrollView.setNeedsDisplay()
        bottomUnderlay.setNeedsDisplay()
        
        bottomUnderlay.frame.size.height = scrollView.frame.height
        adjustments?.hideAdjustments()
    }
    
    func doNeccessaryActions()
    {
        getData()
        proceedImageProcessing(overrideCopy: true)
        setZoomScale()
    }
    
    func setPaintingMode()
    {
            //auto mode
        let paintTapRec = UITapGestureRecognizer()
        paintTapRec.numberOfTapsRequired = 1
        paintTapRec.addTarget(self, action: #selector(paintPointTapped(sender:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(paintTapRec)
        
            //manual mode
        paintPanRec.addTarget(self, action: #selector(paintPointPanned(sender:)))
        mainImageView.isUserInteractionEnabled = true
    }
    

        //get data from CoreData
    func getData()
    {
        CoreDataManager.sharedInstance.fetchColors { (result) in
            switch result
            {
            case .success(let colors):
                rightColorsCollectionView.inputDataSource = colors
                rightColorsCollectionView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
        //proceed with image processing if any selected
    func proceedImageProcessing(overrideCopy: Bool)
    {
        ImageProcessing.shared.prepareForPainting(overrideCopy: overrideCopy) { 
            mainImageView.image = currentImage
            adjustments?.edgedPreview.image = currentEdgesDetectedImage
        }
    }
    
    
    func setZoomScale()
    {
        self.view.layoutIfNeeded()

        let imageViewSize = mainImageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minZoomScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
        currentScale = minZoomScale
        currentMinimumScale = minZoomScale
    }
    
    
    /// FUNCTIONS ///
    /////////////////
    
    
    
    /////////////////
    /// DELEGATES ///

    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return mainImageView
    }
    
        //center the scroll view content
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        let imageViewSize = mainImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func screenDidLock(state: LockedButtonState)
    {
        switch state
        {
        case .Normal:
            scrollView.isScrollEnabled = true
            mainImageView.removeGestureRecognizer(paintPanRec)

        case .Locked:
            scrollView.isScrollEnabled = false
            mainImageView.addGestureRecognizer(paintPanRec)

        }
    }
    
    func currentImageDidReset()
    {
        mainImageView.image = currentImage
    }
    
    func imageProcessingDidEnd()
    {
        mainImageView.image = currentImage
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        currentScale = scale
    }
    
    /// DELEGATES ///
    /////////////////


    
    ///////////////
    /// ACTIONS ///

    @IBAction func leftColorsButtonAction(_ sender: Any)
    {
        leftColorsCollectionView.showOrHide(direction: .Horizontal)
        print("leftColorsCollection:  \(leftColorsCollectionView.frame.size)")
    }
    
    @IBAction func rightColorsButtonAction(_ sender: Any)
    {
        rightColorsCollectionView.showOrHide(direction: .Horizontal)
        print("rightColorsCollection:  \(rightColorsCollectionView.frame.size)")
    }
    
    @IBAction func adjustmentsButtonAction(_ sender: Any)
    {        
        if self.bottomUnderlay.frame.origin.y != 1
        {
            adjustments?.showAdjustments()
            adjustments?.tresholdSlider.addTarget(self, action: #selector(self.tresholdSliderValueDidChange), for: .valueChanged)
            adjustments?.edgeIntensitySlider.addTarget(self, action: #selector(self.edgeIntensitySliderValueDidChange), for: .valueChanged)

            UIView.animate(withDuration: 0.5, animations: {
                self.bottomUnderlay.frame.origin.y = 1
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomUnderlay.frame.origin.y = self.view.frame.height - 30
            }, completion: { (_) in
                self.adjustments?.hideAdjustments()
            })
        }
        
    }
    
    func tresholdSliderValueDidChange(sender: UISlider)
    {
        UserDefaultsManager().saveTreshold(treshold: sender.value)
        proceedImageProcessing(overrideCopy: false)
    }
    
    func edgeIntensitySliderValueDidChange(sender: UISlider)
    {
        UserDefaultsManager().saveEdgeIntensity(intensity: sender.value)
        proceedImageProcessing(overrideCopy: false)
    }
    
        //auto painting mode - tap & spread the paint
    func paintPointTapped(sender: UITapGestureRecognizer)
    {
        let pointTapped = sender.location(in: mainImageView)

        if let _currentColor = currentColor, let _color = _currentColor.color
        {
            if let rects = ImageProcessing.shared.processPixels(start: pointTapped, isShaderingKept: true), let _currentImage = currentImage
            {
                mainImageView.image = _currentImage.fillAreaOfRects(color: _color, rects: rects)
            }
        }
    }
    
        //manual painting mode - pan & paint
    func paintPointPanned(sender: UIPanGestureRecognizer)
    {
        let point = sender.location(in: mainImageView)
        if let _currentColor = currentColor
        {
            if let _color = _currentColor.color
            {
                mainImageView.image = currentImage?.fillWithBrush(color: _color, pointTapped: point)
            }
        }
    }
    
    /// ACTIONS ///
    ///////////////

    
}//end of class

