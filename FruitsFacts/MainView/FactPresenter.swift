//
//  FactPresenter.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit

class FactPresenter: MVPresenter {
    weak var titleLabel: UILabel?
    weak var textArea: UILabel?
    var currentIndex: NSInteger? = 0
    override init() {
        super.init()
    }

    init(titlelabel: UILabel?, textView: UILabel?) {
        self.titleLabel = titlelabel
        self.textArea = textView
        super.init()
    }
    func viewDidLoad() {
        let quote = sharedCoredataCoordinator.fetchQuote(atIndex: currentIndex!)
        currentIndex! = currentIndex!+1
        self.titleLabel?.text = "Nice Quote"
        self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"
    }
    func didSwipeUp() {
        let quote = self.nextQuote()
        self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"        
    }
    func didSwipeDown() {
        let quote = self.prevQuote()
        self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"
    }
    func nextQuoteText() -> String {
        let quote = self.nextQuote()
        return quote.quoteText!
    }
    func previousQuoteText() -> String {
        let quote = self.prevQuote()
        return quote.quoteText!
    }
    // private members
    private func nextQuote() -> Fact {
        currentIndex! = currentIndex!+1 
        let quote = sharedCoredataCoordinator.fetchQuote(atIndex: currentIndex!)
        return quote
    }
    private func prevQuote() -> Fact {
        if currentIndex!>0 {
            currentIndex! = currentIndex!-1
        }
        let quote = sharedCoredataCoordinator.fetchQuote(atIndex: currentIndex!)
        return quote
    }
}
