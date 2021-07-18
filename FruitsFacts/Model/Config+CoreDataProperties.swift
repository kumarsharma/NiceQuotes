//
//  Config+CoreDataProperties.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 17/07/21.
//
//

import Foundation
import CoreData

extension Config {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Config> {
        return NSFetchRequest<Config>(entityName: "Config")
    }

    @NSManaged public var autoPlay: Bool
    @NSManaged public var backgroundMode: String?
    @NSManaged public var bgColorCode: String?
    @NSManaged public var bgImageFileName: String?
    @NSManaged public var enableAudio: Bool
    @NSManaged public var audioFileName: String?
    @NSManaged public var textColorCode: String?
}

extension Config: Identifiable {

}
