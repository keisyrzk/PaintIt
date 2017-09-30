//
//  CoreDataManager.swift
//  RoomPainter
//
//  Created by keisyrzk on 23.12.2016.
//  Copyright © 2016 keisyrzk. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager
{
    ////////////////////////
    // CREATE A SINGLETON //
    
    class var sharedInstance: CoreDataManager
    {
        struct Singleton
        {
            static let instance = CoreDataManager()
        }
        return Singleton.instance
    }
    
    // CREATE A SINGLETON //
    ////////////////////////
    
    
    
    
    func delete(object: NSManagedObject, completion: (Result<EmptyResponse>) -> Void)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            completion(Result.success(EmptyResponse()))
            
        } catch let error as NSError
        {
            completion(Result<EmptyResponse>.failure(error))
        }
    }//end of deleteColor
    
    
    
    
    
    /////////////
    /// COLOR ///
    
    func saveColor(name: String, red: CGFloat, green: CGFloat, blue: CGFloat, completion: (Result<NSManagedObject>) -> Void)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
            //add color data
        let colorsEntity = NSEntityDescription.entity(forEntityName: "UserColor", in: managedContext)!
        let color = NSManagedObject(entity: colorsEntity, insertInto: managedContext)
        
        color.setValue(name, forKey: "name")
        color.setValue(red, forKey: "red")
        color.setValue(green, forKey: "green")
        color.setValue(blue, forKey: "blue")
        
            //save the context
        do {
            try managedContext.save()
            completion(Result<NSManagedObject>.success(color))
            
        } catch let error as NSError
        {
            completion(Result<NSManagedObject>.failure(error))
        }
    }//end of saveColor

    
    func fetchColors(completion: (Result<[Color]>) -> Void)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserColor")
        
        do {
            let colors = try managedContext.fetch(fetchRequest)
            
            let colorsObjects = createColorObjects(colorsData: colors)
            completion(Result<[Color]>.success(colorsObjects))
            
        } catch let error as NSError {
            completion(Result<[Color]>.failure(error))
        }
    }//end of fetchColors
    
    private func createColorObjects(colorsData: [NSManagedObject]) -> [Color]
    {
        var colorsObjects = [Color]()
        
        for colorData in colorsData
        {
            var nextColor = Color.init(name: colorData.value(forKeyPath: "name") as! String,
                       color: UIColor(red: colorData.value(forKeyPath: "red") as! CGFloat,
                                      green: colorData.value(forKeyPath: "green") as! CGFloat,
                                      blue: colorData.value(forKeyPath: "blue") as! CGFloat,
                                      alpha: 1))
            nextColor.object = colorData
            colorsObjects.append(nextColor)
        }
        
        return colorsObjects
    }
    
    /// COLOR ///
    /////////////

    
    
    ///////////////
    /// GALLERY ///
    
    func saveImage(newImage: UIImage, completion: (Result<NSManagedObject>) -> Void)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let imageData = reduceImageSize(image: newImage) else {
            return
        }
        
        
            //add gallery
        let imageEntity = NSEntityDescription.entity(forEntityName: "UserImage", in: managedContext)!
        let image = NSManagedObject(entity: imageEntity, insertInto: managedContext)
        
        image.setValue(imageData, forKey: "imageData")
        
        //save the context
        do {
            try managedContext.save()
            UserDefaultsManager().cacheCurrentImage()
            completion(Result<NSManagedObject>.success(image))
            
        } catch let error as NSError
        {
            completion(Result<NSManagedObject>.failure(error))
        }
    }//end of saveImage
    
    func fetchImages(completion: (Result<[NSManagedObject]>) -> Void)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserImage")
        
        do {
            let images = try managedContext.fetch(fetchRequest)
            
            completion(Result<[NSManagedObject]>.success(images))
        } catch let error as NSError {
            completion(Result<[NSManagedObject]>.failure(error))
        }
    }//end of fetchImages
    
    func objectToUIImage(object: NSManagedObject) -> UIImage?
    {
        let data = object.value(forKeyPath: "imageData") as! Data
        if let img = UIImage(data: data)
        {
            return img
        }
        return nil
    }
    
    /// GALLERY ///
    ///////////////
    
    
    
    
    private func reduceImageSize(image: UIImage) -> Data?
    {
        var compressedImage = UIImageJPEGRepresentation(image, 1)   //represent image as a JPEG
        var factor: CGFloat = 1.0   //percentage of the original image (compression factor)
        
        repeat
        {
            factor = factor - 0.1
            compressedImage = (UIImageJPEGRepresentation(image, factor)! as Data)     //compress the image to 'factor' percent of the original image
            
        } while (compressedImage?.count)! > 500000 && factor > 0.1     //reduce the image byte weight under 500kB
        
        if let compressed = compressedImage
        {
            return compressed
        }
        else
        {
            return nil
        }
    }

    
}//end of class
