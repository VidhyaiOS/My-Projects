//
//  Timings+CoreDataProperties.swift
//  Time_App
//
//  Created by Apple on 28/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import CoreData


extension Timings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timings> {
        return NSFetchRequest<Timings>(entityName: "Timings");
    }

    @NSManaged public var breakTiming: NSObject?
    @NSManaged public var date: String?
    @NSManaged public var startTiming: String?
    @NSManaged public var stopTiming: String?
    @NSManaged public var totalTiming: String?
    @NSManaged public var sno: String?

}
