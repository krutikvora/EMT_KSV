//
//  SideBarVC.m
//  iBuddyClient
//
//  Created by Anubha on 14/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "SideBarVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "IBReferFriendVC.h"
#import "IBCommunicationToolVC.h"

#import "IBTabDescriptionVC.h"
@interface SideBarVC ()
{
     bool appOpenedFirstTime;
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *btnMyCards;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnReferFriend;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnProfieLarge;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlViewCustom;
@property (weak, nonatomic) IBOutlet UIButton *btnWelcome;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftApp;
@property (weak, nonatomic) IBOutlet UIButton *btnWithGratitude;
@property (weak, nonatomic) IBOutlet UIImageView *imgNotificationBadge;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDetailsAbtTabs;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileImage;
@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnProfileLogin;

- (IBAction)sideButtonAction:(id)sender;

@end

@implementation SideBarVC
@synthesize btnMyCards, btnJoin, btnProfile, lastbtnClicked, viewFundraiserLogo, fundraiserImgView, fundraiserName, btnCommTool,lblNotificationCount,imgNotificationBadge,tblMenu;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
    selectedIndex = -1;

	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
    
  	[self setInitialVariables];
	//_scrlViewCustom.customDelegate=self;
    self.lblNotificationCount.hidden = YES;
    self.imgNotificationBadge.hidden = YES;
    appOpenedFirstTime=TRUE;
    
    arrMenuWithOutLogin = @[@"Join Here", @"Offers", @"Refer A Friend", @"Pay it forward", @"With Gratitude", @"Notification", @"Gift App", @"About US", @"Help"];
    arrMenuWithLogin = @[@"Join Here", @"", @"Offers", @"Refer A Friend", @"Pay it forward", @"With Gratitude", @"Notification", @"Gift App", @"About US", @"Help", @"Logout"];
    
    arrIconMenuWithOutLogin = @[@"menu-join-here", @"menu-offers", @"menu-refer-a-friend", @"menu-pay-it-forward", @"menu-with-gratitude", @"menu-notification", @"menu-gift-app", @"menu-about-us", @"menu-help"];
    
    arrIconMenuWithLogin = @[@"menu-join-here", @"menu-universal-soca", @"menu-offers", @"menu-refer-a-friend", @"menu-pay-it-forward", @"menu-with-gratitude", @"menu-notification", @"menu-gift-app", @"menu-about-us", @"menu-help", @"menu-logout"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnProfileOpen)];
    [self.viewProfile addGestureRecognizer:gestureRecognizer];

}

- (void)btnProfileOpen {
    [self btnProfileClicked:btnProfile];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidUnload {
	[self setBtnWelcome:nil];
	[self setBtnProfieLarge:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Set Initial Variables

- (void)setInitialVariables
{
    lastbtnClicked = _btnMyOffers;
    if (kDevice == kIphone)
    {
        if (IS_IPHONE_5)
        {
            _scrlViewCustom.contentSize = CGSizeMake(0, kWindowHeight + 360);
        }
        else {
            _scrlViewCustom.contentSize = CGSizeMake(0, kWindowHeight + 480);
        }
    }
    else {
        _scrlViewCustom.contentSize = CGSizeMake(0, kWindowHeight + 1100);
    }
}

#pragma mark Side Navigation methods
- (void)showView {
    [kAppDelegate showMenu];
    checkShowhideView = TRUE;

    [self setProfileImageUser];

    
    /*
	[UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationCurveEaseOut animations: ^{
	    //self.view.frame = CGRectMake([kAppDelegate showSideNavigationX], [kAppDelegate sideNavigationY], [kAppDelegate swipeViewWidth], [kAppDelegate swipeViewHeight]);
        self.view.frame = CGRectMake(0, 0, [kAppDelegate swipeViewWidth], [kAppDelegate swipeViewHeight]);

	} completion: ^(BOOL finished) {
	    checkShowhideView = TRUE;
	}];
	[self setProfileImageUser];
	[self setButtonImages:self.lastbtnClicked];
     */
}

- (void)hideView {
    [kAppDelegate hideMenu];
    checkShowhideView = FALSE;

    /*
	[UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationCurveEaseOut animations: ^{
	    self.view.frame = CGRectMake(-[kAppDelegate swipeViewWidth], 0, [kAppDelegate swipeViewWidth], [kAppDelegate swipeViewHeight]);
	} completion: ^(BOOL finished) {
	    checkShowhideView = FALSE;
	}];*/
}

#pragma mark - button actions
/*
   BUTTON MY CARDS ACTION
 */
- (IBAction)btnMyCardClicked:(id)sender {
	[CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
	//NSString *isUserGRU =[NSString stringWithFormat:@"%@",[[kAppDelegate dictUserInfo]valueForKey:@"isUserGruEdu"]];
	if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
		IBMyCardsVC *objIBMyCardsVC;
		if (kDevice == kIphone) {
			objIBMyCardsVC = [[IBMyCardsVC alloc]initWithNibName:@"IBMyCardsVC" bundle:nil];
		}
		else {
			objIBMyCardsVC = [[IBMyCardsVC alloc]initWithNibName:@"IBMyCardsVC_iPad" bundle:nil];
		}
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBMyCardsVC] animated:NO];
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
		objIBRegisterVC.strController = @"My Card";
		objIBRegisterVC.strDetailRegistration = @"DetailRegistration";
		objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];

		//objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
		// [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];

		[kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
		/******/
	}
	else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
		[self callPaymentClass];
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
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
	}
	[self hideView];
	[self setButtonImages:btnMyCards];
}

