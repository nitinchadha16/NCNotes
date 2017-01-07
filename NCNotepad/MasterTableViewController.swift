//
//  MasterTableViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

protocol FruitSelectionDelegate: class {
    func fruitSelected(newFruit: String)
}

class MasterTableViewController: BaseViewController,UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notesList: UITableView!
    
    weak var delegate: FruitSelectionDelegate?
    weak var currentSplitViewController: BaseSplitViewController?
    @IBOutlet weak var separatorView: UIView!
    let dataSource = ["Mangoes","Apple","Orange","Watermelon"]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesList.register(UITableViewCell.self, forCellReuseIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER)
        notesList.dataSource = self
        notesList.delegate = self
        notesList.backgroundColor = Colors.APP_BACKGROUND_COLOR
        notesList.separatorColor = Colors.NAVIGATION_BAR_COLOR
        
        separatorView.backgroundColor = UIDevice.current.userInterfaceIdiom == .phone ? UIColor.clear :  Colors.NAVIGATION_BAR_COLOR
        currentSplitViewController?.delegate = self
        self.title = Constants.APPLICATION_TITLE
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER, for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER )
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.backgroundColor = Colors.APP_BACKGROUND_COLOR
        cell?.selectionStyle = .none
        return cell!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.fruitSelected(newFruit: dataSource[indexPath.row])
        if UIDevice.current.userInterfaceIdiom == .phone {
            currentSplitViewController?.showDetailViewController((delegate as? DetailedViewController)!, sender: nil)
        }else{
            currentSplitViewController?.showDetailViewController(currentSplitViewController?.viewControllers.last as! UINavigationController, sender: nil)
        }
    }
}
