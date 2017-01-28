//
//  Notes.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/28/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class Notes: NSObject {
    var id:             NSInteger?
    var title:          String?
    var details:        String?
    var sortOrder:      NSInteger?
    var date:           Date?
    var time:           Date?
    var favoriteTag:    Bool?
    
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
        let id = aDecoder.decodeInteger(forKey: "id")
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let details = aDecoder.decodeObject(forKey: "details") as! String
        let sortOrder = aDecoder.decodeInteger(forKey: "sortOrder")
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let time = aDecoder.decodeObject(forKey: "time") as! Date
        let favoriteTag = aDecoder.decodeBool(forKey: "favoriteTag") 
    
        self.init(id: id, title: title, details: details, sortOrder: sortOrder,date: date, time: time, favoriteTag: favoriteTag)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(details, forKey: "details")
        aCoder.encode(sortOrder, forKey: "sortOrder")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(favoriteTag, forKey: "favoriteTagz")
    }
 
}


