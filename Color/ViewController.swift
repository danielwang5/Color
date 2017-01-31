//
//  ViewController.swift
//  Color
//
//  Created by James Wang on 1/17/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var plateView: UIImageView!

    @IBOutlet weak var answerField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        plateView.image = UIImage(named: "plate1")
        answerField.keyboardType = UIKeyboardType.DecimalPad
        
        plateView.userInteractionEnabled = true//so that image will move
        
        //set up gestures for swiping left and right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        plateView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        plateView.addGestureRecognizer(swipeLeft)
    }

    var answerList = [12,8,6,29,57]
    
    var imageIndex: NSInteger = 0
    var maxImages = 4 //number of images - 1
    
    @IBAction func submitAnswer(sender: UITextField) {
        var answer = Int(sender.text!)
        
        ResultData().saveAnswer(imageIndex, typed: answer!)
        
        if(answer == answerList[imageIndex]){
            let alertController = UIAlertController(title: "Correct!", message:
                "The answer is \(answerList[imageIndex])", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Incorrect.", message:
                "The answer is \(answerList[imageIndex])", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right :
                    NSLog("User swiped right")
                    
                    // decrease index first
                    imageIndex -= 1
                    
                    // check if index is in range
                    if imageIndex < 0 {
                        imageIndex = maxImages
                    }
                    plateView.image = UIImage(named: "plate\(imageIndex + 1)")
                
                case UISwipeGestureRecognizerDirection.Left:
                    NSLog("User swiped Left")
                    
                    // increase index first
                    imageIndex += 1

                    // check if index is in range
                    if imageIndex > maxImages {
                        imageIndex = 0
                    }
                    plateView.image = UIImage(named: "plate\(imageIndex + 1)")
                default:
                    break //stops the code/codes nothing.
            }
            
            answerField.text = "\(ResultData().fetchAnswer(imageIndex))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

