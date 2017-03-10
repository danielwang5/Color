//
//  StopViewController.swift
//  Color
//
//  Created by James Wang on 2/2/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MessageUI

class StopViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var results: [SubmittedData] = []
    var messageBody = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var numberCorrect = 0
        
        for item in results{
            if(item.correct){
                numberCorrect += 1
            }
        }
        
        
        //finalScoreLabel.text = results[0].phoneInfo.model //"\(numberCorrect) correct!"
        
        
        for i in 0..<results.count{
            ResultData().saveAnswer(submitted: results[i])
        }
        
        //TEST: Fetch User Data
        
        let fetchedData = ResultData().fetchAnswer()
        
        finalScoreLabel.text = "\(fetchedData[fetchedData.count-1].value(forKey: "submittedAnswer")!)"
        
    }
    
    //MAIL FUNCTIONS
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        //ADD RESULT DATA TO MESSAGE BODY
        for result in results{
            messageBody += result.toString() + "\n"
        }
        
        mailComposerVC.setToRecipients(["dwq@mit.edu"])
        mailComposerVC.setSubject("Color Test Results")
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
