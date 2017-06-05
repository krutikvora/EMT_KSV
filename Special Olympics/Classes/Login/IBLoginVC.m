//
//  IBLoginVC.m
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "IBLoginVC.h"
#define kGRUUSERTag  6565
#define kRegisterIncompleteTag 6767
#define kMerchantUserTag 6868
@interface IBLoginVC ()
{
    NSMutableDictionary *fbParaDict;
}
@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPwd;
@property (weak, nonatomic) IBOutlet UILabel *lblRememberMe;
@property (weak, nonatomic) IBOutlet UIImageView *imgTikUntik;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnRegisterClicked:(id)sender;
- (IBAction)btnForgotPwdClicked:(id)sender;
- (IBAction)btnRememberMeClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;

@end

@implementation IBLoginVC
@synthesize classType,lblCopyRight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialLabels];
    // Do any additional setup after loading the view from its nib.
   }
#pragma mark Facebook Login methods
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    if (error)
    {
        // There is an error here.
    }
    else
    {
        if(result.token)   // This means if There is current access token.
        {
            // Token created successfully and you are ready to get profile info
            [[NSUserDefaults standardUserDefaults]setValue:result.token.userID forKey:@"fbToken"];
            [self getFacebookProfileInfo];
        }
    }
}
#pragma mark Fetch Facebook login details
-(void)getFacebookProfileInfo
{
    fbParaDict=[[NSMutableDictionary alloc]init];
    [kAppDelegate showProgressHUD];
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,first_name,last_name"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if(result)
         {
             if ([result objectForKey:@"email"])
             {
                 NSLog(@"Email: %@",[result objectForKey:@"email"]);
             }
             if ([result objectForKey:@"first_name"])
             {
                 NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
             }
             if ([result objectForKey:@"last_name"])
             {
                 NSLog(@"Last Name : %@",[result objectForKey:@"last_name"]);
             }
             if ([result objectForKey:@"id"])
             {
                 FBSDKProfilePictureView *pictureView=[[FBSDKProfilePictureView alloc]init];
                 [pictureView setProfileID:@"user_id"];
                 [pictureView setPictureMode:FBSDKProfilePictureModeSquare];
                 //facebookID = your facebook user id or facebook username both of work well
                 //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [result objectForKey:@"id"]]];
                 // [fbParaDict setValue:[pictureURL absoluteString] forKey:@"data[User][image]"];
             }
             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"fbToken"] forKey:@"facebookId"];
             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
             [fbParaDict setValue:deviceTest forKey:@"deviceType"];
             
             //             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"data[User][device_token]"];
             //             [fbParaDict setValue:@"ios" forKey:@"data[User][plateform]"];
             //             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"longitudeValue"] forKey:@"data[User][longitude]"];
             //             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"latitudeValue"] forKey:@"data[User][latitude]"];
             //             [fbParaDict setValue:[result objectForKey:@"first_name"] forKey:@"data[User][firstname]"];
             //             [fbParaDict setValue:[result objectForKey:@"last_name"] forKey:@"data[User][lastname]"];
             //
             [self callAPIForFBLogin];
         }
         else
         {
             [kAppDelegate hideProgressHUD];
         }
     }];
    [connection start];
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
-(void)callAPIForFBLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"facebookLogin"];
    
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:fbParaDict method:KFBLoginAPI] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if (([[result valueForKey:@"merchantId"]length]!=0)&&[[result valueForKey:@"userId"] length]!=0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to login as merchant or user?" delegate:self cancelButtonTitle:@"Merchant" otherButtonTitles:@"User", nil];
            alert.tag=kMerchantUserTag;
            [alert show];
            [kAppDelegate hideProgressHUD];
            dictResult=result;
        }
        else if ([[result valueForKey:@"merchantId"]length]!=0) {
            [CommonFunction setValueInUserDefault:kMerchantId value:[result valueForKey:kMerchantId]];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                if ([[result valueForKey:@"isSkip"]isEqualToString:@"yes"])
                {
                    if ([[result valueForKey:@"isMerchantMultiple"] isEqual:[NSNumber numberWithChar:1]])
                    {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"multiMerchant"];
                        kAppDelegate.window.rootViewController = viewController;
                        [kAppDelegate.window makeKeyAndVisible];
                    }
                    else
                    {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
                        kAppDelegate.window.rootViewController = viewController;
                        [kAppDelegate.window makeKeyAndVisible];
                    }
                    //[CommonFunction setValueInUserDefault:kUserType value:@"Merchant"];
                }
                else {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    KSChangePasswordViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                    [viewController setViewMode:viewFromChangePasswordMerchant];
                    
                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];
                    
                    // [CommonFunction setValueInUserDefault:kUserType value:@"Merchant"];
                }
                [self setRememberMeValue:@"Merchant"];
                
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Login Failure" message:@"Please enter correct credentials."];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                [CommonFunction fnAlert:@"Login Failure" message:@"Your account is deactivated."];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [CommonFunction fnAlert:@"" message:@"Please try again"];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            [kAppDelegate hideProgressHUD];
        }
        else if ([[result valueForKey:@"userId"]length]!=0){
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"userPayments"]isEqualToString:@"active"]) {
                [self setValueForActiveUser:result];
            }
            
            else  if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"userPayments"]isEqualToString:@"inactive"]) {
                [self setValueForInactiveUser:result];
                /*commented in order to implement not to log out unpaid user*/
                //[CommonFunction setValueInUserDefault:kUserId value:[result valueForKey:@"userId"]];
                
            }
            
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"" message:@"Please enter correct credentials or register if you have not already done so."];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                [CommonFunction fnAlert:@"Alert!" message:@"Please confirm your account first"];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            else
            {
                [CommonFunction fnAlert:@"Alert!" message:@"Server error."];
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
            [kAppDelegate hideProgressHUD];
        }
        
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [kAppDelegate hideProgressHUD];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self checKRememberMe];
    
    //---initiliaze facebook permisions
    facebookLoginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    facebookLoginButton.delegate=self;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#pragma mark-
