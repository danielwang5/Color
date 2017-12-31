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
import AVFoundation

//global view height
var globalViewHeight = 240;

class ModifiedViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var plateView: DrawingTestView!
    
    @IBOutlet weak var answerField: UITextField!
    
    @IBOutlet weak var timerBar: UIProgressView!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
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
    var isPaused:Bool = false
    var timerInit = true //initialize things via timer
    
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
    
    var nthQuestion:Int = -1
    var difficulty:Int = 0
    
    var numCorrect:Int = 0
    var numIncorrect:Int = 0
    
    var timeElapsedCurrent:Int = 0 //number of frames elapsed
    
    //Pause View
    //var mycustomView: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        //Pause View
        //mycustomView.isHidden = true
        
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
        
        problemLabel.text = String(numCorrect) + " Correct / " + String(numIncorrect) + " Incorrect"//String(score)
        
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
        
        //make plateView a square
        
        let plateXCoord = plateView.frame.origin.x + (plateView.frame.size.width - plateView.frame.size.height)/2
        plateView.frame = CGRect(x: plateXCoord, y: plateView.frame.origin.y, width: plateView.frame.size.height, height: plateView.frame.size.height)
        
        globalViewHeight = Int(plateView.frame.size.height)
        
        if(timerInit){
            goForward()
            timerInit = false
        }
        
        
        if(!isPaused){
            if(counter <= 0){
                timer.invalidate()
                finish()
            }
            
            counter -= 1
            
            timeElapsedCurrent += 1
            
            updateBar(prog: Float(counter)/Float(startTime))
        }
    }
    
    
    func updateBar(prog:Float){
        timerBar.setProgress(prog, animated: true)
    }
    
    func getHeight() -> CGFloat{
        return plateView.frame.size.height;
    }
    
    
    @IBAction func checkAnswer(_ sender: Any) {
        let answerDigits = answerField.text!.digits
        let answer = (answerDigits.characters.count == 0) ?0:Int(answerDigits)!
        
        let timeElapsed:Double = Double(startTime - counter)/100
        
        if((answer != randNum / 10 && randNum != 0) || (answer == 0 && randNum == 0)){//if not in the middle of typing answer
            
            let timeElapsed:Double = Double(startTime - counter)/100
            
            let realTimeElapsedCurrent:Double = Double(timeElapsedCurrent)/100
            timeElapsedCurrent = 0
            
            
            results.setAns(info: SubmittedDataModified(
                phoneInf: phoneInfo,
                orderinGam: nthQuestion,
                correctAns: randNum,
                submittedAns: answer,
                timeElapse: timeElapsed,
                timeElapsedCurr:realTimeElapsedCurrent,
                numCol: numCol,
                backCol: backCol
            ))
            
            //COMMENT OUT FOR NOW!
            
            
            
            
            
            if(answer == randNum){ // correct
                flashColor(red: oRed - 0.3,green: oGreen + 0.1,blue: oBlue - 0.2,alpha: oAlpha)
                print("CORRECT")
                
                //play sound
                playSound(soundName: "Ding-sfx")
                
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
                
                //play sound
                playSound(soundName: "Buzz")
                
                flashColor(red: oRed + 0.1,green: oGreen - 0.1,blue: oBlue - 0.1,alpha: oAlpha)
                print("WRONG")
                print(answer)
                print(randNum)
            }
            
            problemLabel.text = String(numCorrect) + " Correct / " + String(numIncorrect) + " Incorrect"
            
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
    
    /*@IBAction func paused(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PausedViewController")
        vc?.modalPresentationStyle = .overCurrentContext
        
        self.present(vc!, animated: true, completion: nil)
        
        
            
            //self.view.addSubview(mycustomView)
            
            //mycustomView.isHidden = false

            
            /*let okayButton = UIButton(frame: CGRect(x: 40, y: 100, width: 50, height: 50))
            
            // here we are adding the button its superView
            mycustomView.addSubview(okayButton)
            
            okayButton.addTarget(self, action: #selector(self.okButtonImplementation:), forControlEvents:.TouchUpInside)*/
        
        
    }*/
    
    func playSound(soundName:String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(contentsOf: url)
            //guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func finish(){
        
        self.performSegue(withIdentifier: "finishedmodified", sender: self.results.data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "finishedmodified"){
            let controller = segue.destination as! StopViewController
            controller.resultsModified = sender as! [SubmittedDataModified]
            controller.mode = 2
        }
        else if (segue.identifier == "pausedmodified"){
            let controller = segue.destination as! PausedViewController
            controller.mode = 2
            isPaused = true
        }
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

