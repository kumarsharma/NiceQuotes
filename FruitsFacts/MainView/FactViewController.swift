//
//  FactViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 12/05/21.
//

import UIKit
import GoogleMobileAds

class FactViewController: UIViewController, GADBannerViewDelegate {

    var factTextView: UILabel?
    var presenter: FactPresenter?
    var yPos: CGFloat = 94
    var adViewHeight = 44
    var selfWidth: CGFloat?
    var selfHeight: CGFloat?
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nice Quotes"
        let barBtn = UIBarButtonItem.init(image: UIImage.init(named: "settings_icn"), style: .done, target: self, action: #selector(btnAction)) 
        let shareBtn = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareBtnAction(sender:)))
        
        barBtn.tintColor = .cyan
            
        let infoBtn = UIButton.init(type: .infoLight)
        infoBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        infoBtn.addTarget(self, action: #selector(infoBtnAction), for: .touchUpInside)
        let barBtn2 = UIBarButtonItem.init(customView: infoBtn)
        
        self.navigationItem.rightBarButtonItems = [barBtn, shareBtn]
        self.navigationItem.leftBarButtonItem = barBtn2
        selfWidth = self.view.bounds.size.width
        selfHeight = self.view.bounds.size.height
        
        self.factTextView = UILabel(frame: CGRect(x: 5, y: yPos, width: selfWidth!-10, height: selfHeight!-CGFloat(yPos)))
        self.factTextView?.textAlignment = NSTextAlignment.center
        self.factTextView?.font = UIFont.boldSystemFont(ofSize: CGFloat(defaultConfig!.fontSize))
        self.factTextView?.numberOfLines = 50
        self.factTextView?.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        self.factTextView?.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(self.factTextView!)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeDown.direction = .down
        
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)
                
        self.presenter = FactPresenter(textView: self.factTextView)
        self.presenter?.controller = self
        self.presenter?.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        #if DEBUG        
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
            bannerView.adUnitID = "ca-app-pub-1232392292595179/3647064682"
        #endif
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        self.view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.presenter?.needChangeDisplay()
    }
    
    @objc func shareBtnAction(sender: UIBarButtonItem) {
        
        let renderer = UIGraphicsImageRenderer(size: (self.factTextView?.bounds.size)!)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        let items = [image]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            activityVC.popoverPresentationController?.barButtonItem = sender
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func btnAction() {
        
        let settingsVc = SettingsTableViewController.init(style: UITableView.Style.grouped)
        self.navigationController?.pushViewController(settingsVc, animated: true)
        /*
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let nav = UINavigationController(rootViewController: settingsVc)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true, completion: nil)
        } else {
         
            self.navigationController?.pushViewController(settingsVc, animated: true)
        }*/
    }
    
    @objc func infoBtnAction() {
        
        let msg = "Developed with joy for you.\n\nYou can add custom quotes from settings.\n\nEnjoy quotes with background music.\n\nMusic source: www.bensound.com\n\nFeedback @ kumar.asom@gmail.com"
        let alert = UIAlertController(title: "Nice Quotes", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didSwipeUp() {
        
        self.presenter?.didSwipeUp()        
    }
    
    @objc private func didSwipeDown() {
        
        self.presenter?.didSwipeDown()
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
