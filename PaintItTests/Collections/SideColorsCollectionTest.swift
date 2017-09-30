//
//  SideColorsCollectionTest.swift
//  PaintIt
//
//  Created by keisyrzk on 10.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import XCTest
@testable import PaintIt


class SideColorsCollectionTest: XCTestCase
{
    var controller: PaintMain!
    
    override func setUp()
    {
        super.setUp()
        
            //instatiate the right controller
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! PaintMain
        
            //load the controllers view hierarchy
        let _ = controller.view
    }
    
    func testIfOutletNotNil()
    {
        XCTAssertNotNil(controller.leftColorsCollectionView, "left colelctionView is nil")
        XCTAssertNotNil(controller.rightColorsCollectionView, "right colelctionView is nil")
    }
    
    func testLeftCollectionHasCorrectNumberOfItems()
    {
        controller.leftColorsCollectionView.inputDataSource = DefaultColors().colors
        controller.leftColorsCollectionView.reloadData()
        
        XCTAssertNotNil(controller.leftColorsCollectionView.dataSource, "datasource is nil")
        
        if let dataSource = controller.leftColorsCollectionView.dataSource
        {
            XCTAssert(dataSource.collectionView(controller.leftColorsCollectionView, numberOfItemsInSection: 0) == DefaultColors().colors.count, "left collectionView does not have correct number of elements")
        }
    }

    
    func getData(completion: ([Color]) -> Void)
    {
        CoreDataManager.sharedInstance.fetchColors { (result) in
            switch result
            {
            case .success(let colors):
                completion(colors)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func testRightCollectionHasCorrectNumberOfItems()
    {
        getData { (colors) in
            controller.rightColorsCollectionView.inputDataSource = colors
            controller.rightColorsCollectionView.reloadData()
            
            XCTAssertNotNil(controller.rightColorsCollectionView.dataSource, "datasource is nil")
            
            if let dataSource = controller.rightColorsCollectionView.dataSource
            {
                XCTAssert(dataSource.collectionView(controller.rightColorsCollectionView, numberOfItemsInSection: 0) == colors.count, "left collectionView does not have correct number of elements")
            }
        }
        

    }
}//end of class
