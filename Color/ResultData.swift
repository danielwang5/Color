//
//  ResultData.swift
//  Color
//
//  Created by James Wang on 1/23/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class ResultData{
    
    func saveAnswer(q:Int, answer:Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Results",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)

        person.setValue(answer, forKey: "a\(q+1)")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchAnswer(q:Int) -> Int{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /*let entity =  NSEntityDescription.entityForName("Results",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        return person.valueForKey("a\(q+1)") as! Int*/
        
        let fetchRequest = NSFetchRequest(entityName: "Results")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            print(results)
            return results.first as! Int//results[q] as! Int
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return 0
        }
        return 0
    }
}