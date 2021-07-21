//
//  Config+CoreDataClass.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 17/07/21.
//
//

import Foundation
import CoreData

@objc(Config)
public class Config: NSManagedObject {

    func getQuoteFontName() -> String {
        
        if self.quoteFontName == nil {
            
            return "American Typewriter"
        }
        
        return self.quoteFontName!
    }
}
