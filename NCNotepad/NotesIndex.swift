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
    
    func initializeNotesDataSource(notesData:[Notes]) {
        notesDataSource.setArray(notesData)
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
}
