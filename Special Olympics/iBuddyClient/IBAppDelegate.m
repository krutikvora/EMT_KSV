//
//  IBAppDelegate.m
//  iBuddyClient
//
//  Created by Anubha on 02/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBAppDelegate.h"
#import "UIImageView+WebCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import "IBCommunicationToolVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FirstViewController.h"

#define kDonationAlertTag 9696

@implementation IBAppDelegate
@synthesize objIBCategoryVC, navController, HUD;
@synthesize dictUserInfo;
@synthesize hiddenSideNavigationX, showSideNavigationX, swipeViewWidth, swipeViewHeight;
@synthesize fontSize;
@synthesize fontSizeSmall;
@synthesize fontSizeSmallest;
//@synthesize dictUserPaymentInfo;
@synthesize adsView;
@synthesize adTimer;
@synthesize sideNavigationY;
@synthesize shiftNavigation;
@synthesize objSideBarVC, checkToStopMethodCall, locationManager, sideMenuController, dictOptions;
#pragma mark -
#pragma mark - Window LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    for (NSString *family in [UIFont familyNames]){
//        NSLog(@"Family name: %@", family);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:family]) {
//            NSLog(@"    >Font name: %@", fontName);
//        }
//    }
    self.dictOptions = launchOptions;
  
   	NSDictionary *defaultsToRegister = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3", @"UserAgent", nil];

	//Change Web View user agent for supporting GEO Settings
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [self setInitialVariables];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //---facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
	if ([[CommonFunction getValueFromUserDefault:kUserType]isEqualToString:@"Merchant"]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
		UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@" "];
		self.window.rootViewController = viewController;
        
		[self setInitialVariablesForMerchant];
		[self.window makeKeyAndVisible];
		
	}
    else
    {

    }
    if(dictUserInfo.allKeys.count == 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"KSSplashVC"];
        navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.navController.navigationBarHidden = YES;
        
        self.window.rootViewController = navController;
        [self addBottomADView];

        //        [self setInitialVariablesForMerchant];
        [self.window makeKeyAndVisible];

        
    }
    else
    {
        [self getPaymentTokenForNewuser];

        // Override point for customization after application launch.
    }

	//[self addSideNavigation];
	//[self addLeftRightGestures];
    
