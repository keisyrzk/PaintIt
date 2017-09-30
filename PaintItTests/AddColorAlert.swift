//
//  AddColorAlert.swift
//  PaintIt
//
//  Created by keisyrzk on 10.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import XCTest
@testable import PaintIt


class AddColorAlert: XCTestCase
{
    var controller: UIViewController!
    var alertController: ColorWheelAlert!
    
    override func setUp()
    {
        super.setUp()
       
        controller = UIViewController()
        
        alertController = Bundle.main.loadNibNamed("ColorWheelAlert", owner: nil, options: nil)?[0] as! ColorWheelAlert
        alertController.colorWheel.image = #imageLiteral(resourceName: "colorWheel")
        alertController.modalPresentationStyle = .overCurrentContext
        controller.present(alertController, animated: true, completion: nil)
    }
    

    func testAlertShowsUp()
    {
        XCTAssertNotNil(alertController, "alert is nil")
    }
    
    func testColorAtPoint()
    {
        let xPos = alertController.colorWheel.frame.size.width/2
        let yPos = alertController.colorWheel.frame.size.height/2
        let testPoint = CGPoint(x: xPos, y: yPos)
        
        let gotColor = alertController.colorAtPoint(point: testPoint)
        
        XCTAssertEqual(gotColor, UIColor(red: 1, green: 1, blue: 1, alpha: 1), "the color in the center in not white")
        
        let testPoint2 = CGPoint(x: xPos + 1, y: yPos)
        let gotColor2 = alertController.colorAtPoint(point: testPoint2)

        XCTAssertNotEqual(gotColor2, UIColor(red: 1, green: 1, blue: 1, alpha: 1), "color at this point should not be white")
    }
    
    
}//end of class
