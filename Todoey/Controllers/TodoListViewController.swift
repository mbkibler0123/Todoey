//
//  ViewController.swift
//  Todoey
//
//  Created by michael kibler on 4/24/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import RealmSwift
//because we inherited the UITableViewController we do not need to set up any IPBOUTlets
class TodoListViewController: UITableViewController {

    
   
    
    //these are the TODOS within an array
    var todoItems: Results <Item>?
    let realm = try! Realm()
    let date = Date()
    var selectedCategory : Category? {
        
        didSet {
            loadItems()
        }
        
        
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

    
    
    // Mark -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
       
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            
            //Ternaary operator ===>
            //value = condition ? valueIfTrue : valueIfFalse
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            
            cell.textLabel?.text = "No items added"
            
        }
    
        return cell
        
    }
    
    // Mark - Tableview Delegate Methods
    
   //this method will allow you to print whatever cell you click on in thi sumulator print to the debug console.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        updating data using realm
        if let item = todoItems?[indexPath.row]{

            do{
            try realm.write {
                item.done = !item.done // use this line of code to update your items within the simulator
                
//                realm.delete(item) use this line of code to delete items within the simlator
            }
        }catch {
            print("error updating, \(error)")


            }
        }
        
        
        
        
        
        
        
        
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    //MARK - Add New Items
    
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //this has the entire scope of the entire method
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks the add button on the ui alert
            if let currentCategory = self.selectedCategory{
             
                do{
                
                try self.realm.write {
                    let newitem = Item()
                    newitem.title = textField.text!
                    newitem.dateCreated = Date()
                    currentCategory.items.append(newitem)
                }
                
                
            } catch {
                print("error saving new Items, \(error)")
            }
        }
                self.tableView.reloadData()
                
                
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    
   
    

    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
    tableView.reloadData()

    }
    
    

}
//Mark: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd]%@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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


