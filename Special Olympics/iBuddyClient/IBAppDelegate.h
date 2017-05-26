//
//  IBAppDelegate.h
//  iBuddyClient
//
//  Created by Anubha on 02/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"IBCategoryVC.h"
#import "SideBarVC.h"
#import <MapKit/MapKit.h>
#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"

/**
 @class IBAppDelegate
 @inherits UIResponder
 @description Main class.
 */
@class IBViewController;

@interface IBAppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    SideBarVC *objSideBarVC;
    float  complteHiddenSideNav;
    float  hiddenSideNavigationX ;
    float showSideNavigationX ;
    float swipeViewWidth;
    float swipeViewHeight;
    float sideNavigationY;
    float fontSize;
    float fontSizeSmall;
    float fontSizeSmallest;
    NSString *strNotifiedMerchantID;
    
    UISwipeGestureRecognizer *recognizerRight;
    UISwipeGestureRecognizer *recognizerLeft;
    
    UIImageView *imgViewAdsThumb;
    UILabel *lblAdsTitle;
    UILabel *lblAdsDescription;
    UIImageView *imgViewAdsBase;
    NSString *strADImageURL;
    UIView *adsView;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *strlatitude;
    NSString *strlongitude;
    NSMutableArray *arrAds;
    BOOL checkToStopMethodCall;
    int countAdsIndex;
    BOOL shiftNavigation;
    UIBackgroundTaskIdentifier bgTask;
    NSDictionary *offerDict;

    
}
@property (nonatomic) BOOL checkToStopMethodCall;
@property (strong,nonatomic)SideBarVC *objSideBarVC;
@property (strong,nonatomic)NSTimer *adTimer;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)UIView *adsView;
@property (strong, nonatomic) IBViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (nonatomic,strong)IBCategoryVC *objIBCategoryVC;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableDictionary *dictUserInfo;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSDictionary *dictOptions;

@property (strong,nonatomic) LGSideMenuController *sideMenuController;

@property float  hiddenSideNavigationX ;
@property float  sideNavigationY ;
@property float showSideNavigationX ;
@property float swipeViewWidth ;
@property float fontSizeSmallest;
@property float swipeViewHeight ;
@property float fontSize;
@property float fontSizeSmall;
@property BOOL shiftNavigation;

-(void)showProgressHUD;
-(void)showProgressHUD;

- (void)showMenu;
- (void)hideMenu;

-(void)showProgressHUD;
-(void)showProgressHUD:(UIView*)view;
-(void)hideProgressHUD;
-(void)addBottomADView;
-(void)createWindowAgain;
-(void)callAdsWebService:(NSString *)latitude longitude:(NSString *)longitude;
-(void)fetchAdslocation:(CLLocation*)location error:(NSError*)error;
-(void)fnAlert:(NSString*) Title tag:(NSInteger)tag dict:(NSDictionary*) offerDict;
- (void)loadAppDel:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
