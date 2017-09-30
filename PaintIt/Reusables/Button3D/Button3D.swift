//
//  Button3D.swift
//  RoomPainter
//
//  Created by keisyrzk on 09.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

enum ButtonState
{
    case Save
    case Cancel
}

class Button3D: UIButton
{
    private let frontOnColor =  UIColor(red: 246 / 255.0, green: 193 / 255.0, blue: 87 / 255.0, alpha: 1.0)
    private let backOnColor = UIColor(red: 210 / 255.0, green: 150 / 255.0, blue: 30 / 255.0, alpha: 1.0)
    
    private let frontOffColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    private let backOffColor = UIColor.clear
    
    private let textOnColor = UIColor.white
    private let textOffColor = UIColor.darkGray
    
    private let frontView = UIView()
    private let backView = UIView()
    private let frontTitleLabel = UILabel()
    
    private let space:CGFloat = 4
    
    var buttonState: ButtonState = .Cancel
    
    

    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect)
    {
        drawButton(frame: rect)
    }
    
    func drawButton(frame: CGRect)
    {
        let frontRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - space)
        let backRect = CGRect(x: 0, y: space, width: frame.width, height: frame.height - space)
        
        
        backView.frame = backRect
        backView.backgroundColor = backOffColor
        backView.layer.cornerRadius = 12
        backView.tag = 2
        backView.isUserInteractionEnabled = false
        addSubview(backView)
        
        
        frontTitleLabel.frame = frontRect
        frontTitleLabel.tag = 3
        frontTitleLabel.textAlignment = .center
        frontTitleLabel.adjustsFontSizeToFitWidth = true
        frontTitleLabel.textColor = self.textOffColor
        frontTitleLabel.text = NSLocalizedString("_cancelButton", comment: "")
        frontView.addSubview(frontTitleLabel)
        
        
        frontView.frame = frontRect
        frontView.backgroundColor = frontOffColor
        frontView.layer.cornerRadius = 12
        frontView.tag = 1
        frontView.isUserInteractionEnabled = false
        addSubview(frontView)
    }
    

    func turnOn(value: Bool)
    {
        if let topView = subviews.findElement({ $0.tag == 1 }),
            let backView = subviews.findElement({ $0.tag == 2 }),
            let topViewLabel1 = subviews.findElement({ $0.tag == 1 })
        
        {
            if let topViewLabel = topViewLabel1.subviews.findElement({ $0.tag == 3 }) as? UILabel
            {
                changeViewYToWithAnimateBlock(topView, to: value ? 0 : space, animateBlock:
                    {
                        topView.backgroundColor = value == true ? self.frontOnColor : self.frontOffColor
                        backView.backgroundColor = value == true ? self.backOnColor : self.backOffColor
                        topViewLabel.textColor = value == true ? self.textOnColor : self.textOffColor
                        topViewLabel.text = value == true ? NSLocalizedString("_saveButton", comment: "") : NSLocalizedString("_cancelButton", comment: "")
                        self.buttonState = value == true ? .Save : .Cancel
                })
        
                self.layoutSubviews()
                self.layoutIfNeeded()
            }
        }
    }
    
    
    private func changeViewYToWithAnimateBlock(_ view: UIView, to: CGFloat, animateBlock animate: @escaping () -> Void)
    {
        UIView.animate(withDuration: 0.15, animations: {
            view.frame.origin.y = to
            animate()
        })
    }

}//end of class