#ifdef __IPHONE_8_0
    //Right, that is the point
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    else {
        
#endif
        //register to receive notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    
	[self addNotifications];

	NSDictionary *remoteNotificationObj = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
	if (remoteNotificationObj) {
		[self performSelector:@selector(calldidReceiveRemoteNotification:) withObject:remoteNotificationObj afterDelay:0.1];
	}
//Added by Utkarsha on 25th July for geo-fencing task
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
    if (![CLLocationManager locationServicesEnabled]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Services Disabled", nil)
                                    message:NSLocalizedString(@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled.", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
    else
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        [self.locationManager startUpdatingLocation];
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    

}
- (void)addNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(hideSideControls)
	                                             name:@"hideSideControls"
	                                           object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(showSideControls)
	                                             name:@"showSideControls"
	                                           object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	checkToStopMethodCall = FALSE;
	NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:kAppDelegate.dictUserInfo];
	[[NSUserDefaults standardUserDefaults] setObject:newdata forKey:kdictUserInfo];
	[[NSUserDefaults standardUserDefaults] synchronize];

	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

	//Added by Utkarsha on 25th July for geo-fencing task
    self.locationManager = [[CLLocationManager alloc] init];
   self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
    NSLog(@"Entered Background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[self callAdsWebService:strlatitude longitude:strlongitude];
    if([self.navController.topViewController isKindOfClass:[IBRegisterVC class]] || [self.navController.visibleViewController isKindOfClass:[IBRegisterVC class]])
    {
        if([[[self.dictUserInfo valueForKey:@"userDetail"] valueForKey:@"profileImage"]length]<=0 && [[CommonFunction  getValueFromUserDefault:@"zipCode"] length]<=0)
        {
            [self getPaymentToken];

        }

    }
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
-(void)getPaymentToken
{
    NSLog(@"%@ %@",self.navController.topViewController, self.navController.visibleViewController);
    [kAppDelegate showProgressHUD:self.window];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSLog(@"GetPaymentToken");
    [dict setValue:userID forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetPaymnetToken] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]])
        {
            [kAppDelegate setDictUserInfo:nil];
            
            [CommonFunction setValueInUserDefault:kZipCode value:@""];
            [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            IBLoginVC *objIBLoginVC;
            if (kDevice == kIphone) {
                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
            }
            else {
                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
            }
            [self.navController pushViewController:objIBLoginVC animated:YES];
            [kAppDelegate hideProgressHUD];

        }
        else
        {
            if ([[result valueForKey:@"isSubscribed"]isEqualToString:@"1"]) {
                
//                if(![[result valueForKey:@"last_name"] isEqual:[NSNull null]] && [[result valueForKey:@"last_name"] length]>0)
//                {
//                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
//                    
//                }
//                else
//                {
                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                    
//                }
                [CommonFunction setValueInUserDefault:@"last_name" value:[result valueForKey:@"last_name"]];
                
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"address" value:[result valueForKey:@"address"]];
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"EmailId" value:[result valueForKey:@"email"]];
                [CommonFunction setValueInUserDefault:@"zipCode" value:[result valueForKey:@"zipcode"]];
                [CommonFunction setValueInUserDefault:@"SelectedState" value:[result valueForKey:@"stateName"]];
                [CommonFunction setValueInUserDefault:@"SelectedCity" value:[result valueForKey:@"cityName"]];
                [CommonFunction setValueInUserDefault:@"SelectedStateID" value:[result valueForKey:@"stateId"]];
                [CommonFunction setValueInUserDefault:@"SelectedCityID" value:[result valueForKey:@"cityId"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
                [kAppDelegate hideProgressHUD];
            }
            else if([[result valueForKey:@"email"] length]>0)
            {
                NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
                if([[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 1)
                {
                    [kAppDelegate hideProgressHUD];
                    
                }
                else
                {
                if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 0)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kExtraDonationLink,userID]]];
                    
                }
                else
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kExtraDonationPaymentLink,userID]]];
                    
                }
                }
            }
            else
            {
                [kAppDelegate setDictUserInfo:nil];
                
                [CommonFunction setValueInUserDefault:kZipCode value:@""];
                [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                IBLoginVC *objIBLoginVC;
                if (kDevice == kIphone) {
                    objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
                }
                else {
                    objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
                }
                [self.navController pushViewController:objIBLoginVC animated:YES];
                
                //objIBLoginVC.classType = kOffers;
            }
        }
      


    }
                     errorBlock:^(NSError *error) {
                         if (error.code == NSURLErrorTimedOut) {
                             [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                         }
                         else{
                             [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
                         [kAppDelegate hideProgressHUD];
                         
                     }];
}

-(void)getPaymentTokenForNewuser
{
    NSLog(@"%@ %@",self.navController.topViewController, self.navController.visibleViewController);
    [kAppDelegate showProgressHUD:self.window];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSLog(@"GetPaymentToken");
    [dict setValue:userID forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetPaymnetToken] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]])
        {
            [kAppDelegate setDictUserInfo:nil];
            
            [CommonFunction setValueInUserDefault:kZipCode value:@""];
            [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
//            IBLoginVC *objIBLoginVC;
//            if (kDevice == kIphone) {
//                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
//            }
//            else {
//                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
//            }
//            [self.navController pushViewController:objIBLoginVC animated:YES];
            [kAppDelegate hideProgressHUD];
            
        }
        else
        {
            if ([[result valueForKey:@"isSubscribed"]isEqualToString:@"1"]) {
                
                //                if(![[result valueForKey:@"last_name"] isEqual:[NSNull null]] && [[result valueForKey:@"last_name"] length]>0)
                //                {
                //                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                //
                //                }
                //                else
                //                {
                [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                
                //                }
                [CommonFunction setValueInUserDefault:@"last_name" value:[result valueForKey:@"last_name"]];
                
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"address" value:[result valueForKey:@"address"]];
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"EmailId" value:[result valueForKey:@"email"]];
                [CommonFunction setValueInUserDefault:@"zipCode" value:[result valueForKey:@"zipcode"]];
                [CommonFunction setValueInUserDefault:@"SelectedState" value:[result valueForKey:@"stateName"]];
                [CommonFunction setValueInUserDefault:@"SelectedCity" value:[result valueForKey:@"cityName"]];
                [CommonFunction setValueInUserDefault:@"SelectedStateID" value:[result valueForKey:@"stateId"]];
                [CommonFunction setValueInUserDefault:@"SelectedCityID" value:[result valueForKey:@"cityId"]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
                [kAppDelegate hideProgressHUD];
                if (kDevice == kIphone) {
                    objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC" bundle:nil];
                }
                else {
                    objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC_iPad" bundle:nil];
                }
                
                /**Initial miles set in merchant class**/
                navController = [[UINavigationController alloc] initWithRootViewController:objIBCategoryVC];
                self.navController.navigationBarHidden = YES;
                /*commented by Utkarsha to hide Ads it not available
                 [self addBottomADView];
                 */
                
                [self.window makeKeyAndVisible];
                
                objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
                
                sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:navController leftViewController:objSideBarVC rightViewController:nil];
                
                sideMenuController.leftViewWidth = 260.0;
                sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
                [self.window setRootViewController:sideMenuController];
                [self addBottomADView];

                [self.window makeKeyAndVisible];

            }
            else {
                if([[CommonFunction getValueFromUserDefault:kIsPaymentScreenCompleted]boolValue]==1)
                {
                    IBRegisterVC *objIBRegisterVC;
                    if (kDevice==kIphone)
                    {
                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
                    }
                    else
                    {
                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
                    }
                    objIBRegisterVC.strEditProfile=@"Edit";
                    kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:objIBRegisterVC];
                    //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                    objIBRegisterVC.strController = @"My Profile";
                    objIBRegisterVC.isNewUser=true;
                    objIBRegisterVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];

                    //    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
                    
                    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
                    kAppDelegate.navController.navigationBarHidden=true;
                    
                    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
                    
                    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
                    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
                    [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];
                    [self addBottomADView];

                    [self.window makeKeyAndVisible];

                }
                else
                {
                    PaymentProgramVC *objPaymentProgramVC;
                    if (kDevice==kIphone) {
                        objPaymentProgramVC=[[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC" bundle:nil];
                    }
                    else{
                        objPaymentProgramVC=[[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC_iPad" bundle:nil];
                    }
                    //            objIBRegisterVC.strEditProfile=@"Edit";
                    //            //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                    //            objIBRegisterVC.strController = @"My Profile";
                    //            objIBRegisterVC.isNewUser=YES;
                    //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
                    //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
                    //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
                    // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
                    objPaymentProgramVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
                    kAppDelegate.navController= [[UINavigationController alloc]initWithRootViewController:objPaymentProgramVC];
                    kAppDelegate.navController.navigationBarHidden=true;
                    [kAppDelegate.window setRootViewController:kAppDelegate.navController];
                    [self addBottomADView];

                    [self.window makeKeyAndVisible];


                }

                
            }
        }
        
        
        
    }
                     errorBlock:^(NSError *error) {
                         if (error.code == NSURLErrorTimedOut) {
                             [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                         }
                         else{
                             [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
                         [kAppDelegate hideProgressHUD];
                         
                     }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	//[FBAppEvents activateApp];
	//[FBSession.activeSession handleDidBecomeActive];
	[FBAppCall handleDidBecomeActiveWithSession:FBSession.activeSession];
     //[self.locationManager startMonitoringSignificantLocationChanges];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[FBSession.activeSession closeAndClearTokenInformation];
	//[FBSession.activeSession close];
}

#pragma mark Set Initial Variables
- (void)setInitialVariables {
	if (kDevice == kIphone) {
		complteHiddenSideNav = 320;
		hiddenSideNavigationX = 297;
		showSideNavigationX = 195;
		swipeViewWidth = 133;
		sideNavigationY = 0;
		swipeViewHeight = self.window.frame.size.height;
		fontSize = 16.0;
		fontSizeSmall = 15.0;
		fontSizeSmallest = 12.0;
	}
	else {
		complteHiddenSideNav = 768;
		hiddenSideNavigationX = 720;
		showSideNavigationX = 540;
		sideNavigationY = 0;
		swipeViewWidth = 235;
		swipeViewHeight = self.window.frame.size.height;
		fontSize = 22.0;
		fontSizeSmall = 20.0;
		fontSizeSmallest = 17.0;
	}
	lblAdsTitle.text = @"Fetching ads";
	countAdsIndex = 0;
	dictUserInfo = [[NSMutableDictionary alloc]init];
	/*
	   Method to get user default values for App delegate dictionaries*/
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:kdictUserInfo];
	if ([data length] > 0) {
		NSDictionary *dictUserInfoDefaults = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:dictUserInfoDefaults];
	}
	[CommonFunction setValueInUserDefault:kMiles value:@"50"];
}

- (void)setInitialVariablesForMerchant {
	if (kDevice == kIphone) {
		fontSize = 16.0;
		fontSizeSmall = 15.0;
		fontSizeSmallest = 12.0;
	}
	else {
		fontSize = 22.0;
		fontSizeSmall = 20.0;
		fontSizeSmallest = 17.0;
	}
}

#pragma mark -
#pragma mark - Progress HUD

/**-
   @Method - showProgressHUD: -> Perform activity Indicator functionality

 */

- (void)showProgressHUD:(UIView *)view {
	if (!HUD) {
		HUD = [[MBProgressHUD alloc] initWithView:view];
		[view addSubview:HUD];
		HUD.delegate = self;
		HUD.labelText = @"Loading";
	}
	[HUD show:YES];
}

/**-
   @Method - showProgressHUD -> Perform activity Indicator functionality

 */
- (void)showProgressHUD {
	[self showProgressHUD:self.window];
}

/**-
   @Method - hideProgressHUD -> Hide activity Indicator functionality

 */
- (void)hideProgressHUD {
	if (HUD) {
		[HUD hide:YES];
		HUD = nil;
	}
}

#pragma mark -
#pragma mark - Side Navigation Methods

- (void)addSideNavigation {
	/*if (kDevice == kIphone) {
		objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
		objSideBarVC.view.frame = CGRectMake(hiddenSideNavigationX, sideNavigationY, swipeViewWidth, swipeViewHeight);
	}
	else {
		objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC_iPad" bundle:nil];
		objSideBarVC.view.frame = CGRectMake(hiddenSideNavigationX, sideNavigationY, swipeViewWidth, swipeViewHeight);
	}
    [objSideBarVC showView];*/
    NSLog(@"slide func");
	UIWindow *window = [UIApplication sharedApplication].keyWindow;

	if (window.windowLevel == 1996 || !window || window.windowLevel == UIWindowLevelAlert)
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[[[window subviews] objectAtIndex:0] addSubview:objSideBarVC.view];
	[[[window subviews] objectAtIndex:0] bringSubviewToFront:objSideBarVC.view];
	[window makeKeyAndVisible];
}

- (void)showSideControls {
	[recognizerLeft addTarget:self action:@selector(handleSwipeFromLeft:)];
	[recognizerRight addTarget:self action:@selector(handleSwipeFromRight:)];
	objSideBarVC.view.frame = CGRectMake(hiddenSideNavigationX, sideNavigationY, swipeViewWidth, swipeViewHeight);
}

- (void)hideSideControls {
	[recognizerLeft removeTarget:self action:nil];
	[recognizerRight removeTarget:self action:nil];
	objSideBarVC.view.frame = CGRectMake(complteHiddenSideNav, sideNavigationY, swipeViewWidth, swipeViewHeight);
}

- (void)showMenu {
    [objSideBarVC.tblMenu reloadData];
    [sideMenuController showLeftViewAnimated];
}

- (void)hideMenu {
    [objSideBarVC.tblMenu reloadData];
    [sideMenuController hideLeftViewAnimated];
}

/*
   Method to hide side navigation after some interval
 */

- (void)hideSideNavigation {
	[CommonFunction callHideViewFromSideBar];
}

#pragma mark -
#pragma mark - Gesture Methods
- (void)addLeftRightGestures {
	recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
	[recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[self.window addGestureRecognizer:recognizerRight];


	recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
	[recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	[self.window addGestureRecognizer:recognizerLeft];
}

- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)recognizer {
	[CommonFunction callHideViewFromSideBar];
}

- (void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)recognizer {
	[CommonFunction callShowViewFromSideBar];
}

#pragma mark -
#pragma mark - Orientation Change Methods


- (void)handleOrientationChangeNotification:(NSNotification *)notification {
	if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
		[recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
		[recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
		/*commented by Utkarsha to hide Ads it not available
		   [self addADSViewPortrait];
		 */
		// [self addADSViewPortrait];
	}
	else if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)) {
		[recognizerRight setDirection:(UISwipeGestureRecognizerDirectionLeft)];
		[recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionRight)];
	}
}

