//
//  ServiceManager.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 11/02/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import Foundation

class ServiceManager: NSObject {
    
    func convertDateFormater(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
}
