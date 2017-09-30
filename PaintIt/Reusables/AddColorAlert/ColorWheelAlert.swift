//
//  AddColorAlert.swift
//  RoomPainter
//
//  Created by keisyrzk on 09.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit


protocol ColorWheelDelegate
{
    func colorWheelDidSave()
}

class ColorWheelAlert: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var colorWheel: UIImageView!
    @IBOutlet weak var colorNameTextField: UITextField!
    
    @IBOutlet weak var saveButton: Button3D!
    
    @IBOutlet weak var centerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var centerViewWidth: NSLayoutConstraint!
    
    
    
    
    var colorWheelDelegate: ColorWheelDelegate? = nil
    let panCircle = UIPanGestureRecognizer()            //pan (drag) gesture recognition
    var tempContentInset: CGFloat = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.modalTransitionStyle = .crossDissolve
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setupLayoutForScreenOrientation()
        drawGraphics()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        deregisterFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        setupLayoutForScreenOrientation()
        drawGraphics()
    }
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        colorNameTextField.delegate = self
        colorNameTextField.placeholder = NSLocalizedString("_colorNamePlaceholder", comment: "")
        
        registerForKeyboardNotifications()
        
        centerView.layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation

        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }
    
    func setupLayoutForScreenOrientation()
    {
            //landscape
        if UIApplication.shared.statusBarOrientation != .portrait
        {
            centerViewHeight.constant = UIScreen.main.bounds.height - 80
            centerViewWidth.constant = centerViewHeight.constant * 288/370
        }
        else    //portrait
        {
            centerViewWidth.constant = UIScreen.main.bounds.width * 288/320
            centerViewHeight.constant = UIScreen.main.bounds.height * 370/568
        }
        self.centerView.layoutIfNeeded()
    }

    func drawGraphics()
    {
            //define the circle view frame
        let circleView : UIView = UIView()
        let insideCircleView : UIView = UIView()

        
        circleView.frame = CGRect(x: colorWheel.frame.size.width/2 - 20, y: colorWheel.frame.size.height/2 - 20, width: 40, height: 40)
        circleView.backgroundColor = UIColor.clear
        
        insideCircleView.frame = CGRect(x: 4, y: 4, width: 32, height: 32)
        insideCircleView.backgroundColor = UIColor.clear

        
            //draw a circle in the center of the circleView as a layer
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let insideCirclePath = UIBezierPath(arcCenter: CGPoint(x: 16, y: 16), radius: CGFloat(8), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)

        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 3.0
        
        let insideShapeLayer = CAShapeLayer()
        insideShapeLayer.path = insideCirclePath.cgPath
        insideShapeLayer.fillColor = UIColor.clear.cgColor
        insideShapeLayer.strokeColor = UIColor.lightGray.cgColor
        insideShapeLayer.lineWidth = 3.0
        
        circleView.layer.addSublayer(shapeLayer)
        insideCircleView.layer.addSublayer(insideShapeLayer)
        circleView.addSubview(insideCircleView)

            //pan gesture
        panCircle.addTarget(self, action: #selector(draggedCircle(sender:)))
        circleView.addGestureRecognizer(panCircle)
        circleView.isUserInteractionEnabled = true
        colorWheel.isUserInteractionEnabled = true
        
        colorWheel.addSubview(circleView)
    }
    
    func draggedCircle(sender:UIPanGestureRecognizer)
    {
        colorWheel.bringSubview(toFront: sender.view!)
        let translation = sender.translation(in: colorWheel)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: colorWheel)
        
        centerView.backgroundColor = colorAtPoint(point: (sender.view?.center)!)
    }
    
    func colorAtPoint(point:CGPoint) -> UIColor
    {
        let pixels = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        colorWheel.layer.render(in: context!)
        
        
        let color = UIColor(red: CGFloat(pixels[0])/255.0, green: CGFloat(pixels[1])/255.0, blue: CGFloat(pixels[2])/255.0, alpha: CGFloat(pixels[3])/255.0)
        
        pixels.deallocate(capacity: 4)
        
        return color
    }
    
    
    /// FUNCTIONS ///
    /////////////////
    
    
    ///////////////
    /// ACTIONS ///
    
    @IBAction func saveButtonAction(_ sender: Button3D)
    {
        if sender.buttonState == .Save
        {
            let r = centerView.backgroundColor!.components.red
            let g = centerView.backgroundColor!.components.green
            let b = centerView.backgroundColor!.components.blue
                    
            CoreDataManager.sharedInstance.saveColor(name: colorNameTextField.text!, red: r, green: g, blue: b) { (result) in
                switch result
                {
                case .success(_):
                    colorWheelDelegate?.colorWheelDidSave()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// ACTIONS ///
    ///////////////
    
    
    
    
    /////////////////
    /// DELEGATES ///

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let text = textField.text
        {
            saveButton.turnOn(value: !text.isEmpty)
        }

        self.view.endEditing(true)
        return false
    }
    
    /// DELEGATES ///
    /////////////////
    
    
    ///////////////////////////
    /// KEYBOARD MANAGEMENT ///
    
    func registerForKeyboardNotifications()
    {
            //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications()
    {
            //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
            //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        if let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height
        {
            let contentBottom = self.view.frame.height - centerView.frame.origin.y - centerView.frame.height
        
            if keyboardHeight > contentBottom
            {
                tempContentInset = keyboardHeight - contentBottom
                centerView.frame.origin.y -= tempContentInset
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
            //Once keyboard disappears, restore original positions
        centerView.frame.origin.y += tempContentInset
        tempContentInset = 0
    }
    
    /// KEYBOARD MANAGEMENT ///
    ///////////////////////////



}//end of class