/*
   BUTTON MY OFFERS ACTION
 */
- (IBAction)btnOffersClicked:(id)sender {
	[CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];

	IBCategoryVC *objIBCategoryVC;
	if (kDevice == kIphone) {
		objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC" bundle:nil];
	}
	else {
		objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC_iPad" bundle:nil];
	}
	[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBCategoryVC] animated:NO];
	[self hideView];
	[self setButtonImages:_btnMyOffers];
}

/*
   BUTTON JOIN IBUDDY ACTION
 */
- (IBAction)btnJoinClicked:(id)sender {
	[CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];

	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *isUserGRU = [NSString stringWithFormat:@"%@", [[kAppDelegate dictUserInfo]valueForKey:@"isUserGruEdu"]];
	NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
	if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
		PaymentProgramVC *objPaymentProgramVC;
		if (kDevice == kIphone) {
			objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC" bundle:nil];
		}
		else {
			objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC_iPad" bundle:nil];
		}
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objPaymentProgramVC] animated:NO];
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
		// NSLog(@"%@",[kAppDelegate dictUserInfo]);
		objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
		objIBRegisterVC.strController = @"Join";
		//objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
		// [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];

		[kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
		/******/
	}

	else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
		[self callPaymentClass];

		/* Commented and added by Utkarsha to navigate to Extra Donation screen*/
	}
	else {
		PaymentProgramVC *objPaymentProgramVC;
		if (kDevice == kIphone) {
			objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC" bundle:nil];
		}
		else {
			objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC_iPad" bundle:nil];
		}
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objPaymentProgramVC] animated:NO];
	}
	[self hideView];
	[self setButtonImages:btnJoin];
}

/*
   BUTTON PROFILE ACTION
 */
- (IBAction)btnProfileClicked:(id)sender {
	[CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];

	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
	// NSString *isUserGRU =[NSString stringWithFormat:@"%@",[[kAppDelegate dictUserInfo]valueForKey:@"isUserGruEdu"]];
	if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
		IBDashboardVC *objIBDashboardVC;
		if (kDevice == kIphone) {
			objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
		}
		else {
			objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
		}
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBDashboardVC] animated:NO];
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
		[kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
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
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
	}

	[self hideView];
	[self setButtonImages:btnProfile];
}

- (IBAction)btnAboutUSClicked:(id)sender {
	IBAboutUsVC *objIBAboutUsVC;
	if (kDevice == kIphone) {
		objIBAboutUsVC = [[IBAboutUsVC alloc]initWithNibName:@"IBAboutUsVC" bundle:nil];
	}
	else {
		objIBAboutUsVC = [[IBAboutUsVC alloc]initWithNibName:@"IBAboutUs_iPad" bundle:nil];
	}
	[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBAboutUsVC] animated:NO];
	[self hideView];
	[self setButtonImages:_btnWelcome];
}
- (IBAction)btnExtraDonationClicked:(id)sender {
    
    
        [CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];
        
        NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
        NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
        NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
        if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
            
            NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kExtraDonationLink,userID]]];
            
            [self hideView];
            [self setButtonImages:_btnExtraDonation];
