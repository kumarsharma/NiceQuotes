//
//  KDCoreDataCoordinator.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 09/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

let sharedCoredataCoordinator = KDCoreDataCoordinator ()

class KDCoreDataCoordinator: NSObject {

    var allQuotes : NSArray?
    
    override init() {
            
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    func fetchQuoteCount() -> NSInteger {
        
        var count : NSInteger = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fact")
        
        do{
            
            try count = self.persistentContainer.viewContext.count(for: fetchRequest)
        }
        catch let error as NSError{
            
            print(error.description)
        }
        
        return count
    }
    
    func fetchQuote(atIndex:NSInteger) -> Fact {
        
        if(allQuotes == nil){
        
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fact")
            do{
                
                allQuotes = try self.persistentContainer.viewContext.fetch(fetchRequest) as NSArray
                
            }catch _ as NSError{
                
            }
        }
        
        let index = atIndex >= allQuotes!.count ? allQuotes!.count-1 : atIndex
        
        return allQuotes?.object(at: index) as! Fact
    }
    
    func storeInitialQuotesIfNeeded() {
        
        
        if(self.fetchQuoteCount()>0){
         
            return
        }
        
        var data : Data?
        
        do{
            
            data = try Data(contentsOf: Bundle.main.url(forResource: "Sample_Quotes", withExtension: "txt")!)
        }catch let error as NSError{
            
            print("Could not load sample file: \(error.userInfo)")
            return
        }

        var quoteDict : Dictionary<String, Any>?
        
        do{
            
            quoteDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            
        }
        catch let error as NSError{
            
            print("error in parsing sample quotes \(error.userInfo)")
        }
        
        let quotes = quoteDict?.values.first
        
        if(quotes != nil){
            
            for quote_ar in quotes as! Array<NSDictionary>{

                _ = self.createQuoteFrom(dictionary: quote_ar)
                
            }
            
            do{
            
                try self.persistentContainer.viewContext.save()
            }catch _ as NSError{
                
            }
        }
    }
    
    func createQuoteFrom(dictionary: NSDictionary) -> Fact {
        
        var aFact : Fact!
        
        let quoteEntity = NSEntityDescription.entity(forEntityName: "Fact", in: self.persistentContainer.viewContext)
        aFact = NSManagedObject(entity: quoteEntity!, insertInto: self.persistentContainer.viewContext) as? Fact
        aFact.quoteId = Date().description
        aFact.quoteText = dictionary.value(forKey: "Quote") as? String
        aFact.quoteBy = dictionary.value(forKey: "By") as? String
        
        return aFact
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {

        let container = NSPersistentCloudKitContainer(name: "FruitsFacts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
 
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
