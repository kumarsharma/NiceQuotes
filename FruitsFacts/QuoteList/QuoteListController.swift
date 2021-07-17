//
//  QuoteListController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 28/06/21.
//

import UIKit

class QuoteListController: UITableViewController {

    var presenter: QuotePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Quotes"
        
        self.presenter = QuotePresenter(tableview: self.tableView)
        self.presenter?.controller = self
        self.tableView.delegate = self
        self.tableView.dataSource = self.presenter
        let bar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBtnAction))
        self.navigationItem.rightBarButtonItem = bar
    }
    
    @objc func addBtnAction() {
        
        self.presenter?.didTapAddAction()
    }

    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