#pragma mark - Private Methods

#pragma mark-
#pragma mark - Buttons Action

/**-
 @Method    -  loginAction -> Perform user Login
 @Param     -  emailId, Password
 @Responce  -  status = 1 -> success - return merchantId
 status = 0 -> invalid username/password
 status = -1 -> error
 */

- (IBAction)btnLoginClicked:(id)sender {
    [CommonFunction callHideViewFromSideBar];
    [kAppDelegate hideMenu];

    if ([self checkFieldValidation]==YES) {
        [kAppDelegate showProgressHUD:self.view];
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.txtEmailId.text forKey:@"email"];
        [dict setValue:self.txtPassword.text forKey:@"password"];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
        [dict setValue:deviceTest forKey:@"deviceType"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kLogin] completeBlock:^(NSData *data) {

            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if (([[result valueForKey:@"merchantId"]length]!=0)&&[[result valueForKey:@"userId"] length]!=0) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to login as merchant or user?" delegate:self cancelButtonTitle:@"Merchant" otherButtonTitles:@"User", nil];
                alert.tag=kMerchantUserTag;
                [alert show];
                [kAppDelegate hideProgressHUD];
                dictResult=result;
            }
            else if ([[result valueForKey:@"merchantId"]length]!=0)
            {
                [CommonFunction setValueInUserDefault:kMerchantId value:[result valueForKey:kMerchantId]];
                if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                if ([[result valueForKey:@"isSkip"]isEqualToString:@"yes"])
                {
                    if ([[result valueForKey:@"isMerchantMultiple"] isEqual:[NSNumber numberWithChar:1]])
                    {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"multiMerchant"];
                        kAppDelegate.window.rootViewController = viewController;
                        [kAppDelegate.window makeKeyAndVisible];
                    }
                    else
                    {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];
                    }
                    //[CommonFunction setValueInUserDefault:kUserType value:@"Merchant"];
                }
                else {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    KSChangePasswordViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                    [viewController setViewMode:viewFromChangePasswordMerchant];

                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];

                   // [CommonFunction setValueInUserDefault:kUserType value:@"Merchant"];
                }
                    [self setRememberMeValue:@"Merchant"];

                }
                 else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                    [CommonFunction fnAlert:@"Login Failure" message:@"Please enter correct credentials."];}
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                    [CommonFunction fnAlert:@"Login Failure" message:@"Your account is deactivated."];
                }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                    [CommonFunction fnAlert:@"" message:@"Please try again"];
                }
                else {
                    [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                }
                [kAppDelegate hideProgressHUD];
            }
              else if ([[result valueForKey:@"userId"]length]!=0){
                if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"userPayments"]isEqualToString:@"active"]) {
                    [self setValueForActiveUser:result];
                }
                
                else  if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"userPayments"]isEqualToString:@"inactive"]) {
                    [self setValueForInactiveUser:result];
                    /*commented in order to implement not to log out unpaid user*/
                    //[CommonFunction setValueInUserDefault:kUserId value:[result valueForKey:@"userId"]];
                   
                }
                
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                    [CommonFunction fnAlert:@"" message:@"Please enter correct credentials or register if you have not already done so."];
                }
                
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                    [CommonFunction fnAlert:@"" message:@"Please try again"];
                }
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                    [CommonFunction fnAlert:@"Alert!" message:@"Please confirm your account first"];
                }
                else 
                {
                    [CommonFunction fnAlert:@"Alert!" message:@"Server error."];
                }
                [kAppDelegate hideProgressHUD];
            }
            
        
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
}
/*
 Action of Remember Me button
 */
