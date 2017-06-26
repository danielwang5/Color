//
//  ResultData.swift
//  Color
//
//  Created by James Wang on 1/23/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

//PERSISTENT

import Foundation
import CoreData
import UIKit


class ResultData{
    
    func saveAnswer(submitted:SubmittedData) {
        
        /*guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }*/
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Results",
                                                        in:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)

        person.setValue(submitted.correct, forKey: "correct")
        person.setValue(submitted.correctAnswer, forKey: "correctAnswer")
        person.setValue(submitted.orderInGame, forKey: "orderInGame")
        person.setValue(submitted.questionId, forKey: "questionId")
        person.setValue(submitted.submittedAnswer, forKey: "submittedAnswer")
        person.setValue(submitted.timeElapsed, forKey: "timeElapsed")
        person.setValue(submitted.phoneInfo.phoneId, forKey: "phoneId")
        person.setValue(submitted.phoneInfo.brightness, forKey: "brightness")
        person.setValue(submitted.phoneInfo.model, forKey: "model")
        //add difference in time
        
        do {
            print("AJGDJGDAGDGAKJDKAJDKHA")
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchAnswer() -> [NSManagedObject]{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Results")
        
        var results:[NSManagedObject] = []
        
        do {
            results = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return results
    }
    
    func toString() -> String{
        let results = fetchAnswer()
        var out:String = ""
        
        
        var keyList = ["questionId","correctAnswer","submittedAnswer","orderInGame","correctAnswer","correct","timeElapsed","phoneId","model","brightness"]
        
        for item in results{
            for key in keyList{
                out += "\(item.value(forKey: key)!),"
            }
        }
        
        return out
    }
    
}
