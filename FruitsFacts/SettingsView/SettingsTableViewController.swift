//
//  SettingsTableViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 11/06/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var selectedIndexPath: IndexPath?
    var bgColorLabel: UILabel?
    var txtColorLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 2
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = String(format: "cell %d%d", indexPath.section, indexPath.row)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell==nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        } 

        if indexPath.section == 0 { 
            if indexPath.row == 0 { 
                cell?.textLabel?.text = "Quotes"
                cell?.accessoryType = .disclosureIndicator
            } else {
                cell?.textLabel?.text = "Auto Play"
                let autoPlaySw = UISwitch(frame: CGRect(x: (cell?.frame.size.width)!, y: 5, width: 100, height: (cell?.frame.size.height)!))
                autoPlaySw.addTarget(self, action: #selector(didChangeAutoPlaySwitchValue), for: .valueChanged)
                autoPlaySw.isOn = (defaultConfig?.autoPlay)!
                cell?.contentView.addSubview(autoPlaySw)
                cell?.accessoryType = .none
            }
        } else if indexPath.section == 1 { 
            if indexPath.row == 0 {
                
                cell?.textLabel?.text = "Background Color: "
                cell?.accessoryType = .none
                
                bgColorLabel = UILabel(frame: CGRect(x: 165, y: 5, width: 50, height: ((cell?.frame.size.height)!-10)))
                bgColorLabel!.backgroundColor = UIColor(hexString: (defaultConfig?.bgColorCode)! as NSString)
                cell?.addSubview(bgColorLabel!)
                
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Text Color: "
                cell?.accessoryType = .none
                
                txtColorLabel = UILabel(frame: CGRect(x: 110, y: 5, width: 50, height: ((cell?.frame.size.height)!-10)))
                txtColorLabel!.backgroundColor = UIColor(hexString: (defaultConfig?.textColorCode)! as NSString)
                cell?.addSubview(txtColorLabel!)
                
            } else if indexPath.row == 2 {
                let str = "Text Font: " + (defaultConfig?.getQuoteFontName())!
                cell?.accessoryType = .none
                let abt = NSMutableAttributedString(string: str)
                let font = UIFont(name: (defaultConfig?.getQuoteFontName())!, size: 17)
                let range = NSRange(location: 10, length: (defaultConfig?.getQuoteFontName())!.count)
                abt.addAttribute(.font, value: font!, range: range)
                cell?.textLabel?.attributedText = abt
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = String(format: "Font Size: %d", NSInteger(defaultConfig!.fontSize))
                cell?.accessoryType = .none
                
                let slider = UISlider(frame: CGRect(x: 140, y: 0, width: (cell?.frame.size.width)!-100, height: (cell?.frame.size.height)!))
                slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
                slider.minimumValue = 22
                slider.maximumValue = 44
                slider.tintColor = .green
                slider.isContinuous = true
                slider.value = defaultConfig!.fontSize
                cell?.addSubview(slider)
            } 
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Audio"
                let audioSw = UISwitch(frame: CGRect(x: (cell?.frame.size.width)!, y: 5, width: 100, height: (cell?.frame.size.height)!))
                audioSw.addTarget(self, action: #selector(didChangeAudioSwitchValue), for: .valueChanged)
                audioSw.isOn = (defaultConfig?.enableAudio)!
                cell?.contentView.addSubview(audioSw)
                cell?.accessoryType = .none
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Audio File: " + (defaultConfig?.audioFileName)!
                cell?.accessoryType = .none
            }
        }

        return cell!
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 1))
        defaultConfig?.fontSize = sender.value
        sharedCoredataCoordinator.saveContext()
        cell?.textLabel?.text = String(format: "Font Size: %d", NSInteger(defaultConfig!.fontSize))
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
        
        self.selectedIndexPath = indexPath
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let quoteVc: QuoteListController = QuoteListController()
            self.navigationController?.pushViewController(quoteVc, animated: true)
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 || indexPath.row == 1 { 
                
                let layout = UICollectionViewFlowLayout()
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.scrollDirection = .vertical
                let colorVc = OPColorPickerController(collectionViewLayout: layout)
                colorVc.delegate=self
                let nav = UINavigationController(rootViewController: colorVc)
                nav.navigationBar.barStyle = .black
                self.present(nav, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                
                let pickerVc = KDPickerController(style: UITableView.Style.grouped)
                pickerVc.delegate=self
                pickerVc.pickerType = .font
                pickerVc.itemList=UIFont.familyNames as NSArray
                pickerVc.selectedItem = (defaultConfig?.getQuoteFontName())!
                let navVc = UINavigationController(rootViewController: pickerVc)
                navVc.navigationBar.barStyle = .black
                self.present(navVc, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 && indexPath.row == 1 {
            
            let pickerVc = KDPickerController(style: UITableView.Style.grouped)
            pickerVc.delegate=self
            pickerVc.pickerType = .sound
            pickerVc.itemList=NSArray(array: ["Little_Planet","Love","Sweet", "Adventure","Relaxing","Creative_Minds","Funny_Song","Little_Idea","Acoustic_Breeze","Piano_Moment"])
            pickerVc.selectedItem = (defaultConfig?.audioFileName)!
            let navVc = UINavigationController(rootViewController: pickerVc)
            navVc.navigationBar.barStyle = .black
            self.present(navVc, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsTableViewController: KDPickerDelegate {
    
    func didSelectItem(item: String) {
        
        let cell = tableView.cellForRow(at: self.selectedIndexPath!)
        if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 0 {
            
            cell?.textLabel?.text = "Background: " + item
            defaultConfig?.backgroundMode = item
            sharedCoredataCoordinator.saveContext()
        } else if self.selectedIndexPath?.section == 2 && self.selectedIndexPath?.row == 1 {
            
            cell?.textLabel?.text = "Audio File: " + item
            defaultConfig?.audioFileName = item
            sharedCoredataCoordinator.saveContext()
        } else if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 2 {
            
            let str = "Text Font: " + item
            let abt = NSMutableAttributedString(string: str)
            let font = UIFont(name: item, size: 17)
            let range = NSRange(location: 10, length: item.count)
            abt.addAttribute(.font, value: font!, range: range)
            cell?.textLabel?.attributedText = abt

            defaultConfig?.quoteFontName = item
            sharedCoredataCoordinator.saveContext()
        } 
    }
}

extension SettingsTableViewController: OPColorPickerDelegate {
    
    func didSelectColorHex(colorHex: String) {
        
        if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 0 {
            
            bgColorLabel!.backgroundColor = UIColor(hexString: colorHex as NSString)
            defaultConfig?.bgColorCode = colorHex
            sharedCoredataCoordinator.saveContext()
        } else if self.selectedIndexPath?.section == 1 && self.selectedIndexPath?.row == 1 {
            
            txtColorLabel!.backgroundColor = UIColor(hexString: colorHex as NSString)
            defaultConfig?.textColorCode = colorHex
            sharedCoredataCoordinator.saveContext()
        }
    }
}
