//
//  SettingsTableViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 11/06/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var selectedIndexPath: IndexPath?
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
                let autoPlaySw = UISwitch(frame: CGRect(x: (cell?.frame.size.width)!-20, y: 5, width: 100, height: (cell?.frame.size.height)!))
                autoPlaySw.addTarget(self, action: #selector(didChangeAutoPlaySwitchValue), for: .valueChanged)
                autoPlaySw.isOn = (defaultConfig?.autoPlay)!
                cell?.contentView.addSubview(autoPlaySw)
            }
        } else { 
            if indexPath.row == 0 { 
                cell?.textLabel?.text = "Background: " + (defaultConfig?.backgroundMode)!
            } else if indexPath.row == 1 {
                
                cell?.textLabel?.text = "Background Color: " + (defaultConfig?.bgColorCode)!
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Background Image"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "Audio"
                let audioSw = UISwitch(frame: CGRect(x: (cell?.frame.size.width)!-20, y: 5, width: 100, height: (cell?.frame.size.height)!))
                audioSw.addTarget(self, action: #selector(didChangeAudioSwitchValue), for: .valueChanged)
                audioSw.isOn = (defaultConfig?.enableAudio)!
                cell?.contentView.addSubview(audioSw)
            } else if indexPath.row == 4 {
                cell?.textLabel?.text = "Audio File"
            }
        }

        return cell!
    }
    
    @objc func didChangeAutoPlaySwitchValue(sender: UISwitch) {
        
        defaultConfig?.autoPlay = sender.isOn
        sharedCoredataCoordinator.saveContext()
    }
    
    @objc func didChangeAudioSwitchValue(sender: UISwitch) {
        
        defaultConfig?.enableAudio = sender.isOn
        sharedCoredataCoordinator.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        self.selectedIndexPath = indexPath
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let quoteVc: QuoteListController = QuoteListController()
            self.navigationController?.pushViewController(quoteVc, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            let pickerVc = KDPickerController(style: UITableView.Style.grouped)
            pickerVc.delegate=self
            pickerVc.itemList = NSArray(array: ["Image", "Color"])
            pickerVc.pickerType = .text
            pickerVc.selectedItem = defaultConfig?.backgroundMode
            let navVc = UINavigationController(rootViewController: pickerVc)
            navVc.navigationBar.barStyle = .black
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                navVc.modalPresentationStyle = .popover
                let viewPresentationController = navVc.popoverPresentationController
                if let presentationController = viewPresentationController {
                    
                    presentationController.sourceView = cell
                    presentationController.permittedArrowDirections=UIPopoverArrowDirection.down
                }
                navVc.preferredContentSize = CGSize(width: 300, height: 450)
            }
            
            self.present(navVc, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.scrollDirection = .vertical
            let colorVc = OPColorPickerController(collectionViewLayout: layout)
            colorVc.delegate=self
            let nav = UINavigationController(rootViewController: colorVc)
            nav.navigationBar.barStyle = .black
            
            /*if UIDevice.current.userInterfaceIdiom == .pad {
                
                nav.modalPresentationStyle = .popover
                let viewPresentationController = nav.popoverPresentationController
                if let presentationController = viewPresentationController {
                    presentationController.sourceView = cell
                    presentationController.permittedArrowDirections = UIPopoverArrowDirection.left
                }
                nav.preferredContentSize=CGSize(width: 550, height: 550)
            }*/
            
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension SettingsTableViewController: KDPickerDelegate {
    
    func didSelectItem(item: String) {
        
        let cell = tableView.cellForRow(at: self.selectedIndexPath!)
        if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 0 {
            
            cell?.textLabel?.text = "Background: " + item
            defaultConfig?.backgroundMode = item
            sharedCoredataCoordinator.saveContext()
        }
    }
}

extension SettingsTableViewController: OPColorPickerDelegate {
    
    func didSelectColorHex(colorHex: String) {
        
        let cell = tableView.cellForRow(at: self.selectedIndexPath!)
        if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 1 {
            
            cell?.textLabel?.text = "Background Color: " + colorHex
            defaultConfig?.bgColorCode = colorHex
            sharedCoredataCoordinator.saveContext()
        }
    }
}
