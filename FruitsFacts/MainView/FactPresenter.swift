//
//  FactPresenter.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit
import AVFoundation
import CoreData

class FactPresenter: MVPresenter {
    weak var textArea: UILabel?
    var currentIndex: NSInteger? = 0
    weak var controller: UIViewController? 
    var soundEffect: AVAudioPlayer?
    var playTimer: Timer?
    var currentAudioFileName: String?
    var yPos: CGFloat = 94
    var selfWidth: CGFloat?
    var selfHeight: CGFloat?
    var frc: NSFetchedResultsController<Fact>?

    override init() {
        super.init()
    }

    init(textView: UILabel?) {
        self.textArea = textView
        super.init()
    }
    
    func viewDidLoad() {
        
        let quote = sharedCoredataCoordinator.fetchQuote(atIndex: currentIndex!)
        self.frc = sharedCoredataCoordinator.factFetchedResultController()
        currentIndex! = currentIndex!+1
        self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"
        selfWidth = self.controller?.view.bounds.size.width
        selfHeight = self.controller?.view.bounds.size.height
        self.currentAudioFileName = (defaultConfig?.audioFileName)!
    }
    
    @objc func didSwipeUp() {
        
        selfWidth = self.controller?.view.bounds.size.width
        selfHeight = self.controller?.view.bounds.size.height
        UIView.animate(withDuration: 2, delay: 0.001, options: .transitionCurlUp, animations: {
          
            let height = self.selfHeight!-CGFloat(self.yPos)
            self.textArea?.frame = CGRect(x: 5, y: -500, width: self.selfWidth!-10, height: height)
        }, completion: { _ in
          
            self.textArea?.frame = CGRect(x: 5, y: self.yPos, width: self.selfWidth!-10, height: self.selfHeight!-CGFloat(self.yPos))  
            let quote = self.nextQuote()
            self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"
        })        
    }
    
    @objc func didSwipeDown() {
        
        selfWidth = self.controller?.view.bounds.size.width
        selfHeight = self.controller?.view.bounds.size.height
        UIView.animate(withDuration: 2, delay: 0.001, options: .transitionCurlDown, animations: {
          
            let height = self.selfHeight!-CGFloat(self.yPos)
            self.textArea?.frame = CGRect(x: 5, y: (self.controller?.view.frame.size.height)!+500, width: self.selfWidth!-10, height: height)
        }, completion: { _ in
          
            self.textArea?.frame = CGRect(x: 5, y: self.yPos, width: self.selfWidth!-10, height: self.selfHeight!-CGFloat(self.yPos))
            
            let quote = self.prevQuote()
            self.textArea?.text = quote.quoteText!+"\n\n-- \(quote.quoteBy ?? "")"
        })
    }
    
    func nextQuoteText() -> String {
        let quote = self.nextQuote()
        return quote.quoteText!
    }
    
    func previousQuoteText() -> String {
        let quote = self.prevQuote()
        return quote.quoteText!
    }
    
    func needChangeDisplay() {
        
        if (defaultConfig?.backgroundMode?.elementsEqual("Color")) != nil {
            
            let color = UIColor.init(hexString: (defaultConfig?.bgColorCode!)! as NSString)
            self.controller?.view.backgroundColor = color 
        }
        
        if (defaultConfig?.enableAudio)! {
            
            if soundEffect == nil || !soundEffect!.isPlaying || self.currentAudioFileName != (defaultConfig?.audioFileName)! {
                
                self.currentAudioFileName = (defaultConfig?.audioFileName)!
                let path = Bundle.main.path(forResource: "\((defaultConfig?.audioFileName)!)", ofType: "mp3")!
                let url = URL(fileURLWithPath: path)
                do {
                    
                    soundEffect = try AVAudioPlayer(contentsOf: url)
                    soundEffect?.numberOfLoops = -1
                    soundEffect?.play()
                } catch _ as NSError {
                    
                }
            }
        } else {
            
            soundEffect?.stop()
        }
        
        if (defaultConfig?.autoPlay)! {
            
            if self.playTimer == nil || !self.playTimer!.isValid {
                
                self.playTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(didSwipeUp), userInfo: nil, repeats: true)
                self.playTimer?.fire()
            }
        } else {
            
            self.playTimer?.invalidate()
        }
        
        self.textArea?.textColor = UIColor.init(hexString: (defaultConfig?.textColorCode)! as NSString)
    }
    
    // private members
    private func nextQuote() -> Fact {
        currentIndex! = currentIndex!+1 
//        let quote = sharedCoredataCoordinator.fetchQuote(atIndex: currentIndex!)
        let index = currentIndex! >= (self.frc?.fetchedObjects!.count)! ? 0 : currentIndex!
        currentIndex! = index
        
        let quote = self.frc?.object(at: IndexPath(row: index, section: 0))
        return quote!
    }
    private func prevQuote() -> Fact {
        if currentIndex!>0 {
            currentIndex! = currentIndex!-1
        }
        let index = currentIndex! >= (self.frc?.fetchedObjects!.count)! ? (self.frc?.fetchedObjects!.count)!-1 : currentIndex!
        let quote = (self.frc?.object(at: IndexPath(row: index, section: 0)))!
        return quote
    }
}
