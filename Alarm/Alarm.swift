//
//  Alarm.swift
//  Alarm
//
//  Created by Ross McIlwaine on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Alarm: Equatable {
    
    private let kFireTimeFromMidnight = "fireTimeFromMidnight"
    private let kName = "name"
    private let kEnabled = "enabled"
    private let kUUID = "UUID"
    
    var fireTimeFromMidnight: NSTimeInterval
    var name: String
    var enabled: Bool
    //unique alarm identifier 
    let uuid: String
    
    // MARK: Computed Properties
    var fireDate: NSDate? {
        
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {
            return nil
        }
        let fireDateFromThisMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: thisMorningAtMidnight)
        return fireDateFromThisMorning
    }
    
    var fireTimeAsString: String {
        
        let fireTimeFromMidnight = Int(self.fireTimeFromMidnight)
        let hours = fireTimeFromMidnight/60/60
        let minutes = (fireTimeFromMidnight - (hours*60*60))/60
        
        // handles 24hr clock model
        if hours >= 13 {
            return String(format: "%2d:%02d PM", arguments: [hours - 12, minutes])
        } else if hours >= 12 {
            return String(format: "%2d:%02d PM", arguments: [hours, minutes])
        } else {
            return String(format: "%2d:%02d AM", arguments: [hours, minutes])
        }
    }
    
    // MARK: Initialize 
    
    init(fireTimeFromMidnight: NSTimeInterval, name: String, enabled: Bool = true, uuid: String = NSUUID().UUIDString) {
        
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
}

func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}