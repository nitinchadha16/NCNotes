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

class MasterTableViewController: UITableViewController,UISplitViewControllerDelegate {

    weak var delegate: FruitSelectionDelegate?
    weak var currentSplitViewController: BaseViewController?
    
    let dataSource = ["Mangoes","Apple","Orange","Watermelon"]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        currentSplitViewController?.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.fruitSelected(newFruit: dataSource[indexPath.row])
        if UIDevice.current.userInterfaceIdiom == .phone {
            currentSplitViewController?.showDetailViewController((delegate as? DetailedViewController)!, sender: nil)
        }else{
           currentSplitViewController?.showDetailViewController(currentSplitViewController?.viewControllers.last as! UINavigationController, sender: nil)
        }
    }
}
