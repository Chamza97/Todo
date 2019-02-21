//
//  CategoryViewController.swift
//  Todoey
//
//  Created by admin on 15/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController:   SwipeTableViewController {
   
    
      let realm = try! Realm()
    
   
    var  categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    

    //Mark: - TableView Datasource Methods
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet"
        cell.backgroundColor = UIColor(hexString: (categoryArray?[indexPath.row].color)!)
        print(categoryArray?[indexPath.row].color )
        return cell
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
            }catch{
                   print("Error deleting category , \(error)")
                }
    
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoryArray?.count ?? 1
    }
    //Mark: - TableView Manipulation Methods
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error save category , \(error)")
        }
    }
    
    func loadCategory(){
        // let request :  NSFetchRequest<Item> = Item.fetchRequest()
     categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    

    //Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory =   categoryArray?[indexPath.row]
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category",message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            
            self.tableView.reloadData()
        }
            alert.addTextField(configurationHandler: { (alertTextField) in
             alertTextField.placeholder = "add new Category"
                textField = alertTextField
            })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

