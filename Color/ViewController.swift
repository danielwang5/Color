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
    }

    @IBAction func submitAnswer(sender: UITextField) {
        var answer = Int(sender.text!)
        if(answer == 12){
            NSLog("Correct!")
        }
        else{
            NSLog("Incorrect.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

