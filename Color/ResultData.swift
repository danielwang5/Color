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
    
    func saveAnswer(submitted:SubmittedDataModified) {
        
        /*guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
         return
         }*/
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "ResultsModified",
                                                 in:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        person.setValue(submitted.correct, forKey: "correct")
        person.setValue(submitted.correctAnswer, forKey: "correctAnswer")
        person.setValue(submitted.orderInGame, forKey: "orderInGame")
        person.setValue(submitted.submittedAnswer, forKey: "submittedAnswer")
        person.setValue(submitted.timeElapsed, forKey: "timeElapsed")
        person.setValue(submitted.phoneInfo.phoneId, forKey: "phoneId")
        person.setValue(submitted.phoneInfo.brightness, forKey: "brightness")
        person.setValue(submitted.phoneInfo.model, forKey: "model")
        person.setValue(submitted.numberColorR, forKey: "numberColorR")
        person.setValue(submitted.numberColorG, forKey: "numberColorG")
        person.setValue(submitted.numberColorB, forKey: "numberColorB")
        person.setValue(submitted.backgroundColorR, forKey: "backgroundColorR")
        person.setValue(submitted.backgroundColorG, forKey: "backgroundColorG")
        person.setValue(submitted.backgroundColorB, forKey: "backgroundColorB")
        //add difference in time
        
        do {
            print("AJGDJGDAGDGAKJDKAJDKHA")
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
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
    
    func fetchAnswer(modified:Bool) -> [NSManagedObject]{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entityStr = modified ? "ResultsModified" : "Results"
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityStr)
        
        var results:[NSManagedObject] = []
        
        do {
            results = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return results
    }
    
    func toString() -> String{
        let results = fetchAnswer(modified: false)
        let resultsMod = fetchAnswer(modified: true)
        
        var out:String = ""
        
        
        let keyList = ["questionId","correctAnswer","submittedAnswer","orderInGame","correctAnswer","correct","timeElapsed","phoneId","model","brightness"]
        
        let keyListMod = ["questionId","correctAnswer","submittedAnswer","orderInGame","correctAnswer","correct","timeElapsed","phoneId","model","brightness","numberColorR","numberColorG","numberColorB","backgroundColorR","backgroundColorG","backgroundColorB"]
        
        for item in results{
            for key in keyList{
                out += "\(item.value(forKey: key)!),"
            }
        }
        
        for item in resultsMod{
            for key in keyListMod{
                out += "\(item.value(forKey: key)!),"
            }
        }
        
        return out
    }
    
}
