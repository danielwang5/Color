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

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        authenticateLocalPlayer()
        
        //introAnimation()
    }
    
    var gameCenterEnabled = false
    var leaderboardIdentifier = ""
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                self.present(viewController!, animated: true, completion: nil)
            } else {
                if localPlayer.isAuthenticated {
                    self.gameCenterEnabled = true
                    
                    localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier, error) -> Void in
                        if error != nil {
                            
                        } else {
                            self.leaderboardIdentifier = leaderboardIdentifier!
                        }
                    })
                    
                } else {
                    self.gameCenterEnabled = false
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func introAnimation() { //FIX
        UIView.transition(with: self.view,
            duration: 1.0,
            options: [.curveEaseInOut],
            animations: {
                self.titleLabel.center.y = 0
        }, completion: nil)
        
    }
    
    @IBAction func leaderboardLink(_ sender: Any) {
        let vc = self
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc.present(gc, animated: true, completion: nil)
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
