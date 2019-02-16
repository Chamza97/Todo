//
//  ViewController.swift
//  Todoey
//
//  Created by admin on 12/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    
    var  toDoItems :Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for : .documentDirectory, in : .userDomainMask).first?.appendingPathComponent("Items.plist")
    // let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       
         loadItems()
   
        
        
        
        // if let items = defaults.array(forKey: "TodoListArray") as? [String]{
           // itemArray = items

    }

//MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
       cell.textLabel?.text = toDoItems?[indexPath.row].title ?? "No items added yet"
if let item = toDoItems?[indexPath.row]{

            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = " no items item added"
        }

        
        return cell
       
        
    }
     //MARK - TableView Delegate Maethods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        if let item = toDoItems?[indexPath.row]  {
            do{
                try realm.write {
                    item.done = !item.done
                    
                }
            }catch{
                print("Error saving done status \(error)")
            }
            tableView.reloadData()
        }
       
        tableView.reloadData()
        
    }
    //MARK add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item",message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            // what will happen once the user clicks the Add Item Button
            (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                    
                    let addedItem = Item()
                    addedItem.title = textField.text!
                    addedItem.done = false
                        
                        addedItem.date = Date()
                    currentCategory.items.append(addedItem)
                }
                }catch{
                    print("Error save th new Item , \(error)")
                }
            }
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
    // MARK - MODEL Manupulation Methods
    
    
    func loadItems(){
       // let request :  NSFetchRequest<Item> = Item.fetchRequest()
       toDoItems = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
       tableView.reloadData()
            }
   
    }
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
     
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

        