- (IBAction)btnRememberMeClicked:(id)sender {
    if ([self.imgTikUntik.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]]) {
        self.imgTikUntik.image=[UIImage imageNamed:@"Settings_CheckBox2_2.png"];
     //   [CommonFunction setValueInUserDefault:@"RememberMe" value:@"YES"];
        [CommonFunction setValueInUserDefault:kEmailId value:self.txtEmailId.text];
        [CommonFunction setValueInUserDefault:kPassword value:self.txtPassword.text];
        
    }else{
        self.imgTikUntik.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        [CommonFunction setValueInUserDefault:kRememberMe value:@"NO"];
        [CommonFunction setValueInUserDefault:kEmailId value:@""];
        [CommonFunction setValueInUserDefault:kPassword value:@""];
        [CommonFunction setValueInUserDefault:kUserType value:@""];

        
    }
}

/*
 Method to check remeber ME
 */
-(void)checKRememberMe
{
    if ([[CommonFunction getValueFromUserDefault:kRememberMe] isEqualToString:@"YES"]) {
        self.txtEmailId.text=[CommonFunction getValueFromUserDefault:@"EmailId"];
        self.txtPassword.text=[CommonFunction getValueFromUserDefault:@"Password"];
        self.imgTikUntik.image=[UIImage imageNamed:@"Settings_CheckBox2_2.png"];
    }
    else
    {
        self.txtEmailId.text=@"";
        self.txtPassword.text=@"";
        self.imgTikUntik.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];    }
}
- (IBAction)btnRegisterClicked:(id)sender {
    
    IBShortRegisterVC *objIBShortRegisterVC;
    if (kDevice==kIphone) {
        objIBShortRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC" bundle:nil];
    }
    else{
        objIBShortRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC_iPad" bundle:nil];
        
    }
    [self.navigationController pushViewController:objIBShortRegisterVC animated:YES];
}