- (void)addADSViewPortrait {
	/**ShiftNavigation set True False not to subract height of subviews always*/
//    if(iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//    if (shiftNavigation==FALSE) {
//        for (UIView *view in self.navController.view.subviews) {
//            view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height- 40);
//
//        }
//        shiftNavigation=TRUE;
//    }
//    }
}

- (void)hideAdView {
//    /**ShiftNavigation set True False not to subract height of subviews always*/
//    if(iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        if (shiftNavigation==FALSE) {
//            for (UIView *view in self.navController.view.subviews) {
//                view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+ 40);
//                [[[self.window subviews] objectAtIndex:0] bringSubviewToFront:objSideBarVC.view];
//                [self.window makeKeyAndVisible];
//            }
//            shiftNavigation=TRUE;
//        }
//    }
}

#pragma mark - APNS delegate methods
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSString *strDeviceTocken = [deviceToken description];
	strDeviceTocken = [strDeviceTocken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	strDeviceTocken = [strDeviceTocken stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[NSUserDefaults standardUserDefaults] setValue:strDeviceTocken forKey:kDeviceToken];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"user Info :::::::: %@", userInfo);
	[self calldidReceiveRemoteNotification:userInfo];
}

- (void)calldidReceiveRemoteNotification:(NSDictionary *)userInfo {
	if (![[[userInfo valueForKey:@"aps"] valueForKey:@"merchantId"] isEqualToString:@"-1"] && [[[userInfo valueForKey:@"aps"] valueForKey:@"paymentStatus"] isEqualToString:@"-1"]) {
		strNotifiedMerchantID = [[userInfo valueForKey:@"aps"] valueForKey:@"merchantId"];
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
			NSString *string = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
			alert.tag = 101;
			[alert show];
		}
		else if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
			[self pushAfterOfferNotification];
		}
	}
	else if (![[[userInfo valueForKey:@"aps"] valueForKey:@"paymentStatus"] isEqualToString:@"-1"] && [[[userInfo valueForKey:@"aps"] valueForKey:@"merchantId"] isEqualToString:@"-1"]) {
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
			NSString *string = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			alert.tag = 103;
			[alert show];
		}
		else if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
			[self pushAfterSuccessfulPayment];
		}
	}
	else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"merchantId"] isEqualToString:@"-1"] && [[[userInfo valueForKey:@"aps"] valueForKey:@"paymentStatus"] isEqualToString:@"-1"]) {
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
			NSString *string = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
			alert.tag = 102;
			[alert show];
		}
		else if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
			[self pushAfterSuccessfulNotification];
		}
	}
	[self decreaseBadgeCount];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)pushAfterOfferNotification {
	self.objSideBarVC.lastbtnClicked = self.objSideBarVC.btnMyOffers;
	IBOffersVC *objIBOffersVC;
	if (kDevice == kIphone) {
		objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOffersVC" bundle:nil];
	}
	else {
		objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOfffersVC_iPad" bundle:nil];
	}
	NSMutableDictionary *dictMerchantInfo = [[NSMutableDictionary alloc]init];
	[dictMerchantInfo setValue:strNotifiedMerchantID forKey:@"merchantId"];
	objIBOffersVC.dictMerchantInfo = dictMerchantInfo;
	[CommonFunction setValueInUserDefault:kZipCode value:[[kAppDelegate dictUserInfo]valueForKey:@"zipcode"]];
	[objIBCategoryVC viewDidLoad];
	NSArray *stack = [NSArray arrayWithObjects:objIBCategoryVC, objIBOffersVC, nil];
	navController.viewControllers = stack;
}

