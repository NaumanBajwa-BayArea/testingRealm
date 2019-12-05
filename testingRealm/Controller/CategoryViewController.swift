//
//  ViewController.swift
//  testingRealm
//
//  Created by Nauman Bajwa on 12/2/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    
        // MARK: - AddButtonPressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert   = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory  = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category here"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
        // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemTableViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
        // MARK: - Data manipulation methods
    
    func loadCategories(){
          categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    func saveCategories(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving category. \(error)")
        }
        tableView.reloadData()
    }
    
    
    

}

