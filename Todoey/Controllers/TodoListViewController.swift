//
//  ViewController.swift
//  Todoey
//
//  Created by admin on 12/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var  itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        for _ in 1...20 {
            let newItem = Item()
            
            newItem.title = "new Item"
            itemArray.append(newItem)
        }
        
        
        // if let items = defaults.array(forKey: "TodoListArray") as? [String]{
           // itemArray = items

    }

//MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
       
        
    }
     //MARK - TableView Delegate Maethods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray [indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
       
        tableView.reloadData()
        
    }
    //MARK add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item",message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            // what will happen once the user clicks the Add Item Button
            (action) in
            let addedItem = Item()
            addedItem.title = textField.text!
            self.itemArray.append(addedItem)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
        }
            alert.addTextField(configurationHandler: { (alertTextField) in
                alertTextField.placeholder = "Create new item"
             textField = alertTextField
            })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

