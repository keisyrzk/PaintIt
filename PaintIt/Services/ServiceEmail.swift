//
//  ServiceEmail.swift
//  PaintIt
//
//  Created by keisyrzk on 09.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import MessageUI
import Toast_Swift

class ServiceEmail: NSObject, MFMailComposeViewControllerDelegate
{
    static let instance = ServiceEmail()     //an instance
    private override init() {}
    
    func shareEmail(viewController: UIViewController)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Paint It - photo")
            mail.setToRecipients([])
            mail.setMessageBody("", isHTML: false)
            
            if let _image = currentGalleryImage
            {
                if let imageData = UIImageJPEGRepresentation(_image, 1)
                {
                    mail.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "PaintIt_photo")

                    viewController.present(mail, animated: true, completion: nil)
                }
            }
        }
        else
        {
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        if result == .sent
        {
            controller.view.makeToast(NSLocalizedString("_emailShareSent", comment: ""), duration: 2, position: .center, title: nil, image: nil, style: nil, completion: { (_) in
                controller.dismiss(animated: true)
            })
        }
        else
        {
            print("ERROR:  \(error?.localizedDescription)")
            controller.view.makeToast(NSLocalizedString("_emailShareSentError", comment: ""), duration: 2, position: .center, title: nil, image: nil, style: nil, completion: { (_) in
                controller.dismiss(animated: true)
            })
        }
    }
    
    
}//end of class
