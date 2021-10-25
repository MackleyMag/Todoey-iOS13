//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mackley Magalhães da Silva on 21/09/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        
        return cell
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView DataManipulation Methods
    func save(category: Category){
        do{
            
            try realm.write({
                realm.add(category)
            })
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)

        self.tableView.reloadData()
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
