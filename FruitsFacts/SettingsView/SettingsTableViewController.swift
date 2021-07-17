//
//  SettingsTableViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 11/06/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 2
        case 1:
            return 5
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell==nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        } 

        if indexPath.section == 0 { 
            if indexPath.row == 0 { 
                cell?.textLabel?.text = "Quotes"
            } else {
                cell?.textLabel?.text = "Auto Play"
                let autoPlaySw = UISwitch(frame: CGRect(x: (cell?.frame.size.width)!-40, y: 5, width: 100, height: (cell?.frame.size.height)!))
                autoPlaySw.addTarget(self, action: #selector(didChangeAutoPlaySwitchValue), for: .valueChanged)
                cell?.contentView.addSubview(autoPlaySw)
            }
        } else { 
            if indexPath.row == 0 { 
                cell?.textLabel?.text = "Background"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Background Color"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Background Image"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "Audio"
            } else if indexPath.row == 4 {
                cell?.textLabel?.text = "Audio File"
            }
        }

        return cell!
    }
    
    @objc func didChangeAutoPlaySwitchValue() {
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let quoteVc: QuoteListController = QuoteListController()
            self.navigationController?.pushViewController(quoteVc, animated: true)
        }
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
