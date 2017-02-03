//
//  ViewController.swift
//  Color
//
//  Created by James Wang on 1/17/17.
//  Copyright © 2017 DanielW. All rights reserved.
//



/*DATABASE

 Whos playing (phone id)
 Question #
 start of game (timestamp)
 nth plate tested (timestamp)
 *type of phone (apple, samsung, etc)
 *settings (brightness, etc)
 custom colors (number, background)
 number they put
 correct answer
 right or wrong (bool)
 user data (country, age, sex, location, etc)
 
 
 */

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var plateView: UIImageView!

    @IBOutlet weak var answerField: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    // DATA!
    let modelName = UIDevice.current.modelName
    let brightness = UIScreen.main.brightness
    let startTime = Date().timeIntervalSince1970
    
    var results: ResultData?
    //var currArray:[Int] = [0,0,0,0,0]
    
    //Timer 
    var counter = 30
    var timer = Timer()
    
    var answerList = [12,8,6,29,57] //The Answers!!!
    
    var imageIndex: NSInteger = 0
    var maxImages = 4 //number of images - 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //currArray = (results?.ans)!
        
        //setup timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
        results = ResultData(answer:0)
        
        plateView.image = UIImage(named: "plate1")
        answerField.keyboardType = UIKeyboardType.decimalPad
        answerField.text = "\((results?.ans["a\(0)"])!)"
        
        plateView.isUserInteractionEnabled = true//so that image will move
        
        //set up gestures for swiping left and right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        plateView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        plateView.addGestureRecognizer(swipeLeft)
        
        
        answerField.text = "\(answerList[0])"
        
        problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
    }
    
    func timerAction() {
        
        if(counter <= 0){
            timer.invalidate()
            finish()
        }
        
        counter -= 1
        timerLabel.text = "\(counter)"
    }

    
    
    

    @IBAction func submitAnswer(_ sender: UITextField) {
        let answer = Int(sender.text!)
        
        
        //currArray[imageIndex] = answer!
        
        results?.ans["a\(imageIndex)"] = answer!
        results?.saveAnswers()

        
        /*if(answer == answerList[imageIndex]){
            let alertController = UIAlertController(title: "Correct!", message:
                "The answer is \(answerList[imageIndex])", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Incorrect.", message:
                "The answer is \(answerList[imageIndex])", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }*/
        
        goForward()
    }
    
    
    func goBack(){
        // decrease index first
        imageIndex -= 1
        
        // check if index is in range
        if imageIndex < 0 {
            imageIndex = maxImages
        }
        plateView.image = UIImage(named: "plate\(imageIndex + 1)")
        
        problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
    }
    
    func goForward(){
        // increase index first
        imageIndex += 1
        
        // check if index is in range
        if imageIndex > maxImages {
            imageIndex = 0
        }
        plateView.image = UIImage(named: "plate\(imageIndex + 1)")
        
        problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {

                case UISwipeGestureRecognizerDirection.right :
                    NSLog("User swiped right")
                    goBack()
                
                
                case UISwipeGestureRecognizerDirection.left:
                    NSLog("User swiped Left")
                    goForward()
                
                default:
                    break //stops the code/codes nothing.
            }

            answerField.text = "\((results?.ans["a\(imageIndex)"])!)"
        }
    }
    
    func finish(){
        /*let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "finished") as! StopViewController
        
        //vc.resultsArray = self.resultsArray
        self.navigationController?.pushViewController(vc, animated:true)*/
        
        self.performSegue(withIdentifier: "finished", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