//            IBSideBarDonationViewController *objIBSideBarDonationViewController;
//            if (kDevice == kIphone) {
//                objIBSideBarDonationViewController = [[IBSideBarDonationViewController alloc]initWithNibName:@"IBSideBarDonationViewController" bundle:nil];
//            }
//            else {
//                objIBSideBarDonationViewController = [[IBSideBarDonationViewController alloc]initWithNibName:@"IBSideBarDonationViewController_iPad" bundle:nil];
//            }
//            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBSideBarDonationViewController] animated:NO];
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
            [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
            [self hideView];
            [self setButtonImages:btnCommTool];

            /******/
        }
        else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
            [self callPaymentClass];
            [self hideView];
            [self setButtonImages:btnCommTool];

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
            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
            [self hideView];
            [self setButtonImages:btnCommTool];

        }
        
        
        
        
    
    
}

- (IBAction)btnGiftAppClicked:(id)sender {
	[CommonFunction setValueInUserDefault:@"isGiftVC" value:@"1"];
	IBGiftVC *objIBGiftVC;
	if (kDevice == kIphone) {
		objIBGiftVC = [[IBGiftVC alloc]initWithNibName:@"IBGiftVC" bundle:nil];
	}
	else {
		objIBGiftVC = [[IBGiftVC alloc]initWithNibName:@"IBGiftVC_iPad" bundle:nil];
	}
	[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBGiftVC] animated:NO];
	[self hideView];
	[self setButtonImages:_btnGiftApp];
}

- (IBAction)btnGratitudeClicked:(id)sender {
	IBWithGratitudeVC *objIBWithGratitudeVC;
	if (kDevice == kIphone) {
		objIBWithGratitudeVC = [[IBWithGratitudeVC alloc]initWithNibName:@"IBWithGratitudeVC" bundle:nil];
	}
	else {
		objIBWithGratitudeVC = [[IBWithGratitudeVC alloc]initWithNibName:@"IBWithGratitudeVC_iPad" bundle:nil];
	}
	[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBWithGratitudeVC] animated:NO];
	[self hideView];
	[self setButtonImages:_btnWithGratitude];
}

- (IBAction)btnReferFriendClicked:(id)sender {
	IBReferFriendVC *objIBReferFriendVC;
	if (kDevice == kIphone) {
		objIBReferFriendVC = [[IBReferFriendVC alloc]initWithNibName:@"IBReferFriendVC" bundle:nil];
	}
	else {
		objIBReferFriendVC = [[IBReferFriendVC alloc]initWithNibName:@"IBReferFriendVC_ipad" bundle:nil];
	}
	[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBReferFriendVC] animated:NO];
	[self hideView];
	[self setButtonImages:_btnReferFriend];
}

- (IBAction)btnCommunicationToolClicked:(id)sender {
	[CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];

	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
	if ([userID length] > 0 && [userPayment isEqualToString:@"active"] && [userCompleteIncomplete isEqualToString:@"1"]) {
		IBCommunicationToolVC *objIBCommunicationToolVC;
		if (kDevice == kIphone) {
			objIBCommunicationToolVC = [[IBCommunicationToolVC alloc]initWithNibName:@"IBCommunicationToolVC" bundle:nil];
		}
		else {
			objIBCommunicationToolVC = [[IBCommunicationToolVC alloc]initWithNibName:@"IBCommunicationToolVC_iPad" bundle:nil];
		}
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBCommunicationToolVC] animated:NO];
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
		[kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
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
		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
	}




	[self hideView];
	[self setButtonImages:btnCommTool];
}
-(void)getPaymentToken
{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];

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
            [kAppDelegate.dictUserInfo removeAllObjects];

            IBLoginVC *objIBLoginVC;
            
            if (kDevice == kIphone) {
                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
            }
            else {
                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
            }
            objIBLoginVC.classType = @"Cards";
            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
            [kAppDelegate hideProgressHUD];

        }
        else
        {
            if ([[result valueForKey:@"isSubscribed"]isEqualToString:@"1"]) {
                
                
                
//                if(![[result valueForKey:@"last_name"] isEqual:[NSNull null]] && [[result valueForKey:@"last_name"] length]>0)
//                {
                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name" ]];
                    
//                }
//                else
//                {
//                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
//                    
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
                IBRegisterVC *objIBRegisterVC;
                if (kDevice==kIphone) {
                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
                }
                else{
                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
                }
                objIBRegisterVC.strEditProfile=@"Edit";
                objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                objIBRegisterVC.strController = @"My Profile";
                objIBRegisterVC.isNewUser=false;
                objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];

                //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
                //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
                //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
                // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
                
                [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
                
                
            }
            else
            {
                IBRegisterVC *objIBRegisterVC;
                if (kDevice==kIphone) {
                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
                }
                else{
                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
                }
                objIBRegisterVC.strEditProfile=@"Edit";
                objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                objIBRegisterVC.strController = @"My Profile";
                objIBRegisterVC.isNewUser=true;
                objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];

                //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
                //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
                //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
                // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
                
                [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
                
            }
        }

            // strPaymentToken=[result valueForKey:@"paymentToken"];
