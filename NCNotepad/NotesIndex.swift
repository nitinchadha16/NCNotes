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
    
    func initializeNotesDataSource(notesData:[Note]) {
        notesDataSource.setArray(notesData)
    }
    
    func addNoteToDataSource(note:Note){
        notesDataSource.add(note)
    }
    
    func removeNoteAtIndex(index: NSInteger){
        notesDataSource.removeObject(at: index)
    }
    
    func replaceNoteWithOtherNote(replacedNote: Note, newNote:Note){
        notesDataSource.replaceObject(at: notesDataSource.index(of: replacedNote), with: newNote)
    }
}