- (void)pushAfterSuccessfulPayment {
	[[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
	/*commented in order to implement not to log out unpaid user*/
	//[[kAppDelegate dictUserInfo]setValue:[CommonFunction getValueFromUserDefault:kUserId] forKey:@"userId"];
	self.objSideBarVC.lastbtnClicked = self.objSideBarVC.btnProfile;
	IBDashboardVC *objIBDashboardVC;
	if (kDevice == kIphone) {
		objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
	}
	else {
		objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
	}
	[self.navController pushViewController:objIBDashboardVC animated:YES];
}

- (void)pushAfterSuccessfulNotification {
	/*commented in order to implement not to log out unpaid user*/

	self.objSideBarVC.lastbtnClicked = self.objSideBarVC.btnCommTool;

	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
	NSLog(@"userID >>> %@  userPayment >>> %@  userCompleteIncomplete >>> %@", userID, userPayment, userCompleteIncomplete);
	if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
		IBCommunicationToolVC *objIBCommunicationToolVC;
		if (kDevice == kIphone) {
			objIBCommunicationToolVC = [[IBCommunicationToolVC alloc]initWithNibName:@"IBCommunicationToolVC" bundle:nil];
		}
		else {
			objIBCommunicationToolVC = [[IBCommunicationToolVC alloc]initWithNibName:@"IBCommunicationToolVC_iPad" bundle:nil];
		}
		[self.navController pushViewController:objIBCommunicationToolVC animated:YES];
	}
	else if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"0"]) {
		/**** Added by Utkarsha to enable complete registration*****/
		IBRegisterVC *objIBRegisterVC;
		if (kDevice == kIphone) {
			objIBRegisterVC = [[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
		}
		else {
			objIBRegisterVC = [[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
		}
		objIBRegisterVC.strEditProfile = @"Edit";
		objIBRegisterVC.strDetailRegistration = @"DetailRegistration";
		objIBRegisterVC.strController = @"My Profile";
		objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
		[self.navController pushViewController:objIBRegisterVC animated:NO];
		/******/
	}
	else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
		[self callPaymentClass];

		/* Commented and added by Utkarsha to navigate to Extra Donation screen
		 *****/
	}
	else {
		IBLoginVC *objIBLoginVC;

		if (kDevice == kIphone) {
			objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
		}
		else {
			objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
		}
		objIBLoginVC.classType = @"Cards";
		[self.navController pushViewController:objIBLoginVC animated:NO];
	}
}

- (void)callPaymentClass {
//	if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 0) {
//		IBExtraDonationVC *objIBExtraDonationVC;
//		if (kDevice == kIphone) {
//			objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC" bundle:nil];
//		}
//		else {
//			objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC_iPad" bundle:nil];
//		}
//		// objIBExtraDonationVC.strClassTypeForPaymentScreen=@"Cards";
//		[self.navController pushViewController:objIBExtraDonationVC animated:NO];
//	}
//	else {
		IBPaymentVC *objIBPaymentVC;
		if (kDevice == kIphone) {
			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
		}
		else {
			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
		}
		//  objIBPaymentVC.strClassTypeForPaymentScreen=@"Cards";
		[self.navController pushViewController:objIBPaymentVC animated:NO];
//	}
}

#pragma mark - Fetch Merchant offers

- (void)callLocationService:(NSString *)lat andlongitute:(NSString *)longi {
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:lat forKey:@"lat"];
	[dict setValue:longi forKey:@"long"];
	[dict setValue:userID forKey:@"userId"];
	NSLog(@"dict :::%@", dict);
	dispatch_sync(dispatch_get_main_queue(), ^{
	    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGeoFencingNotification] completeBlock: ^(NSData *data) {
	        id result = [NSJSONSerialization JSONObjectWithData:data
	                                                    options:kNilOptions error:nil];
	        NSLog(@"Result :::%@", result);
	        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
			}
	        else
			//	[CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
	        [kAppDelegate hideProgressHUD];
		} errorBlock: ^(NSError *error) {
	        if (error.code == NSURLErrorTimedOut) {
	           // [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
			}
	        else {
	           // [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
			}
	        [kAppDelegate hideProgressHUD];
		}];
	});
}

