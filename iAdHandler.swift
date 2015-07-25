//
//  iAdHandler.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/19/15.
//  Copyright (c) 2015 ZacharyEspiritu. All rights reserved.
//

import Foundation
import iAd

enum BannerPosition {
    case Top, Bottom
}

class iAdHandler: NSObject {
    
    // MARK: Variables
    
    let view = CCDirector.sharedDirector().parentViewController!.view // Returns a UIView of the cocos2d parent view controller.
    
    var adBannerView = ADBannerView(frame: CGRect.zeroRect)
    var bannerPosition: BannerPosition = .Top
    var isBannerDisplaying: Bool = false
    
    var interstitial = ADInterstitialAd()
    var interstitialAdView: UIView = UIView()
    var isInterstitialDisplaying: Bool = false
    var isInterstitialLoaded: Bool = false
    
    var closeButton: UIButton!
    
    
    // MARK: Singleton
    
    class var sharedInstance : iAdHandler {
        struct Static {
            static let instance : iAdHandler = iAdHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Banner Ad Functions
    
    /**
    Sets the position of the soon-to-be banner ad and attempts to load a new ad from the iAd network.
    
    :param: bannerPosition  the `BannerPosition` at which the ad should be positioned initially
    */
    func loadAds(#bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
        
        if bannerPosition == .Top {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: -(adBannerView.frame.size.height / 2))
        }
        else {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height + (adBannerView.frame.size.height / 2))
        }
        
        adBannerView.delegate = self
        adBannerView.hidden = true
        adBannerView.backgroundColor = UIColor.clearColor()
        view.addSubview(adBannerView)
    }
    
    /**
    Repositions the `adBannerView` to the designated `bannerPosition`.
    
    :param: bannerPosition  the `BannerPosition` at which the ad should be positioned
    */
    func setBannerPosition(#bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
    }
    /**
    Displays the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func displayBannerAd() {
        if adBannerView.bannerLoaded {
            adBannerView.hidden = false
            isBannerDisplaying = true
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: (self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height - (self.adBannerView.frame.size.height / 2))
                }
            })
        }
        else {
            println("Did not display ads because banner isn't loaded yet!")
        }
    }
    
    /**
    Hides the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func hideBannerAd() {
        if adBannerView.bannerLoaded {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: -(self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height + (self.adBannerView.frame.size.height / 2))
                }
            })
            delay(0.5) {
                self.adBannerView.hidden = true
                self.isBannerDisplaying = false
            }
        }
    }
    
    
    // MARK: Interstitial Functions
    
    /**
    Attempts to load an interstitial ad.
    */
    func loadInterstitialAd() {
        interstitial.delegate = self
    }
    
    /**
    Displays the `interstitial`.
    
    If an interstitial has not been successfully loaded, nothing will happen.
    */
    func displayInterstitialAd() {
        
        if isInterstitialLoaded == true {
            
            view.addSubview(interstitialAdView)
            interstitial.presentInView(interstitialAdView)
            UIViewController.prepareInterstitialAds()
            
            closeButton = UIButton(frame: CGRect(x: 15, y: 15, width: 25, height: 25))
            closeButton.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
            closeButton.addTarget(self, action: Selector("close"), forControlEvents: UIControlEvents.TouchDown)
            self.view.addSubview(closeButton)
            
            isInterstitialDisplaying = true
            
            self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
            self.closeButton.hidden = true
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height / 2))
                self.closeButton.hidden = false
            })
            
            println("Interstitial displaying!")
        }
        else {
            println("Interstitial not loaded yet!")
        }
        
    }
    
    
    func close() {
        if isInterstitialDisplaying {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
                self.closeButton.center = CGPoint(x: -15, y: self.closeButton.center.y)
            })
            delay(0.5) {
                self.interstitialAdView.removeFromSuperview()
                self.closeButton.removeFromSuperview()
                self.isInterstitialDisplaying = false
                self.interstitial = ADInterstitialAd()
            }
        }
    }
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    :param: delay  how long, in milliseconds, to wait until the program should run the code in the closure statement
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension iAdHandler: ADInterstitialAdDelegate {
    
    /**
    Called whenever a interstitial successfully loads.
    */
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        isInterstitialLoaded = true
        
        println("Succesfully loaded interstitital!")
    }
    
    /**
    Called whenever the interstitial's action finishes; e.g.: the user has already clicked on the ad and decides to exit out or the ad campaign finishes.
    */
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
            self.closeButton.center = CGPoint(x: -15, y: self.closeButton.center.y)
        })
        delay(0.5) {
            self.interstitialAdView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.isInterstitialDisplaying = false
            self.isInterstitialLoaded = false
            self.interstitial = ADInterstitialAd()
        }
    }
    
    /**
    Called whenever an interstitial ad is about to be displayed.
    */
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    /**
    Called whenever an interstitial ad unloads automatically.
    */
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        if isInterstitialDisplaying {
            interstitialAdView.removeFromSuperview()
            closeButton.removeFromSuperview()
            isInterstitialDisplaying = false
        }
        isInterstitialLoaded = false
        interstitial = ADInterstitialAd()
    }
    
    /**
    Called when a interstitial was unable to be loaded.
    */
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        println("Was not able to load an interstitial with error: \(error)")
        self.isInterstitialLoaded = false
        interstitial = ADInterstitialAd()
    }
    
}

extension iAdHandler: ADBannerViewDelegate {
    
    /**
    Called whenever a banner ad successfully loads.
    */
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("Successfully loaded banner!")
    }
    
    /**
    Called when a banner ad was unable to be loaded.
    */
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("Was not able to load a banner with error: \(error)")
    }
}
