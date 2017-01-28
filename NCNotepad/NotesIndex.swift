//
//  NotesIndex.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/28/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class NotesIndex: NSObject {
    
    let notesDataSource = NSMutableArray()

    class var sharedInstance: NotesIndex {
        struct Static {
            static let instance: NotesIndex = NotesIndex()
        }
        return Static.instance
    }
    
    func addNoteToDataSource(note:Notes){
        notesDataSource.add(note)
    }
    
    func removeNoteAtIndex(index: NSInteger){
        notesDataSource.removeObject(at: index)
    }
    
    func replaceNoteWithOtherNote(replacedNote: Notes, newNote:Notes){
        notesDataSource.replaceObject(at: notesDataSource.index(of: replacedNote), with: newNote)
    }
    
    //MARK: NSUSERDEAULT GETTER SETTER
    
    func getNotesDataSourceFromUserDefaults(){
        var decoded:Data?
        decoded = UserDefaults.standard.object(forKey: "NCNOTEPAD") as! Data?
        if decoded != nil {
            let notes = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Notes]
            notesDataSource.addObjects(from: notes)
        }
    }
    
    func saveNotesDataSourceToUserDefaults(){
        if notesDataSource.count > 0 {
            let encodedData:Data = NSKeyedArchiver.archivedData(withRootObject: notesDataSource)
            UserDefaults.standard.set(encodedData, forKey: "NCNOTEPAD")
        }else{
            UserDefaults.standard.removeObject(forKey: "NCNOTEPAD")
        }
        UserDefaults.standard.synchronize()
    }
}
