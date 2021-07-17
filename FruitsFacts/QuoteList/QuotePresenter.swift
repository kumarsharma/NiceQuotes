//
//  QuotePresenter.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 28/06/21.
//

import UIKit
import CoreData

class QuotePresenter: NSObject, UITableViewDataSource {
  
    weak var tableView: UITableView?
    var frc: NSFetchedResultsController<Fact>?
    weak var controller: UIViewController?
    
    init(tableview: UITableView?) {
        
        super.init()
        self.tableView = tableview
        self.frc = sharedCoredataCoordinator.factFetchedResultController()
        self.frc?.delegate = self
    }
    
    func deleteQuoteAt(index: IndexPath) {
        
        let quote = self.frc?.object(at: index)
        sharedCoredataCoordinator.delete(quote: quote!)
    }
    
    func addQuote(text: String, author: String) {
        
        _ = sharedCoredataCoordinator.addQuote(text: text, author: author)
        sharedCoredataCoordinator.saveContext()
    }
    
    func didTapAddAction() {
        
        let msg = "Add new quote"
        let alert = UIAlertController(title: "Add Quote", message: msg, preferredStyle: .alert)
        alert.addTextField { (textF: UITextField) in
            
            textF.placeholder = "Quote"
            textF.clearButtonMode = .whileEditing
            textF.keyboardType = .default
        }
        
        alert.addTextField { (textF: UITextField) in
            
            textF.placeholder = "Author"
            textF.clearButtonMode = .whileEditing
            textF.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_: UIAlertAction) in
            
            let text = alert.textFields?.first?.text
            let author = alert.textFields?.last?.text
            
            if !text!.isEmpty && !author!.isEmpty {
            
                self.addQuote(text: text!, author: author!)
            }
            
        }))
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let quotes = frc?.fetchedObjects else { return 0 }
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        let quote = self.frc?.object(at: indexPath)
        cell?.textLabel?.text = quote?.quoteText
        cell?.detailTextLabel?.text = quote?.quoteBy
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            let title = "Delete Quote"
            let msg = "Are you sure you want to delete this quote?"
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_: UIAlertAction) in
                
                self.deleteQuoteAt(index: indexPath)
            }))
            
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }
}

extension QuotePresenter: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView?.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView?.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView?.deleteRows(at: [indexPath], with: .fade)
            }
            
        default:
            print("...")
        }
    }
}