//        }
//        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
//            
//            // strPaymentToken=@"";
//            [kAppDelegate hideProgressHUD];
//            IBRegisterVC *objIBRegisterVC;
//            if (kDevice==kIphone) {
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
//            }
//            else{
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
//            }
//            objIBRegisterVC.strEditProfile=@"Edit";
//            objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
//            objIBRegisterVC.strController = @"My Profile";
//            objIBRegisterVC.isNewUser=true;
//            //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
//            //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
//            //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
//            // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
//            
//            [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
//
//            
//        }
//        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
//            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
//            [kAppDelegate hideProgressHUD];
//            
//        }
//        else {
//            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
//            [kAppDelegate hideProgressHUD];
//            
//        }
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
#pragma mark - Set Selected Images Methods

/* Method to set Images
 */
- (void)setButtonImages:(UIButton *)button {
	lastbtnClicked = button;
	if (kDevice == kIphone) {
		if (button ==  _btnMyOffers) {
            
            NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
            
            UINavigationController *navController=(UINavigationController *)kAppDelegate.window.rootViewController;
            UIViewController* vc = [navController visibleViewController];
            if([vc isKindOfClass:[IBRedeemOffer class]])
            {
                NSLog(@"YESSS%@",vc);
                _btnMyOffers.userInteractionEnabled = YES;
                
            }
            else
            {
                _btnMyOffers.userInteractionEnabled = NO;
                
            }
			[_btnMyOffers setImage:[UIImage imageNamed:@"IconOffersActive.png"] forState:UIControlStateNormal];
		}
		      
        
		
		else {
			_btnMyOffers.userInteractionEnabled = YES;
			[_btnMyOffers setImage:[UIImage  imageNamed:@"IconOffers.png" ] forState:UIControlStateNormal];
		}
		if (button ==  btnJoin) {
			btnJoin.userInteractionEnabled = NO;
			[btnJoin setImage:[UIImage imageNamed:@"IconJoin_hr.png"] forState:UIControlStateNormal];
		}
		else {
            if(appOpenedFirstTime)
            {
                //--- app opened highlight join now button
                
                btnJoin.userInteractionEnabled = YES;
                [btnJoin setImage:[UIImage imageNamed:@"side.png"] forState:UIControlStateNormal];
                appOpenedFirstTime=FALSE;
            }
            else
            {
                btnJoin.userInteractionEnabled = YES;
                [btnJoin setImage:[UIImage imageNamed:@"IconJoin.png"] forState:UIControlStateNormal];
            }

		}
		if (button == btnProfile) {
			btnProfile.userInteractionEnabled = NO;
			_btnProfieLarge.userInteractionEnabled = NO;
			[btnProfile setImage:[UIImage imageNamed:@"IconMyProfileActive.png" ] forState:UIControlStateNormal];
		}
		else {
			btnProfile.userInteractionEnabled = YES;
			_btnProfieLarge.userInteractionEnabled = YES;
			[btnProfile setImage:[UIImage imageNamed:@"IconMyProfile.png"] forState:UIControlStateNormal];
		}
        if (button ==  _btnExtraDonation) {
			_btnExtraDonation.userInteractionEnabled = NO;
			[_btnExtraDonation setImage:[UIImage imageNamed:@"ActivePAyit.png"] forState:UIControlStateNormal];
            
		}
		else {
			_btnExtraDonation.userInteractionEnabled = YES;
            
			[_btnExtraDonation setImage:[UIImage imageNamed:@"PAyit.png"] forState:UIControlStateNormal];
		}
		if (button ==  btnMyCards) {
			btnMyCards.userInteractionEnabled = NO;
			[self setCardImageActive];
		}
		else {
			btnMyCards.userInteractionEnabled = YES;
			[self setCardImageInActive];
		}
		if (button ==  _btnWelcome) {
			_btnWelcome.userInteractionEnabled = NO;
			[_btnWelcome setImage:[UIImage imageNamed:@"IconAboutUsActive.png"] forState:UIControlStateNormal];
		}
		else {
			_btnWelcome.userInteractionEnabled = YES;
			[_btnWelcome setImage:[UIImage imageNamed:@"IconAboutUs.png" ] forState:UIControlStateNormal];
		}

		if (button ==  _btnGiftApp) {
			_btnGiftApp.userInteractionEnabled = NO;
			[_btnGiftApp setImage:[UIImage imageNamed:@"IconGiftAppActive.png" ] forState:UIControlStateNormal];
		}
		else {
			_btnGiftApp.userInteractionEnabled = YES;
			[_btnGiftApp setImage:[UIImage imageNamed:@"IconGiftApp.png" ] forState:UIControlStateNormal];
		}

		if (button ==  _btnReferFriend) {
			_btnReferFriend.userInteractionEnabled = NO;
			[_btnReferFriend setImage:[UIImage imageNamed:@"IconReferActive.png"] forState:UIControlStateNormal];
		}
		else {
			_btnReferFriend.userInteractionEnabled = YES;
			[_btnReferFriend setImage:[UIImage imageNamed:@"IconRefer.png"] forState:UIControlStateNormal];
		}
        

		// Added by Utkarsha to add With Gratitute btn

		if (button ==  _btnWithGratitude) {
			_btnWithGratitude.userInteractionEnabled = NO;
			[_btnWithGratitude setImage:[UIImage imageNamed:@"sb_with_gratitude_hr.png"] forState:UIControlStateNormal];
		}
		else {
			_btnWithGratitude.userInteractionEnabled = YES;
			[_btnWithGratitude setImage:[UIImage imageNamed:@"sb_with_gratitude.png"] forState:UIControlStateNormal];
		}
		// Added by Utkarsha to add Communication tool btn

		if (button ==  self.btnCommTool) {
			self.btnCommTool.userInteractionEnabled = NO;
			[self.btnCommTool setImage:[UIImage imageNamed:@"side-menu-icon_notification_tapped.png"] forState:UIControlStateNormal];
		}
		else {
			self.btnCommTool.userInteractionEnabled = YES;
			[self.btnCommTool setImage:[UIImage imageNamed:@"side-menu-icon_notification.png" ] forState:UIControlStateNormal];
		}
        if (button ==  self.btnDetailsAbtTabs) {
            self.btnDetailsAbtTabs.userInteractionEnabled = NO;
            [self.btnDetailsAbtTabs setImage:[UIImage imageNamed:@"IconHelp_hr.png"] forState:UIControlStateNormal];
        }
        else {
            self.btnDetailsAbtTabs.userInteractionEnabled = YES;
            [self.btnDetailsAbtTabs setImage:[UIImage imageNamed:@"IconHelp.png"] forState:UIControlStateNormal];
            
        }

	}
	else {
		if (button ==  _btnMyOffers) {
            {
                
                NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
                
                UINavigationController *navController=(UINavigationController *)kAppDelegate.window.rootViewController;
                UIViewController* vc = [navController visibleViewController];
                if([vc isKindOfClass:[IBRedeemOffer class]])
                {
                    NSLog(@"YESSS%@",vc);
                    _btnMyOffers.userInteractionEnabled = YES;
                    
                }
                else
                {
                    _btnMyOffers.userInteractionEnabled = NO;
                    
                }
                [_btnMyOffers setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconOffersActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            }
            
            
		}
		else {
			_btnMyOffers.userInteractionEnabled = YES;
			[_btnMyOffers setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconOffers@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		if (button ==  btnJoin) {
			btnJoin.userInteractionEnabled = NO;
			[btnJoin setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconJoin_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
            if(appOpenedFirstTime)
            {
                //--- app opened highlight join now button
                
                btnJoin.userInteractionEnabled = YES;
                
                [btnJoin setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"side@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
                appOpenedFirstTime=FALSE;
            }
            else
            {
                btnJoin.userInteractionEnabled = YES;
                [btnJoin setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconJoin@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            }

		}
		if (button == btnProfile) {
			btnProfile.userInteractionEnabled = NO;
			_btnProfieLarge.userInteractionEnabled = NO;
			[btnProfile setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyProfileActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			btnProfile.userInteractionEnabled = YES;
			_btnProfieLarge.userInteractionEnabled = YES;
			[btnProfile setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyProfile@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
        if (button ==  _btnExtraDonation) {
			_btnExtraDonation.userInteractionEnabled = NO;
			[_btnExtraDonation setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"activePayItIpad@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			_btnExtraDonation.userInteractionEnabled = YES;
            
			[_btnExtraDonation setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payItIpad@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		if (button ==  btnMyCards) {
			btnMyCards.userInteractionEnabled = NO;
			[self setCardImageActive];
		}
		else {
			btnMyCards.userInteractionEnabled = YES;
			[self setCardImageInActive];
		}
		if (button ==  _btnWelcome) {
			_btnWelcome.userInteractionEnabled = NO;
			[_btnWelcome setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconAboutUsActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			_btnWelcome.userInteractionEnabled = YES;
			[_btnWelcome setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconAboutUs@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		if (button ==  _btnGiftApp) {
			_btnGiftApp.userInteractionEnabled = NO;
			[_btnGiftApp setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconGiftAppActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			_btnGiftApp.userInteractionEnabled = YES;
			[_btnGiftApp setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconGiftApp@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}

		if (button ==  _btnReferFriend) {
			_btnReferFriend.userInteractionEnabled = NO;
			[_btnReferFriend setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconReferActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			_btnReferFriend.userInteractionEnabled = YES;
			[_btnReferFriend setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconRefer@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		// Added by Utkarsha to add With Gratitute btn
		if (button ==  _btnWithGratitude) {
			_btnWithGratitude.userInteractionEnabled = NO;
			[_btnWithGratitude setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sb_with_gratitude_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			_btnWithGratitude.userInteractionEnabled = YES;
			[_btnWithGratitude setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sb_with_gratitude@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		// Added by Utkarsha to add Communication tool btn

		if (button ==  self.btnCommTool) {
			self.btnCommTool.userInteractionEnabled = NO;
			[self.btnCommTool setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"side-menu-icon_notification_tapped~iPad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			self.btnCommTool.userInteractionEnabled = YES;
			[self.btnCommTool setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"side-menu-icon_notification~iPad" ofType:@"png"]] forState:UIControlStateNormal];
		}
        
        if (button ==  self.btnDetailsAbtTabs) {
            self.btnDetailsAbtTabs.userInteractionEnabled = NO;
            [self.btnDetailsAbtTabs setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconHelp_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
        }
        else {
            self.btnDetailsAbtTabs.userInteractionEnabled = YES;
            [self.btnDetailsAbtTabs setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconHelp@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
        }

	}
}
- (IBAction)btnAboutButtonsUsageClicked:(id)sender
{
    IBTabDescriptionVC *objIBIBTabDescription;
    objIBIBTabDescription = [[IBTabDescriptionVC alloc]initWithNibName:@"IBTabDescriptionVC" bundle:nil];
    
    [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBIBTabDescription] animated:NO];
    [self hideView];
    [self setButtonImages:_btnDetailsAbtTabs];
}
/**
   SET USER'S PROFILE IMAGE
 */
- (void)setProfileImageUser {
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];

    if ([userID length] > 0) {
		//[_imgProfile setImageWithURL:[NSURL URLWithString:[[kAppDelegate dictUserInfo]valueForKey:@"profileImage"]]
		            //placeholderImage:[UIImage imageNamed:@"user_placeHolder.png"]];
        self.viewProfile.hidden = NO;
        self.btnProfileLogin.hidden = YES;
        [_imgProfileImage setImageWithURL:[NSURL URLWithString:[[kAppDelegate dictUserInfo]valueForKey:@"profileImage"]]
                    placeholderImage:[UIImage imageNamed:@"user_placeHolder.png"]];
        NSString *strName= [[[kAppDelegate dictUserInfo]valueForKey:@"userDetail"] valueForKey:@"name"];
        if(strName.length == 0)
            strName = [[[kAppDelegate dictUserInfo]valueForKey:@"userDetail"] valueForKey:@"first_name"];
        
        self.lblProfileName.text = [NSString stringWithFormat:@"%@ %@",strName,[[[kAppDelegate dictUserInfo]valueForKey:@"userDetail"] valueForKey:@"last_name"]];
        self.lblProfileEmail.text = [[[kAppDelegate dictUserInfo]valueForKey:@"userDetail"] valueForKey:@"email"];
        
//        //Added by Utkarsha to show badge count on Communication tool icon
//        NSInteger badgeCount = [[CommonFunction getValueFromUserDefault:kNotificationBadgeCount] integerValue];
//        if (badgeCount >0) {
//            self.lblNotificationCount.hidden = YES;
//            self.lblNotificationCount.text = [NSString stringWithFormat:@"%d",badgeCount];
//            self.imgNotificationBadge.hidden = YES;
//        }
//        else
//        {
//            self.lblNotificationCount.hidden = YES;
//            self.imgNotificationBadge.hidden = YES;
//        }
	}
	else {
        
        self.viewProfile.hidden = YES;
        self.btnProfileLogin.hidden = NO;
        
		//_imgProfile.image = [UIImage imageNamed:@"user_placeHolder.png"];
        //self.lblNotificationCount.hidden = YES;
        //self.imgNotificationBadge.hidden = YES;
	}
}

- (IBAction)sideButtonAction:(id)sender {
	if (checkShowhideView == FALSE) {
		[self showView];
	}
	else {
		[self hideView];
	}
}

- (void)setCardImageActive {
	NSLog(@"%@", [kAppDelegate dictUserInfo]);
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *npoImageURL = [[kAppDelegate dictUserInfo]valueForKey:@"npo_logo"];
	viewFundraiserLogo.hidden = YES;
	_fundraiserNameBgIngView.hidden = YES;

	if (kDevice == kIphone) {
		if ([userID length] > 0 && [userPayment isEqualToString:@"active"]) {
			//[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyCardActive@2x" ofType:@"png"]] forState:UIControlStateNormal];
			[btnMyCards setImage:nil forState:UIControlStateNormal];
			viewFundraiserLogo.hidden = NO;
			[fundraiserImgView setImageWithURL:[NSURL URLWithString:npoImageURL]
			                  placeholderImage:[UIImage imageNamed:@""]];
			//fundraiserName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_hover.png"]];
			_fundraiserNameBgIngView.hidden = NO;
			fundraiserName.text = [[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
		}
		else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconPurchaseAppActive@2x" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconLoginActive@2x" ofType:@"png"]] forState:UIControlStateNormal];
		}
	}

	else {
		if ([userID length] > 0 && [userPayment isEqualToString:@"active"]) {
			// [btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyCardActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
			[btnMyCards setImage:nil forState:UIControlStateNormal];
			viewFundraiserLogo.hidden = NO;
			[fundraiserImgView setImageWithURL:[NSURL URLWithString:npoImageURL]
			                  placeholderImage:[UIImage imageNamed:@""]];
			// fundraiserName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_hover~ipad.png"]];
			_fundraiserNameBgIngView.hidden = NO;

			fundraiserName.text = [[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
		}
		else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconPurchaseAppActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconLoginActive@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
	}
}

- (void)setCardImageInActive {
	NSLog(@"%@", [kAppDelegate dictUserInfo]);
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
	NSString *npoImageURL = [[kAppDelegate dictUserInfo]valueForKey:@"npo_logo"];
	viewFundraiserLogo.hidden = YES;

	if (kDevice == kIphone) {
		//Edited by Utkarsha to add fundraiser logo image
		if ([userID length] > 0 && [userPayment isEqualToString:@"active"]) {
			//[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyCard@2x" ofType:@"png"]] forState:UIControlStateNormal];
			[btnMyCards setImage:nil forState:UIControlStateNormal];
			viewFundraiserLogo.hidden = NO;
			_fundraiserNameBgIngView.hidden = YES;
			[fundraiserImgView setImageWithURL:[NSURL URLWithString:npoImageURL]
			                  placeholderImage:[UIImage imageNamed:@""]];
			fundraiserName.backgroundColor = [UIColor clearColor];
			fundraiserName.text = [[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
            
//            //If i have to remove fundraiser image from the side bar
//            [btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconPurchaseApp@2x" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconPurchaseApp@2x" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconLogin@2x" ofType:@"png"]] forState:UIControlStateNormal];
		}
	}
	else {
		if ([userID length] > 0 && [userPayment isEqualToString:@"active"]) {
			//[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconMyCard@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
			//Edited by Utkarsha to add fundraiser logo image
			[btnMyCards setImage:nil forState:UIControlStateNormal];
			viewFundraiserLogo.hidden = NO;
			_fundraiserNameBgIngView.hidden = YES;
			[fundraiserImgView setImageWithURL:[NSURL URLWithString:npoImageURL]
			                  placeholderImage:[UIImage imageNamed:@""]];
			fundraiserName.backgroundColor = [UIColor clearColor];
			fundraiserName.text = [[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
		}
		else if ([userID length] > 0 && [userPayment isEqualToString:@"inactive"]) {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconPurchaseApp@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else {
			[btnMyCards setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconLogin@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
		}
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
//		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBExtraDonationVC] animated:NO];
//	}
//	else {
    [self getPaymentToken];

    
    
//		IBPaymentVC *objIBPaymentVC;
//		if (kDevice == kIphone) {
//			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
//		}
//		else {
//			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
//		}
//		//  objIBPaymentVC.strClassTypeForPaymentScreen=@"Cards";
//		[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBPaymentVC] animated:NO];
//	//}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    [self setProfileImageUser];
    
    if (userID > 0) {
        return arrMenuWithLogin.count;
    } else {
        return arrMenuWithOutLogin.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //etc.
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    //cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 30, 30);
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 30)];
    lbl.textColor = [UIColor whiteColor];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 26, 26)];
    img.contentMode=UIViewContentModeScaleAspectFit;
    if (userID > 0) {
        lbl.text = arrMenuWithLogin[indexPath.row];
        img.image = [UIImage imageNamed:arrIconMenuWithLogin[indexPath.row]];
        
        if (indexPath.row == 1) {
            lbl.text = [[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
            NSLog(@"%@",[kAppDelegate dictUserInfo]);
            [img setImageWithURL:[NSURL URLWithString:[[kAppDelegate dictUserInfo]valueForKey:@"npo_logo"]]
                             placeholderImage:[UIImage imageNamed:@"menu-user_default_icon"]];

        }

    } else {
        lbl.text = arrMenuWithOutLogin[indexPath.row];
        img.image = [UIImage imageNamed:arrIconMenuWithOutLogin[indexPath.row]];

    }
    
    [cell.contentView addSubview:lbl];
    [cell.contentView addSubview:img];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:111.0/255.0 green:26.0/255.0 blue:23.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (selectedIndex == indexPath.row) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:111.0/255.0 green:26.0/255.0 blue:23.0/255.0 alpha:1.0]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    selectedIndex = indexPath.row;
    [self actionSwitch:indexPath.row];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (IBAction)btnLoginAction:(id)sender {
    
    IBLoginVC *objIBLoginVC;
    
    if (kDevice == kIphone) {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
    }
    else {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
    }
    objIBLoginVC.classType = @"Cards";
    [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];
    [self hideView];
    
}


- (IBAction)btnLogOutClicked:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"facebookLogin"])
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
    [dict setValue:deviceTest forKey:@"deviceType"];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kLogOut] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            [kAppDelegate setDictUserInfo:nil];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"You are successfully logged out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //alert.tag=kLogOutAlertTag;
            [alert show];

        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [kAppDelegate hideProgressHUD];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [CommonFunction setValueInUserDefault:kZipCode value:@""];
    [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
    [CommonFunction setValueInUserDefault:kIsPaymentScreenCompleted value:@"0"];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [kAppDelegate.dictUserInfo removeAllObjects];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserPaymentInfo];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    [kAppDelegate hideMenu];

    if (buttonIndex==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"KSSplashVC"];
        kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        kAppDelegate.navController.navigationBarHidden = YES;
        
        kAppDelegate.window.rootViewController = kAppDelegate.navController;
        
        //        [self setInitialVariablesForMerchant];
        [kAppDelegate.window makeKeyAndVisible];
    }
}


- (void)actionSwitch:(NSInteger)buttonIndex {
    
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    
    if (userID > 0) {
        
        switch (buttonIndex) {
            case 0:
                [self btnJoinClicked:btnJoin];
                break;

            case 1:
                [self btnMyCardClicked:btnMyCards];
                break;

            case 2:
                [self btnOffersClicked:_btnMyOffers];
                break;

            case 3:
                [self btnReferFriendClicked:_btnReferFriend];
                break;

            case 4:
                [self btnExtraDonationClicked:_btnExtraDonation];
                break;

            case 5:
                [self btnGratitudeClicked:_btnWithGratitude];
                break;

            case 6:
                [self btnCommunicationToolClicked:btnCommTool];
                break;

            case 7:
                [self btnGiftAppClicked:_btnGiftApp];
                break;
                
            case 8:
                [self btnAboutUSClicked:nil];
                break;
                
            case 9:
                [self btnAboutButtonsUsageClicked:nil];
                break;
            case 10:
                [self btnLogOutClicked:nil];
                break;
            default:
                break;
        }
        
    } else {
        
        switch (buttonIndex) {
            case 0:
                [self btnJoinClicked:btnJoin];
                break;
                
            case 1:
                [self btnOffersClicked:_btnMyOffers];
                break;
                
            case 2:
                [self btnReferFriendClicked:_btnReferFriend];
                break;
                
            case 3:
                [self btnExtraDonationClicked:_btnExtraDonation];
                break;
                
            case 4:
                [self btnGratitudeClicked:_btnWithGratitude];
                break;
                
            case 5:
                [self btnCommunicationToolClicked:btnCommTool];
                break;
                
            case 6:
                [self btnGiftAppClicked:_btnGiftApp];
                break;
                
            case 7:
                [self btnAboutUSClicked:nil];
                break;
                
            case 8:
                [self btnAboutButtonsUsageClicked:nil];
                break;
            default:
                break;
        }
        
    }
    
}

@end
