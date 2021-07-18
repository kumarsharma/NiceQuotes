//
//  FactViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit
import AVFoundation

class FactViewController: UIViewController {

    var titleLabel: UILabel?
    var factTextView: UILabel?
    var backgroundView: UIImageView?
    var presenter: FactPresenter?
    var yPos: CGFloat = 94
    var adViewHeight = 44
    var soundEffect: AVAudioPlayer?
    var playTimer: Timer?
    var selfWidth: CGFloat?
    var selfHeight: CGFloat?
    var currentAudioFileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nice Quotes"
        let barBtn = UIBarButtonItem.init(image: UIImage.init(named: "settings_icn"), style: .done, target: self, action: #selector(btnAction)) 
            
        let infoBtn = UIButton.init(type: .infoLight)
        infoBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        infoBtn.addTarget(self, action: #selector(infoBtnAction), for: .touchUpInside)
        let barBtn2 = UIBarButtonItem.init(customView: infoBtn)
        
        self.navigationItem.rightBarButtonItem = barBtn
        self.navigationItem.leftBarButtonItem = barBtn2
        self.currentAudioFileName = (defaultConfig?.audioFileName)!
        selfWidth = self.view.bounds.size.width
        selfHeight = self.view.bounds.size.height
        
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
        self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin]
        self.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFill
        self.backgroundView?.clipsToBounds = true
        self.backgroundView?.isHidden = true
 
        self.factTextView = UILabel(frame: CGRect(x: 5, y: yPos, width: selfWidth!-10, height: selfHeight!-CGFloat(yPos)))
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if (defaultConfig?.backgroundMode?.elementsEqual("Color")) != nil {
            
            self.backgroundView?.isHidden = true
            let color = UIColor.init(hexString: (defaultConfig?.bgColorCode!)! as NSString)
            self.view.backgroundColor = color 
        } else {
            
            self.backgroundView?.isHidden = false
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
                
                self.playTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didSwipeUp), userInfo: nil, repeats: true)
                self.playTimer?.fire()
            }
        } else {
            
            self.playTimer?.invalidate()
        }
        
        self.factTextView?.textColor = UIColor.init(hexString: (defaultConfig?.textColorCode)! as NSString)
    }
    
    @objc func btnAction() {
        
        let settingsVc = SettingsTableViewController.init(style: UITableView.Style.grouped)
        self.navigationController?.pushViewController(settingsVc, animated: true)
    }
    
    @objc func infoBtnAction() {
        
        let msg = "Developed with joy for you.\n\nYou can add custom quotes from settings.\n\nEnjoy quotes with background music.\n\nMusic source: www.bensound.com\n\nFeedback @ kumar.asom@gmail.com"
        let alert = UIAlertController(title: "Nice Quotes", message: msg, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didSwipeUp() {
        
        UIView.animate(withDuration: 2, delay: 0.001, options: .transitionCurlUp, animations: {
          
            let height = self.selfHeight!-CGFloat(self.yPos)
            self.factTextView?.frame = CGRect(x: 5, y: -500, width: self.selfWidth!-10, height: height)
        }, completion: { _ in
          
            self.factTextView?.frame = CGRect(x: 5, y: self.yPos, width: self.selfWidth!-10, height: self.selfHeight!-CGFloat(self.yPos))  
            self.presenter?.didSwipeUp()
        })
        
    }
    
    @objc private func didSwipeDown() {
        
        UIView.animate(withDuration: 2, delay: 0.001, options: .transitionCurlDown, animations: {
          
            let height = self.selfHeight!-CGFloat(self.yPos)
            self.factTextView?.frame = CGRect(x: 5, y: self.view.frame.size.height+500, width: self.selfWidth!-10, height: height)
        }, completion: { _ in
          
            self.factTextView?.frame = CGRect(x: 5, y: self.yPos, width: self.selfWidth!-10, height: self.selfHeight!-CGFloat(self.yPos))
            self.presenter?.didSwipeDown()
        })
    }
}
