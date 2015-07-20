# cocos2d-iad-swift

A sample Swift class that you can easily import into your cocos2d-Swift project to implement iAd.

## Usage

Import the file into your Source folder in your xCode project. Also, go to your Project directory in xCode, open the Build Phases tab, and import the `iAd.framework` under "Link Binary With Libraries".

Read the instructions below on how to implement the type of ad you want:

#### Banner
* Load a banner ad by using `iAdHandler.sharedInstance.loadAds(bannerPosition: BannerPosition)`. Possible `BannerPosition` types are `.Top` or `.Bottom`, which mean exactly what they say.
* Display a banner ad by using `iAdHandler.sharedInstance.displayBannerAd()`.
* Reposition a banner ad by using `iAdHandler.sharedInstance.setBannerPosition(bannerPosition: BannerPosition)`.
* Hide a banner ad by using `iAdHandler.sharedInstance.hideBannerAd()`. You **must** explicitly call this function or set `adBannerView.hidden = true` and cannot simply move the element off of the screen or your app will not be approved by Apple.

#### Interstitial
* Load a interstitial by using `iAdHandler.sharedInstance.loadInterstitialAd()`.
* Display an interstitial by using `iAdHandler.sharedInstance.displayInterstitialAd()`. Thankfully, you don't have to explicitly remove the interstitial because Apple will do that for you.
* Apple does not automatically add a "close" button to the top corner of interstitials, so you'll have to do it yourself. If you're interested in doing that, I've already implemented the code necessary to do so: simply add a file named `close.png` to your Resources folder.