- (IBAction)btnForgotPwdClicked:(id)sender {
    IBForgotPasswordVC *objIBForgotPasswordVC;
    if (kDevice==kIphone) {
        objIBForgotPasswordVC =[[IBForgotPasswordVC alloc]initWithNibName:@"IBForgotPasswordVC" bundle:nil];
    }
    else{
        objIBForgotPasswordVC =[[IBForgotPasswordVC alloc]initWithNibName:@"IBForgotPasswordVC_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:objIBForgotPasswordVC animated:YES];
}

-(void)setClassNameToPush
{
    NSLog(@"User data: %@",[kAppDelegate dictUserInfo]);
    NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];

    if ([self.classType isEqualToString:@"RegisterWithSaleCode"]||[self.classType isEqualToString:@"Cards"]||[self.classType isEqualToString:kOffers]) {
        if ([userID length]>0&&[userPayment isEqualToString:@"active"])
        {
            [kAppDelegate.objSideBarVC btnOffersClicked:nil];
            [CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];
            
            
            
            IBCategoryVC *objIBCategoryVC;
            if (kDevice == kIphone) {
                objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC" bundle:nil];
            }
            else {
                objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC_iPad" bundle:nil];
            }
            
            kAppDelegate.navController=[[UINavigationController alloc]initWithRootViewController:objIBCategoryVC];
            /*commented by Utkarsha to hide Ads it not available
             [self addBottomADView];
             */
            kAppDelegate.navController.navigationBarHidden = YES;
            
            
            kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
            
            kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
            
            kAppDelegate.sideMenuController.leftViewWidth = 260.0;
            kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];

//            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBCategoryVC] animated:NO];
            [self showMenu:_btnMenu];

        }
      /*  else if([userID length]>0&&[userPayment isEqualToString:@"inactive"])
        {
       
            if([[[kAppDelegate dictUserInfo]valueForKey:@"salespersonId"]length]>0&&[[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] ==0)
            {
                IBExtraDonationVC *objIBExtraDonationVC;
                
                if (kDevice==kIphone) {
                    objIBExtraDonationVC=[[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC" bundle:nil];
                }
                else{
                    objIBExtraDonationVC=[[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC_iPad" bundle:nil];
                }
                //objIBExtraDonationVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
                [self.navigationController pushViewController:objIBExtraDonationVC animated:YES];
            }
            else
            {
                IBPaymentVC *objIBPaymentVC;
                
                if (kDevice==kIphone) {
                    objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
                }
                else{
                    objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
                }
//                objIBPaymentVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
                [self.navigationController pushViewController:objIBPaymentVC animated:YES];
            }
        }*/
    }
    else if ([self.classType isEqualToString:@"Profile"]) {
      
        [kAppDelegate.objSideBarVC btnOffersClicked:nil];
    }
    else if ([self.classType isEqualToString:kGiftClass]) {
        [kAppDelegate.objSideBarVC btnGiftAppClicked:nil];
    }
}
- (IBAction)btnBackClicked:(id)sender {
    [kAppDelegate.navController popViewControllerAnimated:YES];
}
#pragma mark-
#pragma mark - Set Initial Variables
/**
 Set initial labels
 */
-(void)setInitialLabels
{        

     self.lblCopyRight.text = [CommonFunction getCopyRightText];
     if ([self.classType isEqualToString:kGiftClass]||[self.classType isEqualToString:kOffers]) {
         _btnBack.hidden=NO;
     }
    self.lblScreenName.font=[UIFont fontWithName:kFont size:self.lblScreenName.font.pointSize];
    self.lblEmailId.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lblPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lblRememberMe.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnLogin.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnRegister.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnForgotPwd.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    
    NSArray *arrTextFields=[[NSArray alloc]initWithObjects:self.txtEmailId,self.txtPassword, nil];
    for (UITextField *obj in arrTextFields)
    {
        UIView *leftPAdding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, obj.frame.size.height)];
        obj.leftView = leftPAdding;
        obj.leftViewMode = UITextFieldViewModeAlways;
        obj.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
        obj.layer.borderWidth = 1;
        [obj setValue:[UIColor lightGrayColor]
           forKeyPath:@"_placeholderLabel.textColor"];
    }
    UIButton *buttonShowPassword=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShowPassword setImage:[UIImage imageNamed:@"eye.png"] forState:UIControlStateNormal];
    [buttonShowPassword addTarget:self action:@selector(btnShowpassword:) forControlEvents:UIControlEventTouchUpInside];
    buttonShowPassword.frame=CGRectMake(0, 0, 25, 25);
    buttonShowPassword.tag=1;
    self.txtPassword.rightView=buttonShowPassword;
    self.txtPassword.rightViewMode=UITextFieldViewModeAlways;
    
    UIView *clearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//    buttonShowPassword.frame=CGRectMake(0, 0, 25, 25);
    self.txtEmailId.rightView=clearView;
    self.txtEmailId.rightViewMode=UITextFieldViewModeAlways;
    [self.txtEmailId becomeFirstResponder];

    
}
-(void)btnShowpassword:(UIButton *)btneye
{
    btneye.selected = !btneye.selected;
    _txtPassword.secureTextEntry=!btneye.selected;
        
    
    
}