#pragma mark - CLLocationManager Delegate
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"I am in the background");
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    // ANY CODE WE PUT HERE IS OUR BACKGROUND TASK

    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%g",
                                 newLocation.coordinate.latitude];
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%g",
                                  newLocation.coordinate.longitude];
    [CommonFunction setValueInUserDefault:kLatitude value:currentLatitude];
    [CommonFunction setValueInUserDefault:kLongitude value:currentLongitude];

    NSLog(@"I am in the bgTask, my lat %@", currentLatitude);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
	    //[self callLocationService:currentLatitude andlongitute:currentLongitude];
	});


    // AFTER ALL THE UPDATES, close the task

    if (bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }


}
-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"I am in the background");
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    // ANY CODE WE PUT HERE IS OUR BACKGROUND TASK

    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%g",
                                 newLocation.coordinate.latitude];
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%g",
                                  newLocation.coordinate.longitude];
    [CommonFunction setValueInUserDefault:kLatitude value:currentLatitude];
    [CommonFunction setValueInUserDefault:kLongitude value:currentLongitude];
    NSLog(@"I am in the bgTask, my lat %@", currentLatitude);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
	  //  [self callLocationService:currentLatitude andlongitute:currentLongitude];
	});


    // AFTER ALL THE UPDATES, close the task

    if (bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}
#pragma mark - Alertview

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0 && alertView.tag == 101) {
		if (![self.navController.visibleViewController isKindOfClass:[IBOffersVC class]]) {
			[self pushAfterOfferNotification];
		}
	}
	else if (buttonIndex == 0 && alertView.tag == 103) {
		if (![self.navController.visibleViewController isKindOfClass:[IBDashboardVC class]])
			[self pushAfterSuccessfulPayment];
	}
	else if (buttonIndex == 0 && alertView.tag == 102) {
		if (![self.navController.visibleViewController isKindOfClass:[IBCommunicationToolVC class]])
			[self pushAfterSuccessfulNotification];
	}
}

