//
//  ViewController.swift
//  Color
//
//  Created by James Wang on 1/18/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leaderboardLink(_ sender: Any) {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
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
