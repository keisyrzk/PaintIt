//
//  Adjustments.swift
//  RoomPainter
//
//  Created by keisyrzk on 01.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import UIKit


class Adjustments
{
    var parentView: UIView
    
    let tresholdSlider = UISlider()
    let edgeIntensitySlider = UISlider()

    let edgedPreview = UIImageView()
    var isHidden: Bool?
    
    let tresholdSliderMin: Float = 0
    let tresholdSliderMax: Float = 1
    
    let edgeIntensitySliderMin: Float = 1
    let edgeIntensitySliderMax: Float = 10
    
    let stackView = UIStackView()
    let containerView = UIView()
    
    let testLabel = UILabel()
    
    private var edgedPreviewHeight: CGFloat = 100
    private var stackViewHeight: CGFloat = 120
    
    init(parentView: UIView)
    {
        self.parentView = parentView
        edgedPreview.tintColor = UIColor.white
    }
    
    
    func redraw()
    {
        edgedPreviewHeight = parentView.bounds.height - CGFloat(40) - stackViewHeight
        
        containerView.frame = CGRect(x: 16, y: 40 + edgedPreviewHeight, width: parentView.frame.width - 32, height: stackViewHeight)

        parentView.layoutIfNeeded()
    }
    
    
    func showSlider()
    {
        showEdgeIntensitySlider()
        showTresholdSlider()
    }
    
    
    private func showTresholdSlider()
    {
        tresholdSlider.frame = CGRect(x: 0, y: 80, width: containerView.frame.width, height: 40)
        tresholdSlider.minimumValue = tresholdSliderMin
        tresholdSlider.maximumValue = tresholdSliderMax
        tresholdSlider.value = UserDefaultsManager().getTreshold()
        tresholdSlider.minimumTrackTintColor = UIColor.white
        tresholdSlider.isContinuous = false
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: containerView.frame.width, height: 20))
        label.textAlignment = .center
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            label.font = UIFont(name: label.font.fontName, size: 17)
        }
        else
        {
            label.font = UIFont(name: label.font.fontName, size: 12)
        }
        
        label.textColor = UIColor.white
        label.text = NSLocalizedString("_tresholdSliderLabel", comment: "")
        
        containerView.addSubview(tresholdSlider)
        containerView.addSubview(label)
    }
    
    private func showEdgeIntensitySlider()
    {
        edgeIntensitySlider.frame = CGRect(x: 0, y: 20, width: containerView.frame.width, height: 30)
        edgeIntensitySlider.minimumValue = edgeIntensitySliderMin
        edgeIntensitySlider.maximumValue = edgeIntensitySliderMax
        edgeIntensitySlider.value = UserDefaultsManager().getEdgeIntensity()
        edgeIntensitySlider.minimumTrackTintColor = UIColor.white
        edgeIntensitySlider.isContinuous = false
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: 20))
        label.textAlignment = .center
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            label.font = UIFont(name: label.font.fontName, size: 17)
        }
        else
        {
            label.font = UIFont(name: label.font.fontName, size: 12)
        }
        
        label.textColor = UIColor.white
        label.text = NSLocalizedString("_edgesSliderLabel", comment: "")
        
        containerView.addSubview(edgeIntensitySlider)
        containerView.addSubview(label)
    }

    
        //edged preview
    func showPreview()
    {
        edgedPreview.contentMode = .scaleAspectFit
        edgedPreview.frame = CGRect(x: 16, y: 40, width: parentView.frame.width - 32, height: edgedPreviewHeight)
        edgedPreview.image = currentEdgesDetectedImageCopy
        
        parentView.addSubview(edgedPreview)
    }

    
    func showContainerView()
    {
        containerView.tag = 102
        containerView.backgroundColor = UIColor.clear
        
        showSlider()
        
        parentView.addSubview(containerView)
    }

    func showAdjustments()
    {
        redraw()

        self.isHidden = false
        showPreview()
        showContainerView()
    }
    
    func hideAdjustments()
    {
        self.isHidden = true
        for subview in parentView.subviews
        {
            if subview.isKind(of: UIImageView.self)
            {
                subview.removeFromSuperview()
            }
            if subview.isKind(of: UIView.self)
            {
                if subview.tag == 102
                {
                    for subview2 in subview.subviews
                    {
                        subview2.removeFromSuperview()
                    }
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
}//end of class
