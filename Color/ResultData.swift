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


/*class ResultData: NSObject, NSCoding {
    
    
    //MARK: Properties
    
    var ans: [String: Int] = ["a0":0,"a1":0,"a2":0,"a3":0,"a4":0]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("answers")
    
    
    struct PropertyKey {
        static let ans = "ans"
    }
    
    
    //MARK: Initialization
    
    init?(answer: Int) {
        super.init()
        
        self.ans = loadAnswers()!
        
        // The name must not be empty
        if self.ans.isEmpty{
            self.ans = ["a0":0,"a1":0,"a2":0,"a3":0,"a4":0]
        }
        
        // The rating must be between 0 and 5 inclusive??
        // Initialize stored properties.
        
        
        
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ans, forKey: PropertyKey.ans)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.ans) as? [String:Int] else {
            return nil
        }
        
        // Must call designated initializer.
        self.init(answer:0)
        
    }
    
    func saveAnswers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.ans, toFile: ResultData.ArchiveURL.path)
        if(isSuccessfulSave){
            print("YYYYYYEEEEESSSS!!!!!")
        }
    }
    
    func loadAnswers() -> [String:Int]?  {
        print("LOADED!")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ResultData.ArchiveURL.path) as? [String:Int]
    }
}*/

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
            
            /*o += (item.value(forKey: "correctAnswer")! as! String) + ","
            o += (item.value(forKey: "submittedAnswer")! as! String) + ","
            o += (item.value(forKey: "orderInGame")! as! String) + ","
            o += (item.value(forKey: "correctAnswer")! as! String) + ","
            o += (item.value(forKey: "correct")! as! String) + ","
            o += (item.value(forKey: "timeElapsed")! as! String) + ","
            o += (item.value(forKey: "phoneId")! as! String) + ","
            o += (item.value(forKey: "model")! as! String) + ","
            o += (item.value(forKey: "brightness")! as! String) + "\n"*/
        }
        
        return out
    }
    
}
