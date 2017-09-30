//
//  Button3Dtest.swift
//  PaintIt
//
//  Created by keisyrzk on 10.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import XCTest
@testable import PaintIt


class Button3Dtest: XCTestCase
{
    
    let frontOnColor =  UIColor(red: 132.0 / 255.0, green: 220.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    let backOnColor = UIColor(red: 107.0 / 255.0, green: 187.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
    
    let frontOffColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    let backOffColor = UIColor.clear
    
    let textOnColor = UIColor.white
    let textOffColor = UIColor.darkGray
    
    let button = Button3D.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testTurnOn()
    {
        button.turnOn(value: true)
        
        if let frontView = button.subviews.findElement({ $0.tag == 1 }),
            let backView = button.subviews.findElement({ $0.tag == 2 }),
            let topViewLabel1 = button.subviews.findElement({ $0.tag == 1 })
            
        {
            if let frontViewLabel = topViewLabel1.subviews.findElement({ $0.tag == 3 }) as? UILabel
            {
                XCTAssertEqual(frontView.backgroundColor, frontOnColor, "front view color did not change")
                XCTAssertEqual(backView.backgroundColor, backOnColor, "back view color did not change")
                XCTAssertEqual(frontViewLabel.textColor, textOnColor, "text color did not change")
                XCTAssertEqual(frontViewLabel.text, NSLocalizedString("_saveButton", comment: ""), "text did not change")
                XCTAssertEqual(button.buttonState, .Save, "button state did not change")
            }
        }
        
        
    }
    
    func testTurnOff()
    {
        button.turnOn(value: false)
        
        if let frontView = button.subviews.findElement({ $0.tag == 1 }),
            let backView = button.subviews.findElement({ $0.tag == 2 }),
            let topViewLabel1 = button.subviews.findElement({ $0.tag == 1 })
            
        {
            if let frontViewLabel = topViewLabel1.subviews.findElement({ $0.tag == 3 }) as? UILabel
            {
                XCTAssertEqual(frontView.backgroundColor, frontOffColor, "front view color did not change")
                XCTAssertEqual(backView.backgroundColor, backOffColor, "back view color did not change")
                XCTAssertEqual(frontViewLabel.textColor, textOffColor, "text color did not change")
                XCTAssertEqual(frontViewLabel.text, NSLocalizedString("_cancelButton", comment: ""), "text did not change")
                XCTAssertEqual(button.buttonState, .Cancel, "button state did not change")
            }
        }
    }

    
}
