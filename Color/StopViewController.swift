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

class StopViewController: UIViewController {
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var results: [SubmittedData] = []
    
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
        
        finalScoreLabel.text = "\(ResultData().fetchAnswer().count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
