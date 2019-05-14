//
//  CategoryViewController.swift
//  Todoey
//
//  Created by michael kibler on 5/8/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    
    let realm = try! Realm() //codesmell
    
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        loadCategories()
        
        

    }
    
    //Mark: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        print(categoryArray)
        
    return cell
       
       
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
        
    }
    

    //Mark - Add button Functionality
    
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
        
            self.categoryArray.append(newCategory)
            
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
                realm.add(categoryArray)
            }
            
            } catch {
            
            print("There was an error saving your category, \(error)")
            
            }
            
            tableView.reloadData()
        
        }
    
//    func loadCategories()
    
//        do {
//
//            categoryArray = try context.fetch(request)
//
//
//        } catch {
//
//            print("there was an error, \(error)")
//
//
//        }
//
//
//
//    }

    
}

    
    
    
    
    
    


