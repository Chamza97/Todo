//
//  CategoryViewController.swift
//  Todoey
//
//  Created by admin on 15/02/2019.
//  Copyright © 2019 Hamza Chaouachi. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    

    //Mark: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //Mark: - TableView Manipulation Methods
    
    func saveCategory(){
        
        do{
            try context.save()
            
        }catch{
            print("Error save context , \(error)")
        }
    }
    
    func loadCategory(with request : NSFetchRequest<Category>  = Category.fetchRequest() ){
        // let request :  NSFetchRequest<Item> = Item.fetchRequest()
        do{
          categoryArray =  try context.fetch(request)
        }catch{
            
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    

    //Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory =   categoryArray[indexPath.row]
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category",message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