- (void)decreaseBadgeCount {
	[UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;

	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
	[dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
	[dict setValue:deviceTest forKey:@"deviceType"];
	[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kUpdateNotifyCnt] completeBlock: ^(NSData *data) {
	    [kAppDelegate hideProgressHUD];
	} errorBlock: ^(NSError *error) {
	    if (error.code == NSURLErrorTimedOut) {
	        [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
		}
	    else {
	        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
		}
	    [kAppDelegate hideProgressHUD];
	}];
}

#pragma mark Create Window Again After Log Out

- (void)createWindowAgain {
	self.window = nil;
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	if ([[CommonFunction getValueFromUserDefault:kUserType]isEqualToString:@"Merchant"]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
		UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
		self.window.rootViewController = viewController;
		[self setInitialVariablesForMerchant];

		[self.window makeKeyAndVisible];
		return;
	}
	// Override point for customization after application launch.
	if (kDevice == kIphone) {
		objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC" bundle:nil];
	}
	else {
		objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC_iPad" bundle:nil];
	}

	[self setInitialVariables];
	/**Initial miles set in merchant class**/
	navController = [[UINavigationController alloc] initWithRootViewController:objIBCategoryVC];
	self.navController.navigationBarHidden = YES;
	/*commented
	   [self addBottomADView];
	 */
	[self addBottomADView];
	[self.window setRootViewController:navController];
	[self.window makeKeyAndVisible];
	[self performSelector:@selector(addSideNavigation) withObject:nil afterDelay:0.3];
	[self addLeftRightGestures];
	[[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	[self addNotifications];
//    if(iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//    for (UIView *view in self.navController.view.subviews) {
//        view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height- 40);
//    }
//    }
}

#pragma mark Add Ads View

- (void)addBottomADView {
	adsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 44)];
	adsView.backgroundColor = [UIColor clearColor];
	imgViewAdsBase = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, adsView.frame.size.width, 44)];
	if (kDevice == kIphone) {
		imgViewAdsBase.image = [UIImage imageNamed:@"Ad_BottomBG@2x.png"];
	}
	else {
		imgViewAdsBase.image = [UIImage imageNamed:@"Ad_BottomBG~ipad.png"];
	}
	imgViewAdsBase.userInteractionEnabled = TRUE;
	[adsView addSubview:imgViewAdsBase];

	imgViewAdsThumb.userInteractionEnabled = YES;
	imgViewAdsThumb = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 35, 35)];
	imgViewAdsThumb.backgroundColor = [UIColor clearColor];
	[adsView addSubview:imgViewAdsThumb];

	lblAdsTitle = [[UILabel alloc]initWithFrame:CGRectMake(imgViewAdsThumb.frame.size.width + imgViewAdsThumb.frame.origin.x + 5, imgViewAdsThumb.frame.origin.y, adsView.frame.size.width - imgViewAdsThumb.frame.size.width, imgViewAdsThumb.frame.size.height / 2)];
	lblAdsTitle.backgroundColor = [UIColor clearColor];
	lblAdsTitle.textColor = [UIColor whiteColor];
	lblAdsTitle.font = [UIFont fontWithName:kFont size:12.0];
	lblAdsTitle.text = @"AD Space";
	[adsView addSubview:lblAdsTitle];

	lblAdsDescription = [[UILabel alloc]initWithFrame:CGRectMake(imgViewAdsThumb.frame.size.width + imgViewAdsThumb.frame.origin.x + 5, lblAdsTitle.frame.origin.y + lblAdsTitle.frame.size.height + 2, adsView.frame.size.width - imgViewAdsThumb.frame.size.width, imgViewAdsThumb.frame.size.height / 2)];
	lblAdsDescription.backgroundColor = [UIColor clearColor];
	lblAdsDescription.textColor = [UIColor whiteColor];
	[adsView addSubview:lblAdsDescription];
	lblAdsDescription.font = [UIFont fontWithName:kFont size:12.0];

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdsView:)];
	[imgViewAdsBase addGestureRecognizer:singleTap];

	[self hideToolbar];
	[navController.toolbar setBarStyle:UIBarStyleBlackOpaque];
	[navController.toolbar addSubview:adsView];
	//[self.window bringSubviewToFront:navController.toolbar];
}

- (void)callAdsWebService:(NSString *)latitude longitude:(NSString *)longitude {
	if (checkToStopMethodCall == FALSE) {
		checkToStopMethodCall = TRUE;
		/*Added by Utkarsha (Called here to show Ads) */
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:latitude forKey:@"lat"]; //@"34.3230497"
		[dict setValue:longitude forKey:@"long"]; //@"-80.8765205"
		[dict setValue:[self.dictUserInfo valueForKey:@"userId"] forKey:@"userId"];
		[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetAds] completeBlock: ^(NSData *data) {
		    id result = [NSJSONSerialization JSONObjectWithData:data
		                                                options:kNilOptions error:nil];
		    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
		        arrAds = [result valueForKey:@"ads"];
		        [self.adTimer invalidate];
		        self.adTimer = nil;
		        [self callAdsArray];
		        self.adTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(callAdsArray) userInfo:nil repeats:YES];
		        [navController setToolbarHidden:NO animated:YES];
		        [[[self.window subviews] objectAtIndex:0] bringSubviewToFront:objSideBarVC.view];
		        [self.window makeKeyAndVisible];
		        /*Added by Utkarsha if Ad is available */
			}
		    else if ([[dict valueForKey:@"status"] intValue] == 0) {
		        imgViewAdsThumb.backgroundColor = [UIColor darkGrayColor];
		        lblAdsTitle.text = @"No ads available currently";
		        /*Added by Utkarsha (Called here to hide Ads) */
		        [self hideToolbar];

		        //
			}
		    else if ([[dict valueForKey:@"status"] intValue] == -1) {
		        lblAdsTitle.text = @"Error while fetching ads";
		        /*Added by Utkarsha (Called here to hide Ads) */
		        [self hideToolbar];
			}
		    else {
		        lblAdsTitle.text = @"Error while fetching ads";
		        /*Added by Utkarsha (Called here to hide Ads) */
		        [self hideToolbar];
			}
		} errorBlock: ^(NSError *error) {
		}];
	}
}

- (void)callAdsArray {
	if (countAdsIndex == [arrAds count]) {
		countAdsIndex = 0;
	}
	lblAdsDescription.text = [[arrAds valueForKey:@"description"]objectAtIndex:countAdsIndex];
	lblAdsTitle.text = [[arrAds valueForKey:@"merchantName"]objectAtIndex:countAdsIndex];
	strADImageURL = [[arrAds valueForKey:@"image"]objectAtIndex:countAdsIndex];
	[self displayAdsThumb:[[arrAds valueForKey:@"thumb"]objectAtIndex:countAdsIndex]];
	countAdsIndex++;
}

- (void)displayAdsThumb:(NSString *)strImageURL {
	if ([strImageURL length] > 0) {
		imgViewAdsThumb.backgroundColor = [UIColor clearColor];
		imgViewAdsThumb.contentMode = UIViewContentModeScaleAspectFit;
		[imgViewAdsThumb setImageWithURL:[NSURL URLWithString:strImageURL]
		                placeholderImage:[UIImage imageNamed:@""]];
	}
	else {
		imgViewAdsThumb.backgroundColor = [UIColor darkGrayColor];
	}
}

