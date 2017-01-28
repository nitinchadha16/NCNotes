//
//  Notes.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/28/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class Notes: NSObject,NSCoding {
    let id:             NSInteger!
    let title:          String!
    let details:        String!
    let sortOrder:      NSInteger!
    let date:           Date!
    let time:           Date!
    let favoriteTag:    Bool!
    
    init(id: NSInteger, title: String, details: String, sortOrder: NSInteger,date: Date, time: Date, favoriteTag: Bool) {
    
        self.id = id
        self.title = title
        self.details = details
        self.sortOrder = sortOrder
        self.date = date
        self.time = time
        self.favoriteTag = favoriteTag
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PROPERTY_KEY.id)
        let title = aDecoder.decodeObject(forKey: PROPERTY_KEY.title) as! String
        let details = aDecoder.decodeObject(forKey: PROPERTY_KEY.details) as! String
        let sortOrder = aDecoder.decodeInteger(forKey: PROPERTY_KEY.sortOrder)
        let date = aDecoder.decodeObject(forKey: PROPERTY_KEY.date) as! Date
        let time = aDecoder.decodeObject(forKey: PROPERTY_KEY.time) as! Date
        let favoriteTag = aDecoder.decodeBool(forKey: PROPERTY_KEY.favoriteTag)
    
        self.init(id: id, title: title, details: details, sortOrder: sortOrder,date: date, time: time, favoriteTag: favoriteTag)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id!, forKey: PROPERTY_KEY.id)
        aCoder.encode(title!, forKey: PROPERTY_KEY.title)
        aCoder.encode(details!, forKey: PROPERTY_KEY.details)
        aCoder.encode(sortOrder!, forKey: PROPERTY_KEY.sortOrder)
        aCoder.encode(date!, forKey: PROPERTY_KEY.date)
        aCoder.encode(time!, forKey: PROPERTY_KEY.time)
        aCoder.encode(favoriteTag!, forKey: PROPERTY_KEY.favoriteTag)
    }
    
}


