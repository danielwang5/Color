//
//  PausedViewController.swift
//  Color
//
//  Created by James Wang on 8/14/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import UIKit

class PausedViewController: UIViewController {
    
    var mode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unpause(_ sender: Any) {
        // Unpause parent VC
        if (mode == 1){
            let parentVC = (self.presentingViewController)! as! ViewController
            parentVC.isPaused = false
        }
        if (mode == 2){
            let parentVC = (self.presentingViewController)! as! ModifiedViewController
            parentVC.isPaused = false
        }
        
        dismiss(animated: true, completion: nil)
    }
}