#pragma mark -
#pragma mark - Delegate Methods

#pragma mark -
#pragma mark - UITextField Delegate & Validation Check
/**
 @Method    -  checkFieldValidation -> Perform validation check on field value
 @Responce  -  YES -> If all field are filled with valid value
 No  -> If any field empty or Invalid value
 */
-(BOOL)checkFieldValidation{
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    NSString *str=@"";
    if ([emailTest evaluateWithObject:self.txtEmailId.text] != YES ) {
        str=@"valid Email-Id";
    }
    if (self.txtEmailId.text.length==0) {
        str=@"Email-Id";
    }
    if (self.txtPassword.text.length<=0  )
    {
        if ([str length]>0) {
            str=[str stringByAppendingString:@" and "];
            str=[str stringByAppendingString:@"Password"];
        }
        else{
            str=@"Password";
        }
    }
    if (str.length>0) {
        [CommonFunction fnAlert:[NSString stringWithFormat:@"Please enter %@.",str] message:nil ];
        return NO;
    }
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered
{
    BOOL returnVal=YES;
    if (textField==self.txtEmailId) {
        NSCharacterSet *NUMBERS	= [NSCharacterSet characterSetWithCharactersInString:@"qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM1234567890_.@ "];
        
        for (int i = 0; i < [textEntered length]; i++)
        {
            unichar d = [textEntered characterAtIndex:i];
            if (![NUMBERS characterIsMember:d])
            {
                returnVal= NO;
            }
            else returnVal= YES;
        }
    }
    else
        {
            returnVal= YES;
        }
    return returnVal;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [CommonFunction callHideViewFromSideBar];
    
    if (textField==self.txtEmailId||textField==self.txtPassword) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-50, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        if ([[CommonFunction getValueFromUserDefault:kRememberMe] isEqualToString:@"YES"])
        {
            [CommonFunction setValueInUserDefault:kEmailId value:self.txtEmailId.text];
            [CommonFunction setValueInUserDefault:kPassword value:self.txtPassword.text];
        }
        else{
            [CommonFunction setValueInUserDefault:kEmailId value:@""];
            [CommonFunction setValueInUserDefault:kPassword value:@""];
        }
    if (kDevice!=kIphone) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
        }completion:^(BOOL finished) {
        }];
    }
    
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.txtEmailId) {
        [self.txtPassword becomeFirstResponder];
    }
    else{
    [textField resignFirstResponder];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
    }completion:^(BOOL finished) {
    }];
    }
	return YES;
}
#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.txtEmailId resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        if (self.view.frame.origin.y==-50) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
            }completion:^(BOOL finished) {
            }];
        }
    
    }
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kRegisterIncompleteTag && buttonIndex==1) {
        IBShortRegisterVC *objIBRegisterVC;
        if (kDevice==kIphone) {
            objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC" bundle:nil];
        }
        else{
            objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC_iPad" bundle:nil];
        }
        objIBRegisterVC.strEditProfile=@"RegisteredNotPaid";
        objIBRegisterVC.dictProfileData=dictLoginInfo;
        [kAppDelegate.navController pushViewController:objIBRegisterVC animated:YES];
    }
    else if ([alertView tag]==kMerchantUserTag) {
        if (buttonIndex==1) {
            if ([[dictResult valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[dictResult valueForKey:@"userPayments"]isEqualToString:@"active"]) {
                [self setValueForActiveUser:dictResult];
            }
            
            else  if ([[dictResult valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[dictResult valueForKey:@"userPayments"]isEqualToString:@"inactive"]) {
                [self setValueForInactiveUser:dictResult];
            }
        }
        else if(buttonIndex==0){
            [CommonFunction setValueInUserDefault:kMerchantId value:[dictResult valueForKey:kMerchantId]];
            if ([[dictResult valueForKey:@"isSkip"]isEqualToString:@"yes"]) {
                if ([[dictResult valueForKey:@"isMerchantMultiple"] isEqual:[NSNumber numberWithChar:1]])
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"multiMerchant"];
                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];
                }
                else
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];
                }

            }
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                KSChangePasswordViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                [viewController setViewMode:viewFromChangePasswordMerchant];
                kAppDelegate.window.rootViewController = viewController;
                [kAppDelegate.window makeKeyAndVisible];
                
            }
           // [CommonFunction setValueInUserDefault:kUserType value:@"Merchant"];
            [self setRememberMeValue:@"Merchant"];

        }
    }
    
    else if (alertView.tag == kGRUUSERTag) {
        if (buttonIndex == 0) {
            IBPaymentVC *objIBPaymentVC;
            if (kDevice == kIphone) {
                objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
            }
            else{
                objIBPaymentVC= [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
            }
            [self.navigationController pushViewController:objIBPaymentVC animated:TRUE];
        }
        else {
            [kAppDelegate.objSideBarVC btnOffersClicked:nil];
        }
    }
}
-(void)setRememberMeValue:(NSString *)userType{
    if (self.imgTikUntik.image==[UIImage imageNamed:@"Settings_CheckBox2_2.png"])
    {
        [CommonFunction setValueInUserDefault:kRememberMe value:@"YES"];
        [CommonFunction setValueInUserDefault:kUserType value:userType];
    }
}

