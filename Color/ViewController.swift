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

class ViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var plateView: UIImageView!

    @IBOutlet weak var answerField: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    // DATA!
    let modelName = UIDevice.current.modelName
    let brightness = Double(UIScreen.main.brightness)
    
    var phoneInfo = PhoneData()
    
    var results: ResultData2 = ResultData2() //ResultData?
    //var currArray:[Int] = [0,0,0,0,0]
    
    //Timer 
    var startTime:Int = 3000 //in centiseconds
    var counter:Int = 0 //will equal startTime in viewDidLoad()
    var timer = Timer()
    
     //The Answers!!!
    
    var nthQuestion = 0
    var imageIndex: NSInteger = 0
    var maxImages = 4 //number of images - 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //phone info
        phoneInfo = PhoneData(mod: modelName, bright: brightness)
        
        //setup timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        counter = startTime
        
        
        results = ResultData2()
        
        plateView.image = UIImage(named: "plate1")
        answerField.keyboardType = UIKeyboardType.decimalPad
        //answerField.text = "\((results.getAns("a\(0)"))!)"
        
        plateView.isUserInteractionEnabled = true//so that image will move
        
        //set up gestures for swiping left and right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        plateView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        plateView.addGestureRecognizer(swipeLeft)
        
        
        answerField.text = "" //"\(answerList[0])"
        
        problemLabel.text = "\(imageIndex + 1)/\(maxImages + 1)"
    }
    
    func timerAction() {
        
        if(counter <= 0){
            timer.invalidate()
            finish()
        }
        
        counter -= 1
        timerLabel.text = "\(Double(counter)/100)"
    }

    
    
    

    @IBAction func submitAnswer(_ sender: UITextField) {
        let answer = Int(sender.text!)!
        
        var timeElapsed:Double = Double(startTime - counter)/100
        
        results.setAns(info: SubmittedData(
                                           phoneInf: phoneInfo,
                                           orderinGam: nthQuestion,
                                           quesId: imageIndex,
                                           submittedAns: answer,
                                           timeElapse: timeElapsed
                                        ))
        
        
        goForward()
        
        answerField.text = ""
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
            //imageIndex = 0
            finish()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

