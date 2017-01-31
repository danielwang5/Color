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
    func saveAnswer(question:Int, typed: Int) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Results", inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
        person.setValue(typed, forKey: "answer\(question)")
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchAnswer(question: Int) -> Int{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let employeesFetch = NSFetchRequest(entityName: "Results")
        
        do {
            let res = try managedContext.executeFetchRequest(employeesFetch) as! [AnyObject]
            return res.count //res[question] as! Int
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return 0
    }
    
}