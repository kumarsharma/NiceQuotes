//
//  OPColorPickerController.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 29/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class OPColorPickerController: UICollectionViewController {

    var delegate: OPColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select an Item"
        let bar1 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnAction))
        let bar2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnAction));
        self.navigationItem.leftBarButtonItem = bar1
        self.navigationItem.rightBarButtonItem = bar2
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func cancelBtnAction() {
           
        self.dismiss(animated: true, completion: nil)
    }
       
    @objc func doneBtnAction() {
          
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 160
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var colorData: Data?
        var colors: [AnyObject]?
        let url = Bundle.main.url(forResource: "colorPalette", withExtension: "plist")!
        
        do {
            colorData = try Data(contentsOf: url)
        } catch _ as NSError {
            
        }
        do {
            colors = try (PropertyListSerialization.propertyList(from: colorData!, options: [], format: nil) as? [AnyObject])
        } catch _ as NSError {
            
        }
        
        let hexString = (colors![indexPath.row] as? String)!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.init(hexString: hexString as NSString)    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 10, height: 10)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var colorData: Data?
        var colors: [AnyObject]?
        let url = Bundle.main.url(forResource: "colorPalette", withExtension: "plist")!
        
        do {
            colorData = try Data(contentsOf: url)
        } catch _ as NSError {
            
        }
        do {
            colors = try (PropertyListSerialization.propertyList(from: colorData!, options: [], format: nil) as? [AnyObject])
        } catch _ as NSError {
            
        }
        
        let hexString = (colors![indexPath.row] as? String)!
        
        if delegate != nil {
            
            delegate?.didSelectColorHex(colorHex: hexString)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
