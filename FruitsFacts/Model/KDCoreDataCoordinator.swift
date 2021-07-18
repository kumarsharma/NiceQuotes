//
//  KDCoreDataCoordinator.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 09/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

let sharedCoredataCoordinator = KDCoreDataCoordinator()
var defaultConfig: Config?

class KDCoreDataCoordinator: NSObject {

    var allQuotes: NSArray?
    
    override init() {
            
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    func fetchQuoteCount() -> NSInteger {
        
        var count: NSInteger = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fact")
        
        do {
            
            try count = self.persistentContainer.viewContext.count(for: fetchRequest)
        } catch let error as NSError {
            
            print(error.description)
        }
        
        return count
    }
    
    func fetchConfigCount() -> NSInteger {
        
        var count: NSInteger = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Config")
        
        do {
            
            try count = self.persistentContainer.viewContext.count(for: fetchRequest)
        } catch let error as NSError {
            
            print(error.description)
        }
        
        return count
    }
    
    func fetchDefaultConfig() -> Config {
        
        var allObjs: [NSManagedObject]?
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Config")
        do {
            
            allObjs = try self.persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch _ as NSError {
            
        }
                
        return (allObjs?.first as? Config)!
    }
    
    func fetchQuote(atIndex: NSInteger) -> Fact {
        
        if allQuotes == nil {
        
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fact")
            do {
                
                allQuotes = try self.persistentContainer.viewContext.fetch(fetchRequest) as NSArray
                
            } catch _ as NSError {
                
            }
        }
        
        let index = atIndex >= allQuotes!.count ? allQuotes!.count-1 : atIndex
        
        return (allQuotes?.object(at: index) as? Fact)!
    }
    
    func factFetchedResultController() -> NSFetchedResultsController<Fact> {
        
        let fetchRequest = NSFetchRequest<Fact>(entityName: "Fact")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "quoteText", ascending: true)]
        let context = self.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try frc.performFetch()
        } catch _ as NSError {
            
        }
        
        return frc
    }
    
    func storeInitialQuotesIfNeeded() {
        
        if self.fetchConfigCount() <= 0 {
            
            defaultConfig = self.addDefaultConfig()
        } else {
            
            defaultConfig = self.fetchDefaultConfig()
        }
        
        if self.fetchQuoteCount()>0 {
         
            return
        }
        
        var data: Data?
        
        do {
            
            data = try Data(contentsOf: Bundle.main.url(forResource: "Sample_Quotes", withExtension: "txt")!)
        } catch let error as NSError {
            
            print("Could not load sample file: \(error.userInfo)")
            return
        }

        var quoteDict: [String: Any]?
        
        do {
            
            quoteDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
        } catch let error as NSError {
            
            print("error in parsing sample quotes \(error.userInfo)")
        }
        
        let quotes = quoteDict?.values.first
        
        if quotes != nil {
            
            for quoteAr in (quotes as? [NSDictionary])! {

                _ = self.createQuoteFrom(dictionary: quoteAr)
            }
            
            do {
            
                try self.persistentContainer.viewContext.save()
            } catch _ as NSError {
                
            }
        }
    }
    
    func createQuoteFrom(dictionary: NSDictionary) -> Fact {
        
        let text = dictionary.value(forKey: "Quote") as? String
        let author = dictionary.value(forKey: "By") as? String
        return self.addQuote(text: text!, author: author!)
    }
    
    func addQuote(text: String, author: String) -> Fact {
        
        var aFact: Fact!
        let quoteEntity = NSEntityDescription.entity(forEntityName: "Fact", in: self.persistentContainer.viewContext)
        aFact = NSManagedObject(entity: quoteEntity!, insertInto: self.persistentContainer.viewContext) as? Fact
        aFact.quoteId = Date().description
        aFact.quoteText = text
        aFact.quoteBy = author
        
        return aFact
    }
    
    func addDefaultConfig() -> Config {
        
        var config: Config!
        let quoteEntity = NSEntityDescription.entity(forEntityName: "Config", in: self.persistentContainer.viewContext)
        config = NSManagedObject(entity: quoteEntity!, insertInto: self.persistentContainer.viewContext) as? Config
        config.backgroundMode = "Color"
        config.bgColorCode = "9bff38"
        config.audioFileName = "sound1"
        return config
    }
    
    func delete(quote: Fact) {
        
        self.persistentContainer.viewContext.delete(quote)
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {

        let container = NSPersistentCloudKitContainer(name: "FruitsFacts")
        container.loadPersistentStores(completionHandler: { (_, error) in
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
