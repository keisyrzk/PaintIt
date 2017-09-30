//
//  Settings.swift
//  RoomPainter
//
//  Created by keisyrzk on 27.01.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import Toast_Swift


class Settings: UITableViewController
{
    @IBOutlet weak var tintLabel: UILabel!
    @IBOutlet weak var solidLabel: UILabel!
    @IBOutlet weak var colorFillStyleSwitch: UISwitch!
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizePreview: UIImageView!
    @IBOutlet weak var brushPreviewHeight: NSLayoutConstraint!
    @IBOutlet weak var brushPreviewWidth: NSLayoutConstraint!
    

    let sectionsTitles = [NSLocalizedString("_settingsColorFillStyle", comment: ""),
                          NSLocalizedString("_settingsBrushSize", comment: "")]
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup()
        fetchSettings()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        (self.parent as! MainNavigationContainer).navItem.rightBarButtonItems = nil
        navBarTitle = NSLocalizedString("_settings", comment: "")

    }
    
    override func viewWillDisappear(_ animated: Bool)
    {        
        saveSettings()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setupLayout()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionsTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sectionsTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.contentView.blurred(style: .dark, alpha: 1, cornerRadius: nil, corners: nil)
    }
    
    
    /////////////////
    /// FUNCTIONS ///
    
    func setup()
    {
        brushSizeSlider.addTarget(self, action: #selector(self.sliderValueDidChange), for: .valueChanged)
    }
    
    func setupLayout()
    {
        self.view.blurred(style: .dark, alpha: 0.9, cornerRadius: nil, corners: nil)
        
            //make the switches not having fill color, only the border
        colorFillStyleSwitch.onlyBorder(color: .white)
    }
    
    func sliderValueDidChange(sender: UISlider)
    {
        brushPreviewHeight.constant = CGFloat(sender.value)
        brushPreviewWidth.constant = CGFloat(sender.value)
        brushSizePreview.layer.cornerRadius = brushSizePreview.frame.width/2
    }
    
    func saveSettings()
    {
        UserDefaultsManager().saveSettings(brushSize: brushSizeSlider.value,
                                           colorFillStyle: colorFillStyleSwitch.isOn)
    }
    
    func fetchSettings()
    {
        UserDefaultsManager().fetchSettings()

        brushSizeSlider.value = currentSettings.brushSize
        brushPreviewHeight.constant = CGFloat(currentSettings.brushSize)
        brushPreviewWidth.constant = CGFloat(currentSettings.brushSize)
        
        brushPreviewHeight.constant = CGFloat(brushSizeSlider.value)
        brushPreviewWidth.constant = CGFloat(brushSizeSlider.value)
        
        brushSizePreview.clipsToBounds = true
        brushSizePreview.layer.cornerRadius = brushSizePreview.frame.width/2
        
        colorFillStyleSwitch.setOn(currentSettings.colorFillStyle, animated: true)        
    }
    
    /// FUNCTIONS ///
    /////////////////


}//end of class
