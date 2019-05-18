//
//  ViewController.swift
//  Todoey
//
//  Created by michael kibler on 4/24/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//because we inherited the UITableViewController we do not need to set up any IPBOUTlets
class TodoListViewController: SwipeTableViewController {

    
   
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    
        tableView.separatorStyle = .none
        
        
        
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        guard let colourHex = selectedCategory?.colour else{fatalError()}
            
            
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("nav controller does not exist. ")}
            
        guard let navBarColour = UIColor(hexString: colourHex) else{fatalError()}
                
                navBar.barTintColor = navBarColour
                
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
                
                searchBar.barTintColor = navBarColour
                
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString: "1D9BF6") else{fatalError()}
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    
    
    
    // Mark -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
       
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
               
                
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
//            print("version 1:, \(CGFloat(indexPath.row / todoItems!.count))")
//            print("version 2:, \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            
            
            
            
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
    
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let cellForDeletion = self.todoItems?[indexPath.row]{
            
            
            do{
            try realm.write {
                realm.delete(cellForDeletion)
            }
            }catch{
                print("error deleting Item,\(error)")
            }
        }
        
        
        
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