- (void)clickAdsView:(id)sender {
	if ([strADImageURL length] > 0) {
		if (kDevice != kIphone) {
			[self viewFullAdImageOnIpad];
			return;
		}

		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];

		UIImageView *transparentImgView = [[UIImageView alloc] initWithFrame:view.frame];
		transparentImgView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"popUp_bk@2x" ofType:@"png"]];
		[view addSubview:transparentImgView];


		UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.origin.x + 20, view.frame.origin.y + 40, view.frame.size.width - 40, view.frame.size.height - 80)];
		backgroundImgView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Blank_BG@2x" ofType:@"png"]];
		[view addSubview:backgroundImgView];

		UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 255, 30)];
		title.textAlignment = NSTextAlignmentCenter;
		title.font = [UIFont fontWithName:kFont size:15];
		title.text =  lblAdsTitle.text;
		title.backgroundColor = [UIColor clearColor];
		[view addSubview:title];

		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 80, 150, 150)];
		[imgView setImageWithURL:[NSURL URLWithString:strADImageURL] placeholderImage:[UIImage imageNamed:@""]];
		imgView.layer.cornerRadius = 4.0;
		imgView.layer.masksToBounds = YES;
		[view addSubview:imgView];

		UITextView *detail = [[UITextView alloc] initWithFrame:CGRectMake(backgroundImgView.frame.origin.x, imgView.frame.size.height + imgView.frame.origin.y + 10, backgroundImgView.frame.size.width, 200)];
		detail.text =  lblAdsDescription.text;
		detail.textAlignment = NSTextAlignmentCenter;
		detail.editable = NO;
		detail.font = [UIFont fontWithName:kFont size:15];
		detail.backgroundColor = [UIColor clearColor];
		[view addSubview:detail];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		if (kDevice == kIphone) {
			button.frame = CGRectMake(280, 25, 31, 33);
		}
		else {
			button.frame = CGRectMake(730, 35, 31, 33);
		}

		[button setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CrossButton@2x" ofType:@"png"]] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(removePhotoView:) forControlEvents:UIControlEventTouchUpInside];
		[view addSubview:button];
		[self.window addSubview:view];
		[kAppDelegate showProgressHUD:view];

		view.alpha = 0;
		[[SharedManager sharedManager] subViewAnimation:view];
	}
	else {
		[CommonFunction fnAlert:@"Alert" message:@"No Ads"];
	}
}

- (void)removePhotoView:(UIButton *)sender {
	[[SharedManager sharedManager]removeAnimation:sender.superview];
}

- (void)viewFullAdImageOnIpad {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];

	UIImageView *transparentImgView = [[UIImageView alloc] initWithFrame:view.frame];
	transparentImgView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"popUp_bk@2x" ofType:@"png"]];
	[view addSubview:transparentImgView];


	UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.origin.x + 100, view.frame.origin.y + 100, view.frame.size.width - 200, view.frame.size.height - 200)];
	backgroundImgView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Blank_BG@2x" ofType:@"png"]];
	[view addSubview:backgroundImgView];

	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(234, 120, 300, 30)];
	title.textAlignment = NSTextAlignmentCenter;
	title.font = [UIFont fontWithName:kFont size:15];
	title.text =  lblAdsTitle.text;
	title.backgroundColor = [UIColor clearColor];
	[view addSubview:title];

	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(284, title.frame.origin.y + title.frame.size.height + 10, 200, 200)];
	[imgView setImageWithURL:[NSURL URLWithString:strADImageURL] placeholderImage:[UIImage imageNamed:@""]];
	//    imgView.image = imgViewAdsThumb.image;
	imgView.layer.cornerRadius = 4.0;
	imgView.layer.masksToBounds = YES;
	[view addSubview:imgView];

	UITextView *detail = [[UITextView alloc] initWithFrame:CGRectMake(backgroundImgView.frame.origin.x, imgView.frame.size.height + imgView.frame.origin.y + 10, backgroundImgView.frame.size.width, 300)];
	detail.text =  lblAdsDescription.text;
	detail.textAlignment = NSTextAlignmentCenter;

	detail.font = [UIFont fontWithName:kFont size:15];
	detail.backgroundColor = [UIColor clearColor];
	[view addSubview:detail];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(650, 85, 43, 45);
	[button setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CrossButton~ipad" ofType:@"png"]] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(removePhotoView:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	[self.window addSubview:view];
	[kAppDelegate showProgressHUD:view];

	view.alpha = 0;
	[[SharedManager sharedManager] subViewAnimation:view];
}

#pragma mark - fetch current location

- (void)fetchAdslocation:(CLLocation *)location error:(NSError *)error {
	if (error) {
		lblAdsTitle.text = @"Unable to get current location";
		[self hideToolbar];
	}
	else {
		strlatitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
		strlongitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
		[self callAdsWebService:strlatitude longitude:strlongitude];
	}
//    strlatitude = [NSString stringWithFormat:@"%f", 43.091548];
//    strlongitude = [NSString stringWithFormat:@"%f", -77.648938];
//    [self callAdsWebService:strlatitude longitude:strlongitude];

}

