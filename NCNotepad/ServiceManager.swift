//
//  ServiceManager.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 11/02/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import Foundation

class ServiceManager: NSObject {
    
    class var instance: ServiceManager {
        struct Static {
            static let instance: ServiceManager = ServiceManager()
        }
        return Static.instance
    }
    
    //MARK: DATE FORMATTER 
    
    static func convertDateFormater(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants_Editor.DEFAULT_DATE_FORMATTER
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    //MARK: NSUSERDEAULT GETTER SETTER
    
    func getNotesDataSourceFromUserDefaults() {
        var decoded:Data?
        decoded = UserDefaults.standard.object(forKey: Constants_Application.USERDEFAULT_KEY) as! Data?
        if decoded != nil {
            NotesIndex.sharedInstance.initializeNotesDataSource(notesData: NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Notes])
        }
    }
    
    func saveNotesDataSourceToUserDefaults(){
        let notesArray = NotesIndex.sharedInstance.notesDataSource
        if notesArray.count > 0 {
            let encodedData:Data = NSKeyedArchiver.archivedData(withRootObject: notesArray)
            UserDefaults.standard.set(encodedData, forKey: Constants_Application.USERDEFAULT_KEY)
        }else{
            UserDefaults.standard.removeObject(forKey: Constants_Application.USERDEFAULT_KEY)
        }
        UserDefaults.standard.synchronize()
    }
}
