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


class ResultData: NSObject, NSCoding {
    
    
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
}

/*class ResultData{
    
    func saveAnswer(_ q:Int, answer:Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Results",
                                                        in:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)

        person.setValue(answer, forKey: "a\(q+1)")
        
        do {
            print("AJGDJGDAGDGAKJDKAJDKHA")
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
>>>>>>> CoreData
    }
    
    func fetchAnswer(_ q:Int) -> Int{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Results")
        
        do {
            var people = try managedContext.fetch(fetchRequest)
            return people.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
}*/
