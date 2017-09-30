//
//  UIImageExtension.swift
//  RoomPainter
//
//  Created by keisyrzk on 16.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import UIKit


extension UIImage
{
    func getPixelColor(pos: CGPoint) -> UIColor
    {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    
        //fill area on click
    func fillAreaOfRects(color: UIColor, rects: [CGRect]) -> UIImage
    {
        return modifiedImage { context, rect in
                // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
                // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage!, in: rect)
            
                // tint image (loosing alpha) - the luminosity of the original image is preserved
            if currentSettings.colorFillStyle == false
            {
                    // tint fill
                context.setBlendMode(.color)
            }
            else
            {
                    // solid fill
                context.setBlendMode(.normal)
            }
            color.setFill()
            
            let correctedRects = createCorrectedRects(inputRect: rect, inputRects: rects)
            context.fill(correctedRects)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(context.makeImage()!, in: rect)
        }
    }
    
        //fill brush sized area in real time with pan
    func fillWithBrush(color: UIColor, pointTapped: CGPoint) -> UIImage
    {
        return modifiedImage { context, rect in
                // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
                // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage!, in: rect)
            
                // tint image (loosing alpha) - the luminosity of the original image is preserved
            if currentSettings.colorFillStyle == false
            {
                    // tint fill
                context.setBlendMode(.color)
            }
            else
            {
                    // solid fill
                context.setBlendMode(.normal)
            }
            color.setFill()
            
            let ellipseRect = createBrushEllipseRect(inputRect: rect, pointTapped: pointTapped)
            context.fillEllipse(in: ellipseRect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(context.makeImage()!, in: rect)
        }
    }

        //define the brush area
    fileprivate func createBrushEllipseRect(inputRect: CGRect, pointTapped: CGPoint) -> CGRect
    {
        let brushSize = scaleTheBrush()
        let yPos = Int(inputRect.height) - Int(pointTapped.y) - Int(brushSize/2)
        let newRect = CGRect(x: Int(pointTapped.x) - Int(brushSize/2), y: Int(yPos), width: brushSize, height: brushSize)

        return newRect
    }
    
    fileprivate func scaleTheBrush() -> Int
    {
        if let image = currentEdgesDetectedImage
        {
            if let inputCGImage = image.cgImage
            {
                // brushSize - screenWidth
                //         x - imageWidth
                
                let imageWidth = Int(inputCGImage.width)
                let screenWidth = Int(UIScreen.main.bounds.width)
                
                let scaledBrushSize = (Int(currentSettings.brushSize) * imageWidth) / screenWidth
                
                // scaledBrushSize - currentMinimumScale
                //               x - currentScale
                
                if let _currentScale = currentScale, let _currentMinimumScale = currentMinimumScale
                {
                    let adjustedBrushSize = (CGFloat(scaledBrushSize) * _currentMinimumScale) / _currentScale
                    return Int(adjustedBrushSize)
                }
                else
                {
                    return scaledBrushSize
                }
            }
        }
        return Int(currentSettings.brushSize)
    }
    
        //calculate the area rects (due to different origins)
    fileprivate func createCorrectedRects(inputRect: CGRect, inputRects: [CGRect]) -> [CGRect]
    {
        var newRects: [CGRect] = []

        for input in inputRects
        {
            let x: CGFloat = input.origin.x
            let y: CGFloat = input.origin.y
            let h: CGFloat = input.height
            
            let yPos = inputRect.height - h - y
            let newRect = CGRect(x: Int(x), y: Int(yPos), width: 1, height: Int(h))
            newRects.append(newRect)
        }
        
        return newRects
    }
    
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage
    {
            // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
            // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        currentImage = image!
        
        return image!
    }
}//end of class





