//
//  ImageProcessing.swift
//  RoomPainter
//
//  Created by keisyrzk on 13.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

enum Direction
{
    case Up
    case Down
    case Left
    case Right
}

protocol ImageProcessingDelegate
{
    func imageProcessingDidEnd()
}

class ImageProcessing
{
    ////////////////////////
    // CREATE A SINGLETON //
    
    class var shared: ImageProcessing
    {
        struct Singleton
        {
            static let instance = ImageProcessing()
        }
        return Singleton.instance
    }
    
    // CREATE A SINGLETON //
    ////////////////////////
    
    
    var imageProcessingDelegate: ImageProcessingDelegate? = nil
    
    
    
    /////////////////
    /// FUNCTIONS ///
    
    func prepareForPainting(overrideCopy: Bool ,completion: () -> Void)
    {
        if let image = currentImage
        {
            imageProcessing(image: image, overrideCopy: overrideCopy)
        }
        else
        {
            imageProcessing(image: #imageLiteral(resourceName: "roomPattern"), overrideCopy: overrideCopy)
        }
        
        completion()
    }
    
    
    private func imageProcessing(image: UIImage, overrideCopy: Bool)
    {
        currentImage = image
        
        if overrideCopy == true
        {
            currentImageCopy = image
        }
        
        let ciContext = CIContext(options: nil)
        let imgOrientation = image.imageOrientation
        let coreImage = CIImage(image: image)
        if let filter = CIFilter(name: "CILineOverlay")
        {
            filter.setDefaults()
            let treshold = UserDefaultsManager().getTreshold()
            let edgeIntensity = UserDefaultsManager().getEdgeIntensity()
            
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            filter.setValue(edgeIntensity, forKey: "inputEdgeIntensity")
            filter.setValue(treshold, forKey: "inputThreshold")

            
            let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage
            if let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            {
                let filteredImage =  UIImage(cgImage: filteredImageRef, scale: 1, orientation: imgOrientation).withRenderingMode(.alwaysTemplate)

                currentEdgesDetectedImage = filteredImage
                currentEdgesDetectedImageCopy = filteredImage
            }
        }
    }
    
    
    
    
    
    
    
    

    
    func processPixels(start: CGPoint, isShaderingKept: Bool) -> [CGRect]?
    {
        guard let colorImage = currentImage else {
            return nil
        }
        guard let colorInputCGImage = colorImage.cgImage else {
            return nil
        }
        
        guard let image = currentEdgesDetectedImage else {
            return nil
        }
        guard let inputCGImage = image.cgImage else {
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        
        
            //color image
        guard let colorContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        colorContext.draw(colorInputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let colorBuffer = colorContext.data else {
            return nil
        }
        
        let colorPixelBuffer = colorBuffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        
            //edges image
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

                
        guard let curColor = currentColor else {
            return nil
        }
        
        var rects: [CGRect] = []

        if let _color = curColor.color
        {
            let r = UInt8(_color.components.red * 255)
            let g = UInt8(_color.components.green * 255)
            let b = UInt8(_color.components.blue * 255)
            let a = UInt8(_color.components.alpha * 255)
            
            let color = RGBA32(red: r, green: g, blue: b, alpha: a)
            let blackRGBA = RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
            
            
            
            ////////////////////
            /// NEW APPROACH ///
            
            var tmpPoints: [CGPoint] = []       //temporarly remembered points left/right from tapped point
            var outputRects: [CGRect] = []
            
            var upCount: Int = 0
            var downCount: Int = 0

                //spread pixels horizontally (left,right) from tapped point to black or current color and remember them
            func collectHorizontalPixels(point: CGPoint, offset: Int) -> CGPoint?
            {
                let pixelColor = pixelBuffer[offset]
                    
                    //if the pixel's color is not the black (tresholded) and 'color' then proceed
                if pixelColor != blackRGBA //&& pixelColor != color
                {
                    pixelBuffer[offset] = color
                    return point
                }
                return nil
            }
            
            
                //check and collect points to the left from the tapped point
            func goLeft(point: CGPoint, offset: Int, completion: (([CGPoint]) -> Void)?)
            {
                if offset > 0 && offset < width * height
                {
                    if let horizontalPoint = collectHorizontalPixels(point: point, offset: offset)
                    {
                        tmpPoints.append(horizontalPoint)
                        let nextLeft = CGPoint(x: Int(horizontalPoint.x - 1), y: Int(horizontalPoint.y))
                        let nextOffset = Int(nextLeft.y) * width + Int(nextLeft.x)
                        goLeft(point: nextLeft, offset: nextOffset, completion: nil)
                    }
                    completion?(tmpPoints)
                }
                completion?(tmpPoints)
            }
            
                //check and collect points to the right from the tapped point
            func goRight(point: CGPoint, offset: Int, completion: (([CGPoint]) -> Void)?)
            {
                if offset > 0 && offset < width * height
                {
                    if let horizontalPoint = collectHorizontalPixels(point: point, offset: offset)
                    {
                        tmpPoints.append(horizontalPoint)
                        let nextRight = CGPoint(x: Int(horizontalPoint.x + 1), y: Int(horizontalPoint.y))
                        let nextOffset = Int(nextRight.y) * width + Int(nextRight.x)
                        goRight(point: nextRight, offset: nextOffset, completion: nil)
                    }
                    completion?(tmpPoints)
                }
                completion?(tmpPoints)
            }
            
            
            
            func goUp(point: CGPoint, offset: Int, completion: ((Int) -> Void)?)
            {
                if offset > 0 && offset < width * height
                {
                    let pixelColor = pixelBuffer[offset]
                    
                        //if the pixel's color is not the black (tresholded) and 'color' then proceed
                    if pixelColor != blackRGBA //&& pixelColor != color
                    {
                        pixelBuffer[offset] = color
                        upCount += 1
                        let nextUp = CGPoint(x: Int(point.x), y: Int(point.y - 1))
                        let nextOffset = Int(nextUp.y) * width + Int(nextUp.x)
                        goUp(point: nextUp, offset: nextOffset, completion: nil)
                    }
                    completion?(upCount)
                }
            }
            
            func goDown(point: CGPoint, offset: Int, completion: ((Int) -> Void)?)
            {
                if offset > 0 && offset < width * height
                {
                    let pixelColor = pixelBuffer[offset]
                    
                    //if the pixel's color is not the black (tresholded) and 'color' then proceed
                    if pixelColor != blackRGBA //&& pixelColor != color
                    {
                        pixelBuffer[offset] = color
                        downCount += 1
                        let nextUp = CGPoint(x: Int(point.x), y: Int(point.y + 1))
                        let nextOffset = Int(nextUp.y) * width + Int(nextUp.x)
                        goDown(point: nextUp, offset: nextOffset, completion: nil)
                    }
                    completion?(downCount)
                }
            }
            
            
            
            func createVerticalRects(start: CGPoint) -> [CGRect]
            {
                var verticalRects: [CGRect] = []
                
                let firstLeft = CGPoint(x: Int(start.x - 1), y: Int(start.y))
                let leftOffset = Int(firstLeft.y) * width + Int(firstLeft.x)
                goLeft(point: firstLeft, offset: leftOffset, completion: { (leftPoints) in
                    tmpPoints = []
                    
                    for point in leftPoints
                    {
                        let firstUp = CGPoint(x: Int(point.x), y: Int(point.y - 1))
                        let upOffset = Int(firstUp.y) * width + Int(firstUp.x)
                        goUp(point: firstUp, offset: upOffset, completion: { (upHeight) in
                            
                            upCount = 0
                            let firstDown = CGPoint(x: Int(point.x), y: Int(point.y + 1))
                            let downOffset = Int(firstDown.y) * width + Int(firstDown.x)
                            goDown(point: firstDown, offset: Int(downOffset), completion: { (downHeight) in
                                
                                downCount = 0
                                let rect = CGRect(x: Int(point.x), y: Int(point.y) - upHeight, width: 1, height: upHeight + downHeight + 1)
                                verticalRects.append(rect)
                            })
                        })
                    }
                })
                
                let rightOffset = Int(start.y) * width + Int(start.x)
                goRight(point: start, offset: rightOffset, completion: { (rightPoints) in
                    tmpPoints = []
                    
                    for point in rightPoints
                    {
                        let firstUp = CGPoint(x: Int(point.x), y: Int(point.y - 1))
                        let upOffset = Int(firstUp.y) * width + Int(firstUp.x)
                        goUp(point: firstUp, offset: upOffset, completion: { (upHeight) in
                            
                            upCount = 0
                            let firstDown = CGPoint(x: Int(point.x), y: Int(point.y + 1))
                            let downOffset = Int(firstDown.y) * width + Int(firstDown.x)
                            goDown(point: firstDown, offset: Int(downOffset), completion: { (downHeight) in
                                
                                downCount = 0
                                let rect = CGRect(x: Int(point.x), y: Int(point.y) - upHeight, width: 1, height: upHeight + downHeight + 1)
                                verticalRects.append(rect)
                            })
                        })
                    }
                })
                
                return verticalRects
            }
            

            
            /// NEW APPROACH ///
            ////////////////////

            rects = createVerticalRects(start: start)

        }//if let color = currentColor.color

        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        currentEdgesDetectedImage = outputImage
        
        return rects //outputImage
    }
    
    

    
    
    
    struct RGBA32: Equatable
    {
        var color: UInt32
        
        var red: UInt8
        {
            return UInt8((color >> 24) & 255)
        }
        
        var green: UInt8
        {
            return UInt8((color >> 16) & 255)
        }
        
        var blue: UInt8
        {
            return UInt8((color >> 8) & 255)
        }
        
        var alpha: UInt8
        {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)
        {
            color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
        }
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool
        {
            return lhs.color == rhs.color
        }
    }

    
    /// FUNCTIONS ///
    /////////////////

    
}//end of class
