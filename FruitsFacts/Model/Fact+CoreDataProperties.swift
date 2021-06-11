//
//  Fact+CoreDataProperties.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//
//

import Foundation
import CoreData

extension Fact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fact> {
        return NSFetchRequest<Fact>(entityName: "Fact")
    }

    @NSManaged public var quoteId: String?
    @NSManaged public var quoteText: String?
    @NSManaged public var quoteBy: String?
    @NSManaged public var reference: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isLiked: Bool
    @NSManaged public var isUnliked: Bool
    
}

extension Fact: Identifiable {

}
