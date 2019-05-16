//
//  CategoryViewController.swift
//  Todoey
//
//  Created by michael kibler on 5/8/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

    
    let realm = try! Realm() //codesmell
    
    
    var categoryArray: Results<Category>?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        
//        tableView.rowHeight = 80

    }
    
    //Mark: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1 //nil Coalescing Operator
        
    }
    
    //from cocoapods website for Swipe cell Kit
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
    
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        

        
    return cell
       
       
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
        
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
    
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    
                    self.realm.delete(categoryForDeletion)
                }
            
            } catch{
                print("error,\(error)")
            }
            
        }
    }
    
    
    //Mark - Add button Functionality
    
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
    
            self.save(category: newCategory)
            
        }
        
        //all of the code below is needed in order the the above code to execute on the simulator
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create New Category"
            textField = alertTextFiled
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
       
    }
        
    func save(category:Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
            } catch {
            
            print("There was an error saving your category, \(error)")
            
            }
            
            tableView.reloadData()
        
        }
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        
        
        tableView.reloadData()
        
    }
    

    
    

}


 
    

    
    



