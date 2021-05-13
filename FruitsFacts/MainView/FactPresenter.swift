//
//  FactPresenter.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit

class FactPresenter: MVPresenter {
    
    weak var titleLabel : UILabel?
    weak var textArea : UILabel?

    init(title_Label:UILabel?, textView:UILabel?)
    {
        self.titleLabel = title_Label
        self.textArea = textView
        
        super.init()
    }
    
    func viewDidLoad(){
        
        self.titleLabel?.text = "Did You Know?"
        self.textArea?.text = "Apples, peaches and raspberries are all members of the rose family."
    }
    
    func didSwipeUp(){
        
        self.textArea?.text = "Pumpkins and avocados are fruits not a vegetable."
    }
    
    func didSwipeDown(){
        
        self.textArea?.text = "Apples float in water because they are 25% air"
    }
}
