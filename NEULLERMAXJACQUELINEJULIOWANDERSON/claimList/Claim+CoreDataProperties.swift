//
//  Claim+CoreDataProperties.swift
//  NEULLERMAXJACQUELINEJULIOWANDERSON
//
//  Created by Neuler Pereira on 23/08/22.
//
//

import Foundation
import CoreData


extension Claim {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Claim> {
        return NSFetchRequest<Claim>(entityName: "Claim")
    }

    @NSManaged public var nameClaim: String?
    @NSManaged public var location: String?
    @NSManaged public var descriptionClaim: String?
    @NSManaged public var insertDate: String?

}

extension Claim : Identifiable {

}
