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
import GameKit

class StopViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var results: [SubmittedData] = []
    var resultsModified: [SubmittedDataModified] = []
    var mode = 0 //1 is original, 2 is modified
    
    
    var messageBody = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var numberCorrect = 0
        
        if(mode == 1){
        
            
            
            for item in results{ 
                if(item.correct){
                    numberCorrect += 1
                }
            }
            
            
            finalScoreLabel.text = "\(numberCorrect) correct!"
            
            
            for i in 0..<results.count{
                ResultData().saveAnswer(submitted: results[i])
            }
        
        }
        else if(mode == 2){
            
            for item in resultsModified{
                if(item.correct){
                    numberCorrect += 1
                }
            }
            
            
            finalScoreLabel.text = "\(numberCorrect) correct!"
            
            
            for i in 0..<resultsModified.count{
                ResultData().saveAnswer(submitted: resultsModified[i])
            }
        }
        
        submitToLeaderboard(mode: mode, score: numberCorrect)
        
    }
    
    //SUBMIT TO LEADERBOARD
    func submitToLeaderboard(mode:Int, score:Int){
        let leaderboardName = (mode == 1) ? "standardTest" : "generatedTest"
        let scoreObj = GKScore(leaderboardIdentifier: leaderboardName)
        scoreObj.context = 0
        scoreObj.value = Int64(score)
        GKScore.report([scoreObj], withCompletionHandler: {(error) -> Void in
            let alert = UIAlertView(title: "Success",
                message: "Score updated",
                delegate: self,
                cancelButtonTitle: "Ok")
        })
    }
    
    //MAIL FUNCTIONS
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("Decide mail")
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue: //delete stuff if sent
            print("Mail sent")
            deleteRecords(tableName: "Results")
            deleteRecords(tableName: "ResultsModified")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
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
        /*for result in results{
            messageBody += result.toString() + "\n"
        }*/
        
        messageBody = ResultData().toString()
        
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
    
    func deleteRecords(tableName:String){ //deletes records from named table
        
        print("DELETING...")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
        }
    }
    
    @IBAction func feedbackLink(_ sender: Any) {
        if let url = URL(string: "https://goo.gl/forms/TQpIBGVNB819pkUw2") {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
                // do something with the boolean
            }
        }
    }
    
}
