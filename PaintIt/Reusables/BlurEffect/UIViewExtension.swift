//
//  UIViewExtensionBlurEffect.swift
//  RoomPainter
//
//  Created by keisyrzk on 21.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import Foundation
import UIKit


    //a private associated variables to make a new attributes for UIView

    //wheter the view is currently showed or hidden
private var isShowedOrHidden: Bool = false

extension UIView
{
    enum AnimationDirection
    {
        case Vertical
        case Horizontal
    }
    
        //new UIView's attribute definition via associated object
    var isShowed : Bool {
        get
        {
            return objc_getAssociatedObject(self, &isShowedOrHidden) as! Bool
        }
        
        set(value)
        {
           objc_setAssociatedObject(self, &isShowedOrHidden, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override open func awakeFromNib()
    {
        isShowed = false
    }
    

    func blurred(style: UIBlurEffectStyle, alpha: CGFloat, cornerRadius: CGFloat?, corners: UIRectCorner?)
    {
        self.backgroundColor = UIColor.clear
        
        let blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = alpha

        if let _radius = cornerRadius, let _corners = corners
        {
            let path = UIBezierPath(roundedRect:blurEffectView.bounds,
                                byRoundingCorners: _corners,
                                cornerRadii: CGSize(width: _radius, height:  _radius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            blurEffectView.layer.mask = maskLayer
        }
        
        blurEffectView.clipsToBounds = true
        self.clipsToBounds = true
        
            //if 'self' is a UIColectionView or UITableView the blurEffectView would cover the cells so it should change the view's 'backgroundView' instead
        
        if self.isKind(of: UICollectionView.self)
        {
            (self as! UICollectionView).backgroundView = blurEffectView
        }
        else if self.isKind(of: UITableView.self)
        {
            (self as! UITableView).backgroundView = blurEffectView
        }
        else
        {
            self.addSubview(blurEffectView)
            self.sendSubview(toBack: blurEffectView)
        }        
    }
    
    func showOrHide(direction: AnimationDirection)
    {
            //view's edges
        let viewLeftEdge = self.frame.origin.x
        let viewRightEdge = self.frame.origin.x + self.frame.width
        let viewTopEdge = self.frame.origin.y
        let viewBottomEdge = self.frame.origin.y + self.frame.height
        
            //view parent's edges
        let parentRightEdge = self.superview!.frame.width
        let parentBottomEdge = self.superview!.frame.height
        
        
            //calculate the closest edge
        let leftSpace = viewLeftEdge
        let rightSpace = parentRightEdge - viewRightEdge
        let topSpace = viewTopEdge
        let bottomSpace = parentBottomEdge - viewBottomEdge
        
        
            //animate
        if direction == .Horizontal
        {
            if leftSpace < rightSpace
            {
                    //animate to the left side
                let newPosition = leftSpace < 0 ? abs(leftSpace + self.frame.width) : -(leftSpace + self.frame.width)
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame.origin.x = newPosition
                })
            }
            else
            {
                    //animate to the right side
                let newPosition = rightSpace < 0 ? parentRightEdge + rightSpace : parentRightEdge + rightSpace
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame.origin.x = newPosition
                })
            }
        }
        else
        {
            if topSpace < bottomSpace
            {
                    //animate to the top side
                let newPosition = topSpace < 0 ? abs(topSpace + self.frame.height) : -(topSpace + self.frame.height)
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame.origin.y = newPosition
                })
            }
            else
            {
                    //animate to the bottom side
                let newPosition = bottomSpace < 0 ? parentBottomEdge + bottomSpace : parentBottomEdge + bottomSpace
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame.origin.y = newPosition
                })
            }
        }
        
            //if self is out of it's superview's frame - it is hidden, otherwise it is showed
        if self.superview?.frame.contains(self.frame) == true
        {
            self.isShowed = true
        }
        else
        {
            self.isShowed = false
        }
    }//end of showOrHide
    

    
}
