//
//  FactViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit

class FactViewController: UIViewController {

    var titleLabel: UILabel?
    var factTextView: UILabel?
    var backgroundView: UIImageView?
    var presenter: FactPresenter?
    var yPos: CGFloat = 94
    var adViewHeight = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nice Quotes"
        let barBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(btnAction))
        self.navigationItem.rightBarButtonItem = barBtn

        /*
        self.titleLabel = UILabel(frame: CGRect(x: 5, y: yPos, width: self.view.bounds.size.width-10, height: 44))
        self.titleLabel?.layer.cornerRadius = 10
        self.titleLabel?.layer.borderWidth = 2
        self.titleLabel?.layer.borderColor = UIColor.darkGray.cgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.titleLabel?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth*/
        
        self.backgroundView = UIImageView(frame: self.view.bounds)
        self.backgroundView?.image = UIImage(named: "Bg")
        self.backgroundView?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFill
        self.backgroundView?.clipsToBounds = true
 
        let selfWidth = self.view.bounds.size.width
        let selfHeight = self.view.bounds.size.height
        self.factTextView = UILabel(frame: CGRect(x: 5, y: yPos, width: selfWidth-10, height: selfHeight-CGFloat(yPos)))
        self.factTextView?.textAlignment = NSTextAlignment.center
        self.factTextView?.font = UIFont.boldSystemFont(ofSize: 33)
        self.factTextView?.numberOfLines = 50
        self.factTextView?.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        
        self.view.addSubview(self.backgroundView!)
        self.view.addSubview(self.factTextView!)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeDown.direction = .down
        
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)
                
        self.presenter = FactPresenter(titlelabel: self.titleLabel, textView: self.factTextView)
        self.presenter?.viewDidLoad()
    }
    
    @objc func btnAction() {
        
    }
    
    @objc private func didSwipeUp() {
        
        self.presenter?.didSwipeUp()
    }
    
    @objc private func didSwipeDown() {
        
        self.presenter?.didSwipeDown()
    }
}