#pragma mark -
#pragma mark - Segues
/**
 @Method    -  prepareForSegue: -> Use if you want to send/set value to destination controller
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue_ChangePassword"]){
        [segue.destinationViewController setViewMode:viewFromChangePasswordMerchant];
    }
}
#pragma mark Set Value for Active or Inactive user
-(void)setValueForInactiveUser:(NSMutableDictionary *)result{
     if ([self.classType isEqualToString:kGiftClass]) {
      //  [kAppDelegate.objSideBarVC btnGiftAppClicked:nil];
         [kAppDelegate.objSideBarVC callPaymentClass];
    }
    else if ( [[result valueForKey:@"isUserGruEdu"] intValue] == 1)
    {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are only authorized to use this App free on the third Thursday of every month.  If you want these deals every day and help secure support of “GRU Day” for the future, it's only $3.99 per month." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Use Free", nil];
//    alert.tag = kGRUUSERTag;
//    [alert show];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your registration is incomplete,do you want to complete that?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        alert.tag=kRegisterIncompleteTag;
    }

    else{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your registration is incomplete,do you want to complete that?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    alert.tag=kRegisterIncompleteTag;
    }
    kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
    dictLoginInfo=[result valueForKey:@"userDetail"];
    [CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
    [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
    [self setRememberMeValue:@"User"];

}
-(void)setValueForActiveUser:(NSMutableDictionary *)result{
    
    kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
//    [kAppDelegate.dictUserPaymentInfo setValue:[result  valueForKey:@"nextPaymentDate"] forKey:@"nextPaymentDate"];
//    [kAppDelegate.dictUserPaymentInfo setValue:[result  valueForKey:@"paymentType"] forKey:@"paymentType"];
    [CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
    [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
    [CommonFunction setValueInUserDefault:kNotificationBadgeCount value:[result valueForKey:@"badge_count"]];
    [self setClassNameToPush];
    NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:kAppDelegate.dictUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:newdata forKey:kdictUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setRememberMeValue:@"User"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
	    //[self callLocationService:[CommonFunction getValueFromUserDefault:kLatitude] andlongitute:[CommonFunction getValueFromUserDefault:kLongitude]];
	});

    NSLog(@"Location method called");
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
				[CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
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
	});
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

@end
