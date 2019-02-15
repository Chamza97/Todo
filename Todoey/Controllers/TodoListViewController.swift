//
//  ViewController.swift
//  Todoey
//
//  Created by admin on 12/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  itemArray = [Item]()
    
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
        
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
       
         // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItems()
        tableView.reloadData()
        
    }
    //MARK add items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item",message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            // what will happen once the user clicks the Add Item Button
            (action) in
            
          
            let addedItem = Item(context: self.context)
            addedItem.title = textField.text!
            addedItem.done = false
            addedItem.parentCategory = self.selectedCategory
            self.itemArray.append(addedItem)
            
           self.saveItems()
           
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
    
    func saveItems(){
        
        do{
            try context.save()
          
        }catch{
            print("Error save context , \(error)")
        }
    }
    func loadItems(with request : NSFetchRequest<Item>  = Item.fetchRequest() , predicate: NSPredicate? = nil ){
       // let request :  NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate  = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
     
        do{
            itemArray =  try context.fetch(request)
        }catch{
            
            print("Error fetching data from context \(error)")
        }
       tableView.reloadData()
            }
   
    }
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
      request.predicate   = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with : request)
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
        
        



