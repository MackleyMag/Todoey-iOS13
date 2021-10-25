//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //codigo de update
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write({
                    item.done = !item.done
                })
            }catch{
                print("Error savind done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
//        sempre chamar a chamada de delecao do banco primeiro
//        context.delete(itemArray[indexPath.row])
//        para depois remover do array
//        itemArray.remove(at: indexPath.row)
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
////        sempre chame a função de salvamento
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK: - Add New Items

    @IBAction func addButtunPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()


        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
            
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulations Methods
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods
//extension TodoListViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
