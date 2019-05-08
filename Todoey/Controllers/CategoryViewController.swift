//
//  CategoryViewController.swift
//  Todoey
//
//  Created by michael kibler on 5/8/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        
        

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
    
    

    
    
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
        
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        //all of the code below is needed in order the the above code to execute on the simulator
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create New Category"
            textField = alertTextFiled
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
       
    }
        
    func saveCategory() {
        
        do {
            
            try context.save()
            
            } catch {
            
            print("There was an error saving your category, \(error)")
            
            }
            
            tableView.reloadData()
        
        }
    
    func loadCategories (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            categoryArray = try context.fetch(request)
            
            
        } catch {
            
            print("there was an error, \(error)")
            
            
        }
        
        
        
    }
    
    
    
    
    
    }

    
    
    
    
    
    


