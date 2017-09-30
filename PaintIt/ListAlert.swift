//
//  ListAlert.swift
//  RoomPainter
//
//  Created by keisyrzk on 30.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

protocol ListAlertDelegate
{
    func didSelectOption(listAlert: ListAlert, optionIndex: Int)
}

class ListAlert: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var cellHeight: CGFloat = 44
    var inputData: [String] = []
    var listAlertDelegate: ListAlertDelegate?

    private let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    private var blurEffectView = UIVisualEffectView()

    
    override func awakeFromNib()
    {
        isScrollEnabled = false
        delegate = self
        dataSource = self
        backgroundColor = UIColor.clear
        self.isScrollEnabled = false
        self.clipsToBounds = true
        separatorStyle = .none //.singleLine
    }
    
    
    override func draw(_ rect: CGRect)
    {
        makeBackground(frame: rect)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return inputData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listAlertCell", for: indexPath) as! ListAlertCell
        
        cell.setCellTitle(cellTitle: inputData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        listAlertDelegate?.didSelectOption(listAlert: self, optionIndex: indexPath.row)
        self.layoutIfNeeded()
    }
    
    func makeBackground(frame: CGRect)
    {
        let backView = UIView()
        backView.frame = CGRect(x: 0, y: 0, width: frame.width, height: self.contentSize.height)
        backView.backgroundColor = UIColor.white
        
        let path = UIBezierPath(roundedRect:backView.bounds,
                                byRoundingCorners: [.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        backView.layer.mask = maskLayer
        
        self.addSubview(backView)
        self.sendSubview(toBack: backView)
    }


}//end of class