- (void)hideToolbar {
	if (navController.toolbarHidden != YES) {
		navController.toolbarHidden = YES;
	}
}
-(void)fnAlert:(NSString*) Title tag:(NSInteger)tag dict:(NSDictionary*) offerDict1{
//	NSString *strMessage = [NSString stringWithFormat:@"Please donate from this savings in the ongoing support of %@.", [[offerDict1 valueForKey:@"donation_criteria"]valueForKey:@"npo_title"]];
//    strMessage = [strMessage stringByAppendingString:@"\n"];
//    strMessage = [strMessage stringByAppendingString:@" A transaction Fee required by our payment processor will also be applied."];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thanks for Saving with iBC." message:strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"PLU$1\u2122"], [NSString stringWithFormat:@"PLU$2\u2122"], [NSString stringWithFormat:@"PLU$3\u2122"], [NSString stringWithFormat:@"PLU$5\u2122"], nil];
//    offerDict = offerDict1;
//    alert.tag = kDonationAlertTag;
//    alert.delegate = self;
//    [alert show];
    NSString *strMessage = [NSString stringWithFormat:@"Please Donate a \"Kick it Back\" portion of your Savings to \"Fire Rescue Funding\"."];
    strMessage = [strMessage stringByAppendingString:@"\n"];
    strMessage = [strMessage stringByAppendingString:@" A small cc transaction fee applies.."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Kick it Back." message:strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"PLU$1\u2122"], [NSString stringWithFormat:@"PLU$2\u2122"], [NSString stringWithFormat:@"PLU$3\u2122"], [NSString stringWithFormat:@"PLU$5\u2122"], nil];
    offerDict = offerDict1;
    alert.tag = kDonationAlertTag;
    alert.delegate = self;
    [alert show];
 //   Kick it Back
    
}
#pragma mark - UIAlertView Delegate
- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (alertView.tag == kDonationAlertTag) {
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
			if (!kIphone) {
				[alertView setFrame:CGRectMake(17, 30, 286, 390)];
				alertView.center = CGPointMake(self.window.center.x, self.window.center.y);
				NSArray *subviewArray = [alertView subviews];
				NSLog(@"%@", subviewArray);
				UITextView *message = (UITextView *)[subviewArray objectAtIndex:8];
				[message setFrame:CGRectMake(12, 60, 260, 55)];
				UILabel *messagelbl = (UILabel *)[subviewArray objectAtIndex:2];
				[messagelbl setFrame:CGRectMake(10, 40, 260, 70)];
                
				UIButton *plus1button = (UIButton *)[subviewArray objectAtIndex:3];
				[plus1button setFrame:CGRectMake(10, 125, 260, 40)];
				UIButton *plus2button = (UIButton *)[subviewArray objectAtIndex:4];
				[plus2button setFrame:CGRectMake(10, 175, 260, 40)];
				UIButton *plus3button = (UIButton *)[subviewArray objectAtIndex:5];
				[plus3button setFrame:CGRectMake(10, 225, 260, 40)];
				UIButton *plus4button = (UIButton *)[subviewArray objectAtIndex:6];
				[plus4button setFrame:CGRectMake(10, 275, 260, 40)];
				UIButton *cancelbutton = (UIButton *)[subviewArray objectAtIndex:7];
				[cancelbutton setFrame:CGRectMake(10, 325, 260, 40)];
			}
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ([alertView tag] == kDonationAlertTag)
    {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
            
        }
        else
        {
            if ([[[offerDict valueForKey:@"donation_criteria"]valueForKey:@"permanent_payment_token"]length] == 0) {
                IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
                if (kDevice == kIphone) {
                    objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
                }
                else {
                    objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
                }
                NSMutableDictionary *dictPayment = [[NSMutableDictionary alloc]init];
                if (buttonIndex == 1) {
                    float taxAmount = (1 * 2.9) / 100 + 0.30 + 1.0;
                    float finalTaxAmount =  (taxAmount * .029) - (1 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
                    [dictPayment setObject:@"$1.34 has been deducted from your account." forKey:@"AlertMsg"];
                }
                else if (buttonIndex == 2) {
                    float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
                    float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    
                    [dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
                    [dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
                }
                else if (buttonIndex == 3) {
                    float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
                    float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    
                    [dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
                    [dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
                }
                else if (buttonIndex == 4) {
                    float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
                    float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
                    [dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
                }
                
                [dictPayment setObject:kDonationUser forKey:@"paymentFor"];
                [dictPayment setObject:@"" forKey:@"storageToken"];
                [dictPayment setObject:KDonationThroughCreditCard forKey:@"paymentType"];
                
                objIBCreditCardPaymentVC.dictDonationOrNormalInfo = dictPayment;
                [self.navController pushViewController:objIBCreditCardPaymentVC animated:YES];
            }
            else {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
                [dict setValue:[[offerDict valueForKey:@"donation_criteria"]valueForKey:@"permanent_payment_token"] forKey:@"paymentToken"];
                [dict setObject:kDonationUser forKey:@"paymentFor"];
                [dict setObject:@"" forKey:@"storageToken"];
                //[dict setObject:@"" forKey:@"amount"];
                [dict setValue:@"" forKey:@"firstName"];
                [dict setValue:@"" forKey:@"lastName"];
                [dict setValue:@"" forKey:@"cardNumber"];
                [dict setValue:@"" forKey:@"cardType"];
                [dict setValue:@"" forKey:@"expMonth"];
                [dict setValue:@"" forKey:@"expYear"];
                if (buttonIndex == 1) {
                    float taxAmount = (1 * 2.9) / 100 + 0.30 + 1.0;
                    float finalTaxAmount =  (taxAmount * .029) - (1 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
                }
                else if (buttonIndex == 2) {
                    float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
                    float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
                }
                else if (buttonIndex == 3) {
                    float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
                    float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
                }
                else if (buttonIndex == 4) {
                    float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
                    float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
                    taxAmount = taxAmount + finalTaxAmount;
                    [dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
                }
                else {
                    return;
                }
                [kAppDelegate showProgressHUD];
                [[SharedManager sharedManager]postCreditCardData:dict
                                                   completeBlock: ^(NSData *data)
                 {
                     UIAlertView *alertView;
                     if (buttonIndex == 1) {
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"$1.34 has been deducted from your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 2) {
                         float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
                         float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 3) {
                         float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
                         float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 4) {
                         float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
                         float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     
                     [alertView show];
                 }                                     errorBlock: ^(NSError *error) {
                 }];
            }
        }
	}
}
@end
