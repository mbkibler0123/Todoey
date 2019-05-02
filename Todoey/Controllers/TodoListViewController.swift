//
//  ViewController.swift
//  Todoey
//
//  Created by michael kibler on 4/24/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit

//because we inherited the UITableViewController we do not need to set up any IPBOUTlets
class TodoListViewController: UITableViewController {

    //these are the TODOS within an array
    var itemArray = [Item]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print(dataFilePath)
        
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
            
            
            let newitem = Item()
            newitem.title = textField.text!
            
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
        
        let encoder = PropertyListEncoder()
        
        
        do {
            let data = try encoder.encode(itemArray)
            
            try data.write(to: dataFilePath!) //datafilepath must be declared at the global level to tap into it here
            
        } catch {
            print("Error encoding item array, \(error)")
            
        }
        tableView.reloadData()
        
    }
    

    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            
            catch{
                print("error decoding Item Array, \(error)")
            }
        }
        
    }
    
    
    
}

