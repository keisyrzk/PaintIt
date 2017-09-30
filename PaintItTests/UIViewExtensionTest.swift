//
//  UIViewExtensionTest.swift
//  PaintIt
//
//  Created by keisyrzk on 10.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import XCTest
@testable import PaintIt



class UIViewExtensionTest: XCTestCase
{
    let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
    let testView = UIView()
    
    
    
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
    
    
    
    /// LEFT EDGE ///
    
    func testShowLeftEqualOriginX()
    {
        testView.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, -50, "bad view's origin.x")
    }
    
    func testShowLeftGreaterOriginX()
    {
        testView.frame = CGRect(x: 30, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, -80, "bad view's origin.x")
    }
    
    func testShowLeftSmallerOriginX()
    {
        testView.frame = CGRect(x: -80, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 30, "bad view's origin.x")
    }
    
    func testShowLeftSmallerRightEqualOriginX()
    {
        testView.frame = CGRect(x: -50, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 0, "bad view's origin.x")
    }
    
    
    
    /// RIGHT EDGE ///
    
    func testShowRightEqualOriginX()
    {
        testView.frame = CGRect(x: 150, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 200, "bad view's origin.x")
    }
    
    func testShowRightGreaterOriginX()
    {
        testView.frame = CGRect(x: 230, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 120, "bad view's origin.x")
    }
    
    func testShowRightGreaterLeftEqualOriginX()
    {
        testView.frame = CGRect(x: 200, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 150, "bad view's origin.x")
    }
    
    func testShowRightSmallerOriginX()
    {
        testView.frame = CGRect(x: 120, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Horizontal)
        
        XCTAssertEqual(testView.frame.origin.x, 230, "bad view's origin.x")
    }
    
    
    
    /// TOP EDGE ///
    
    func testShowTopEqualOriginY()
    {
        testView.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, -100, "bad view's origin.y")
    }
    
    func testShowTopGreaterOriginY()
    {
        testView.frame = CGRect(x: 0, y: 30, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, -130, "bad view's origin.y")
    }
    
    func testShowTopSmallerOriginY()
    {
        testView.frame = CGRect(x: 0, y: -130, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 30, "bad view's origin.y")
    }
    
    func testShowTopSmallerBottomEqualOriginY()
    {
        testView.frame = CGRect(x: 0, y: -100, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 0, "bad view's origin.y")
    }
    
    
    
    /// BOTTOM EDGE ///
    
    func testShowBottomEqualOriginY()
    {
        testView.frame = CGRect(x: 0, y: 300, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 400, "bad view's origin.y")
    }
    
    func testShowBottomGreaterOriginY()
    {
        testView.frame = CGRect(x: 0, y: 430, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 270, "bad view's origin.y")
    }
    
    func testShowBottomGreaterTopEqualOriginY()
    {
        testView.frame = CGRect(x: 0, y: 400, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 300, "bad view's origin.y")
    }
    
    func testShowBottomSmallerOriginY()
    {
        testView.frame = CGRect(x: 0, y: 270, width: 50, height: 100)
        parentView.addSubview(testView)
        testView.showOrHide(direction: .Vertical)
        
        XCTAssertEqual(testView.frame.origin.y, 430, "bad view's origin.y")
    }

}
