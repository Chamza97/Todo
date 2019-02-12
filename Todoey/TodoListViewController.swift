//
//  ViewController.swift
//  Todoey
//
//  Created by admin on 12/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    let itemArray = ["find mike", "Buy Eggos","destory demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

//MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
       
        
    }
     //MARK - TableView Delegate Maethods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray [indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType ==  .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType =  .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType =  .checkmark
        }
        
    }
}

