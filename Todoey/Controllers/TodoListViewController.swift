//
//  ViewController.swift
//  Todoey
//
//  Created by michael kibler on 4/24/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import CoreData
//because we inherited the UITableViewController we do not need to set up any IPBOUTlets
class TodoListViewController: UITableViewController {

    //these are the TODOS within an array
    var itemArray = [Item]()

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgons"
//        itemArray.append(newItem3)
        
        
        
        loadItems()
        
    }

    
    
    // Mark -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
       
        let item = itemArray[indexPath.row]
    
        cell.textLabel?.text = item.title
        
        
        //Ternaary operator ===>
        //value = condition ? valueIfTrue : valueIfFalse 
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//
//        }

        return cell
        
    }
    
    // Mark - Tableview Delegate Methods
    
   //this method will allow you to print whatever cell you click on in thi sumulator print to the debug console.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       //the above line does exactly the same as the bottom if statement
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
    
    

        saveitems()

        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    //MARK - Add New Items
    
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //this has the entire scope of the entire method
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks the add button on the ui alert
            
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            
            self.itemArray.append(newitem) //force unwrap because it will never equal nil.
        
          
            self.saveitems()
            
             //needed to update the new array and will populate the new tableview
            
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveitems() {
        do {
           try context.save()
        } catch {
        print("error saving context \(error)")
            
        }
        tableView.reloadData()
        
    }
    

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {


        do {
        itemArray = try context.fetch(request)
    } catch {
        print("error fetching data from context \(error)")

    }
    
    
    
    }
    
    
}

//Mark: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS [cd]%@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        loadItems(with: request)
        
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
