//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Omar Khalid on 27/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryList = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { actionTextField in
            actionTextField.placeholder = "e.g. Shopping List"
            textField = actionTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryList.append(newCategory)
            self.saveData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryList[indexPath.row]
        }
        
    }
    
}


 //MARK: - Data Manipulation

extension CategoryViewController{
    
    func loadData(using request : NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryList = try context.fetch(request)
            print("Fetched \(categoryList.count) items successfully!")
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
            print("Save successful!")
        } catch {
            print("Error saving data: \(error)")
        }
        tableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        return cell
    }
}


//MARK: - UITableViewDelegate

extension CategoryViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
