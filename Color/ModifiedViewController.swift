//
//  ViewController.swift
//  Color
//
//  Created by James Wang on 6/8/17.
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

class ModifiedViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var plateView: DrawingTestView!
    
    @IBOutlet weak var answerField: UITextField!
    
    @IBOutlet weak var timerBar: UIProgressView!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    // DATA!
    let modelName = UIDevice.current.modelName
    let brightness = Double(UIScreen.main.brightness)
    let phoneId:String = UIDevice.current.identifierForVendor!.uuidString
    
    var phoneInfo = PhoneData()
    
    var results: ResultData2Modified = ResultData2Modified() //ResultData?
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
    
    //Plate Colors
    var numCol:[Float] = [0.0,0.0,1.0]
    var backCol:[Float] = [0.0,1.0,0.0]
    
    //The Answers!!!
    
    var randNum:Int = 0
    
    var nthQuestion:Int = 0
    var difficulty:Int = 0
    
    var numCorrect:Int = 0
    var numIncorrect:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //plateview redraw (currently useless?)
        plateView.clearsContextBeforeDrawing = true
        
        
        //BG Color
        self.view.backgroundColor = UIColor(colorLiteralRed: oRed, green: oGreen, blue: oBlue, alpha: oAlpha)
        
        //phone info
        phoneInfo = PhoneData(id:phoneId, mod: modelName, bright: brightness)
        
        //randomize imageIndex
        randNum = randInt(upper: 99) + 1 //from 1 to 99
        
        //setup timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        counter = startTime
        
        
        results = ResultData2Modified()
        
        //plateView.image = UIImage(named: "plate\(imageIndex+1)")
        answerField.keyboardType = UIKeyboardType.decimalPad
        
        //focus on text field
        answerField.becomeFirstResponder()
        
        
        answerField.text = "" //"\(answerList[0])"
        
        problemLabel.text = String(numCorrect) + "/" + String(numIncorrect) //String(score)
        
        drawNum()
        
    }
    
    func drawNum(){
        
        nthQuestion += 1
        
        randNum = randInt(upper: 100)
        plateView.theNumber = randNum
        plateView.setNeedsDisplay() //should clear view and redraw --- fix this
        
        var newColors = ColorGeneration().getColors(iteration: difficulty)
        
        backCol = newColors[0]
        numCol = newColors[1]
        
        plateView.numColor = numCol
        plateView.backColor = backCol
    }
    
    func timerAction() {
        
        if(counter <= 0){
            timer.invalidate()
            finish()
        }
        
        counter -= 1
        updateBar(prog: Float(counter)/Float(startTime))
    }
    
    
    func updateBar(prog:Float){
        timerBar.setProgress(prog, animated: true)
    }
    
    
    @IBAction func checkAnswer(_ sender: UITextField) {
        let answerDigits = answerField.text!.digits
        let answer = answerDigits=="" ?0:Int(answerDigits)!
        
        let timeElapsed:Double = Double(startTime - counter)/100
        
        if(answer != randNum / 10){//if not in the middle of typing answer
            results.setAns(info: SubmittedDataModified(
                phoneInf: phoneInfo,
                orderinGam: nthQuestion,
                correctAns: randNum,
                submittedAns: answer,
                timeElapse: timeElapsed,
                numCol: numCol,
                backCol: backCol
            ))
            
            //COMMENT OUT FOR NOW!
            
            
            
            
            
            if(answer == randNum){ // correct
                flashColor(red: oRed - 0.3,green: oGreen + 0.1,blue: oBlue - 0.2,alpha: oAlpha)
                print("CORRECT")
                
                //add time
                counter += 100
                
                difficulty += 1
                numCorrect += 1
                
                //increment score
                score += 1
                
            }
            else{ // incorrect
                
                difficulty -= 1
                numIncorrect += 1
                
                flashColor(red: oRed + 0.1,green: oGreen - 0.1,blue: oBlue - 0.1,alpha: oAlpha)
                print("WRONG")
                print(answer)
                print(randNum)
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
        drawNum()
        
    }
    
    func goForward(){
        drawNum()

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
        }
    }
    
    func finish(){
        
        self.performSegue(withIdentifier: "finishedmodified", sender: self.results.data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! StopViewController
        controller.resultsModified = sender as! [SubmittedDataModified]
        controller.mode = 2
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

