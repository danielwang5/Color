//
//  ViewController.swift
//  Color
//
//  Created by James Wang on 1/17/17.
//  Copyright © 2017 DanielW. All rights reserved.
//



/*DATABASE

 Whos playing (phone id)
 Quevaron #
 *start of game (timestamp)
 nth plate tested (timestamp)
 *type of phone (apple, samsung, etc)
 *settings (brightness, etc)
 custom colors (number, background)
 *number they put
 *correct answer
 *right or wrong (bool)
 user data (country, age, sex, location, etc)
 
 
 */

import UIKit
import Foundation

class ViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var plateView: UIImageView!

    @IBOutlet weak var answerField: UITextField!

    @IBOutlet weak var timerBar: UIProgressView!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    // DATA!
    let modelName = UIDevice.current.modelName
    let brightness = Double(UIScreen.main.brightness)
    let phoneId:String = UIDevice.current.identifierForVendor!.uuidString
    
    var phoneInfo = PhoneData()
    
    var results: ResultData2 = ResultData2() //ResultData?
    //var currArray:[Int] = [0,0,0,0,0]
    
    //Timer 
    var startTime:Int = 3000 //in centiseconds
    var counter:Int = 0 //will equal startTime in viewDidLoad()
    var timer = Timer()
    
    //Score
    var score:Int = 0
    
    //Background
    var oRed:Float = 0.8
    var oGreen:Float = 0.8
    var oBlue:Float = 0.8
    var oAlpha:Float = 1.0
    
     //The Answers!!!
    
    var nthQuestion = 0
    var imageIndex: NSInteger = 0
    var maxImages = 17 //number of images - 1
    
    var numCorrect:Int = 0
    var numIncorrect:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //BG Color
        self.view.backgroundColor = UIColor(colorLiteralRed: oRed, green: oGreen, blue: oBlue, alpha: oAlpha)
        
        //phone info
        phoneInfo = PhoneData(id:phoneId, mod: modelName, bright: brightness)
        
        //randomize imageIndex
        imageIndex = randInt(upper: maxImages)
        
        //setup timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        counter = startTime
        
        
        results = ResultData2()
        
        plateView.image = UIImage(named: "plate\(imageIndex+1)")
        answerField.keyboardType = UIKeyboardType.decimalPad
        
        //focus on text field
        answerField.becomeFirstResponder()
        
        //plateView.isUserInteractionEnabled = true//so that image will move
        
        //set up gestures for swiping left and right
        /*let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        plateView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        plateView.addGestureRecognizer(swipeLeft)*/
        
        
        answerField.text = "" //"\(answerList[0])"
        
        problemLabel.text = String(numCorrect) + "/" + String(numIncorrect) //String(score)
        
    }
    
    func timerAction() {
        
        if(counter <= 0){
            timer.invalidate()
            finish()
        }
        
        counter -= 1
        updateBar(prog: Float(counter)/Float(startTime))
        //timerLabel.text = "\(Double(counter)/100)"
    }

    
    func updateBar(prog:Float){
        timerBar.setProgress(prog, animated: true)
    }
    

    @IBAction func checkAnswer(_ sender: UITextField) {
        
        let answerDigits = answerField.text!.digits
        let answer = (answerDigits.characters.count == 0) ?0:Int(answerDigits)!
        
        let timeElapsed:Double = Double(startTime - counter)/100
        
        if(answer != answerList[imageIndex] / 10 && answer != 0){
            results.setAns(info: SubmittedData(
                phoneInf: phoneInfo,
                orderinGam: nthQuestion,
                quesId: imageIndex,
                submittedAns: answer,
                timeElapse: timeElapsed
            ))
            
            
            
            
            
            if(answer == answerList[imageIndex]){ // correct
                flashColor(red: oRed - 0.3,green: oGreen + 0.1,blue: oBlue - 0.2,alpha: oAlpha)
                print("CORRECT")
                
                //add time
                counter += 100
                
                //increment score
                score += 1
                numCorrect += 1
            }
            else{ // incorrect
                flashColor(red: oRed + 0.1,green: oGreen - 0.1,blue: oBlue - 0.1,alpha: oAlpha)
                print("WRONG")
                print(answer)
                print(answerList[imageIndex])
                
                numIncorrect += 1
                
            }
            
            problemLabel.text = String(numCorrect) + "/" + String(numIncorrect)
            
            goForward()
            
            answerField.text = ""
            
            
        }// incomplete correct answer
        
        
    }
    
    func flashColor(red:Float, green:Float, blue:Float, alpha:Float) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.autoreverse], animations: {
            self.view.backgroundColor = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
        }, completion:{finished in self.view.backgroundColor = UIColor(colorLiteralRed: self.oRed, green: self.oGreen, blue: self.oBlue, alpha: self.oAlpha)})
    }
    
    
    func goBack(){
        // decrease index first
        imageIndex -= 1
        
        // check if index is in range
        if imageIndex < 0 {
            imageIndex = maxImages
        }
        plateView.image = UIImage(named: "plate\(imageIndex + 1)")
        
        //problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
    }
    
    func goForward(){
        // increase index first
        imageIndex = randInt(upper: maxImages)
        
        // check if index is in range
        //if imageIndex > maxImages {
            //imageIndex = 0
            //finish()
        //}
        plateView.image = UIImage(named: "plate\(imageIndex + 1)")
        
        //problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
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

            //answerField.text = "\(results.data[imageIndex].correctAnswer)"
        }
    }
    
    func finish(){
        //let vc = StopViewController()
            //UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "finished") as! StopViewController
        
        //vc.results = (self.results.data)
        //self.navigationController?.pushViewController(vc, animated:true)
        
        
        self.performSegue(withIdentifier: "finished", sender: self.results.data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! StopViewController
        controller.results = sender as! [SubmittedData]
        controller.mode = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randInt(upper: Int) -> Int{ //random integer from 0 to upper-1
        let k: Int = Int(arc4random_uniform(UInt32(upper)))
        return k
    }
    
}

