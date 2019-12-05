//
//  ItemTableViewController.swift
//  testingRealm
//
//  Created by Nauman Bajwa on 12/3/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
     @IBOutlet var searchBarclicked: UITableView!
    
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems?.count ??  1
    }

    
        // MARK: - Realm methdods
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        if  let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error writing into realm at did select row stage. \(error)")
            }
            
        }
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
    }
 

    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert  = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                  
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textfield.text!
                    currentCategory.items.append(newItem)
                          }
                }catch {
                    print("Error saving items into realm. \(error)")
                }

            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new item here"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ItemTableViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        print("Hello world")
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
