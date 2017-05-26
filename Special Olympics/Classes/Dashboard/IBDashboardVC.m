//
//  IBDashboardVC.m
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBDashboardVC.h"
#define kLogOutAlertTag 6060
@interface IBDashboardVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
@property (weak, nonatomic) IBOutlet UIButton *btnPayments;
@property (weak, nonatomic) IBOutlet UIButton *btnOffers;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UILabel *lblNoConnection;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@end

@implementation IBDashboardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle

-(void)viewWillAppear:(BOOL)animated
{
    [self getDashboardData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    self.lblTop.font=[UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
    self.btnEditProfile.titleLabel.font=[UIFont fontWithName:kFont size:self.btnEditProfile.titleLabel.font.pointSize];
    navController = [[UINavigationController alloc] init];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setLblNoConnection:nil];
    [self setBtnEditProfile:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark - Private methods


#pragma mark - Button Actions
- (IBAction)btnAboutClicked:(id)sender
{
    
    if (kDevice==kIphone) {
    objIBUserProfileVC=[[IBUserProfileVC alloc] initWithNibName:@"IBUserProfileVC" bundle:nil];
        navController.view.frame=CGRectMake(0, kDashboardY_iPhone, kWindowWidth, kWindowHeight-kDashBoardHeightMinusFactor_iPhone);

    }
    else{
        objIBUserProfileVC=[[IBUserProfileVC alloc] initWithNibName:@"IBUserProfile_iPad" bundle:nil];
        navController.view.frame=CGRectMake(kDashboardX_iPad, kDashboardY_iPad, kDashboardWidth_iPad, kDashboardHeight_iPad);
    }
    
    navController=[navController initWithRootViewController:objIBUserProfileVC];
    objIBUserProfileVC.dictUserProfileInfo=[dictInfo valueForKey:@"userDetail"];
//    [kAppDelegate.dictUserPaymentInfo setValue:[[dictInfo valueForKey:@"userDetail"] valueForKey:@"nextPaymentDate"] forKey:@"nextPaymentDate"];
//    [kAppDelegate.dictUserPaymentInfo setValue:[[dictInfo valueForKey:@"userDetail"] valueForKey:@"paymentType"] forKey:@"paymentType"];
    navController.navigationBarHidden=TRUE;
    [self.view addSubview:navController.view];
    [self setButtonImages:self.btnAbout];
    if ([dictInfo valueForKey:@"userDetail"]) {
        self.btnEditProfile.hidden=NO;
    }
    else{
        self.btnEditProfile.hidden=YES;
        
    }
}

- (IBAction)btnPaymentsClicked:(id)sender {
    self.btnEditProfile.hidden=YES;

     if (kDevice==kIphone) {
         objIBUserPayments=[[IBUserPayments alloc] initWithNibName:@"IBUserPayments" bundle:nil];
         navController.view.frame=CGRectMake(0, kDashboardY_iPhone, kWindowWidth, kWindowHeight-kDashBoardHeightMinusFactor_iPhone);

     }
     else{
         objIBUserPayments=[[IBUserPayments alloc] initWithNibName:@"IBUserPayments_iPad" bundle:nil];
     
         navController.view.frame=CGRectMake(kDashboardX_iPad, kDashboardY_iPad, kDashboardWidth_iPad, kDashboardHeight_iPad);

     }
    
    navController=[navController initWithRootViewController:objIBUserPayments];
    objIBUserPayments.dictUserPayments=dictInfo;
    navController.navigationBarHidden=TRUE;
    [self.view addSubview:navController.view];
    [self setButtonImages:self.btnPayments];

}

- (IBAction)btnOffersClicked:(id)sender {
    self.btnEditProfile.hidden=YES;

    if (kDevice==kIphone) {
        objIBUserMerchantsVC=[[IBUserMerchantsVC alloc] initWithNibName:@"IBUserMerchantsVC" bundle:nil];
        navController.view.frame=CGRectMake(0, kDashboardY_iPhone, kWindowWidth, kWindowHeight-kDashBoardHeightMinusFactor_iPhone);

    }
    else
    {
        objIBUserMerchantsVC=[[IBUserMerchantsVC alloc] initWithNibName:@"IBUserMerchantsVC_iPad" bundle:nil];
        navController.view.frame=CGRectMake(kDashboardX_iPad, kDashboardY_iPad, kDashboardWidth_iPad, kDashboardHeight_iPad);

    }
    navController=[navController initWithRootViewController:objIBUserMerchantsVC];
    objIBUserMerchantsVC.dict_MerchantList=[dictInfo valueForKey:@"merchants"];
    navController.navigationBarHidden=TRUE;
    [self.view addSubview:navController.view];
    [self setButtonImages:self.btnOffers];

}
- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

- (IBAction)btnChangePasswordClicked:(id)sender
{
    self.btnEditProfile.hidden=YES;

    if (kDevice==kIphone)
    {
    objIBChangePasswordVC=[[IBChangePasswordVC alloc] initWithNibName:@"IBChangePasswordVC" bundle:nil];
        navController.view.frame=CGRectMake(0, kDashboardY_iPhone, kWindowWidth, kWindowHeight-kDashBoardHeightMinusFactor_iPhone);

    }else{
        objIBChangePasswordVC=[[IBChangePasswordVC alloc] initWithNibName:@"IbChangePasswordVC_iPad" bundle:nil];
        navController.view.frame=CGRectMake(kDashboardX_iPad, kDashboardY_iPad, kDashboardWidth_iPad, kDashboardHeight_iPad);

    }
    navController=[navController initWithRootViewController:objIBChangePasswordVC];
    navController.navigationBarHidden=TRUE;
    [self.view addSubview:navController.view];
    [self setButtonImages:self.btnChangePassword];

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
            alert.tag=kLogOutAlertTag;
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

- (IBAction)btnEditProfileClicked:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideSideControls"
                                                       object:self];
    IBRegisterVC *objIBRegisterVC;
    if (kDevice==kIphone) {
        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
    }
    else{
        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
    }
    objIBRegisterVC.strEditProfile=@"Edit";
    objIBRegisterVC.strController = @"My Profile";
    objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
   // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
    
    [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
}

/** Mehod to set Button Images
 */
- (void)setButtonImages:(UIButton*)button {

    if (button ==  self.btnAbout) {
        self.btnAbout.userInteractionEnabled=FALSE;
        [self.btnAbout setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_AboutAct@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else {
         self.btnAbout.userInteractionEnabled=TRUE;
         [self.btnAbout setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_About@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    if (button ==  self.btnPayments) {
        self.btnPayments.userInteractionEnabled=FALSE;
        [self.btnPayments setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_PaymentsAct@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else {
        self.btnPayments.userInteractionEnabled=TRUE;
        [self.btnPayments setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_Payments@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    if (button ==  self.btnOffers) {
        self.btnOffers.userInteractionEnabled=FALSE;
        [self.btnOffers setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_OffersAct@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else {
        self.btnOffers.userInteractionEnabled=TRUE;
        [self.btnOffers setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_Offers@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    if (button ==  self.btnChangePassword) {
        self.btnChangePassword.userInteractionEnabled=FALSE;
        [self.btnChangePassword setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_ChangePasswordAct@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else {
        self.btnChangePassword.userInteractionEnabled=TRUE;
        [self.btnChangePassword setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BottomBar_ChangePassword@2x" ofType:@"png"]] forState:UIControlStateNormal];
    }
}
#pragma mark - Get WebserviceData
/*
 Method to get dashboard data
 */
-(void)getDashboardData
{
        
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kUserDashboard] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            if (dictInfo)
            {
                dictInfo=nil;
            }
            dictInfo=[[NSMutableDictionary alloc]init];
            dictInfo=result;
            [self btnAboutClicked:self.btnAbout];
            [kAppDelegate hideProgressHUD];
            [self enableControls];
            
        }
        else  {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
            [self disableControls];
        }


    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [self disableControls];
        [kAppDelegate hideProgressHUD];
    }];
    
    
}


/*
 Method to enable bottom bar controls
 */
-(void)enableControls
{
    self.lblNoConnection.hidden=TRUE;
    self.btnAbout.userInteractionEnabled=YES;
    self.btnChangePassword.userInteractionEnabled=YES;
    self.btnOffers.userInteractionEnabled=YES;
    self.btnPayments.userInteractionEnabled=YES;
    self.btnEditProfile.hidden=NO;

}
/*
 Method to disable bottom bar controls
 */
-(void)disableControls
{
    self.lblNoConnection.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lblNoConnection.hidden=FALSE;
    self.btnAbout.userInteractionEnabled=NO;
    self.btnChangePassword.userInteractionEnabled=NO;
    self.btnOffers.userInteractionEnabled=NO;
    self.btnPayments.userInteractionEnabled=NO;
    self.btnEditProfile.hidden=YES;

}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [CommonFunction setValueInUserDefault:kZipCode value:@""];
    [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserPaymentInfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([alertView tag]==kLogOutAlertTag && buttonIndex==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"KSSplashVC"];
        kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        kAppDelegate.navController.navigationBarHidden = YES;
        
        kAppDelegate.window.rootViewController = kAppDelegate.navController;
        
        //        [self setInitialVariablesForMerchant];
        [kAppDelegate.window makeKeyAndVisible];
    }
}
@end
