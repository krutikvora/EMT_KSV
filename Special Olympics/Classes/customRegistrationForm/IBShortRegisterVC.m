//
//  IBShortRegisterVC.m
//  iBuddyClient
//
//  Created by Utkarsha on 02/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBShortRegisterVC.h"
#define kGruAlertTag 9898
#define kGiftAlertTag 9797
#define kNoMerchantAlertTag 9494
#define kShowSideBarAlertTag 9292

@interface IBShortRegisterVC ()
{
    NSMutableDictionary *fbParaDict;
    BOOL userRegisteredWithFacebook;
    NSMutableDictionary *userDetailDict;
}
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) NSString *strData;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSubmitClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;


@end

@implementation IBShortRegisterVC
@synthesize strStudentCode;

@synthesize mConfirmPassword, mPassword, mScrollView, mTextEntered, mEmailAddressTextField, strEditProfile, strSalespersonCode, lblConfirmPwd, lblPassword, btnBack, btnSubmit, btnTapLogin, dictProfileData, lblCopyRight,btnTapped,txtFirstname,txtLastname,txtPhone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
	// Do any additional setup after loading the view from its nib.
	[self setInitialVaribles];
	arrTextFields = [[NSMutableArray alloc] initWithObjects:txtFirstname, txtLastname, txtPhone,mEmailAddressTextField,mPassword, mConfirmPassword,  nil];
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
    mPassword.rightView=buttonShowPassword;
    mPassword.rightViewMode=UITextFieldViewModeAlways;
    
    UIButton *buttonShowPassword1=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShowPassword1 setImage:[UIImage imageNamed:@"eye.png"] forState:UIControlStateNormal];
    [buttonShowPassword1 addTarget:self action:@selector(btnShowpassword:) forControlEvents:UIControlEventTouchUpInside];
    buttonShowPassword1.tag=2;

    buttonShowPassword1.frame=CGRectMake(0, 0, 25, 25);
    mConfirmPassword.rightView=buttonShowPassword1;
    mConfirmPassword.rightViewMode=UITextFieldViewModeAlways;

    
	[self setUpCustomForm];
    [facebookLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [mEmailAddressTextField resignFirstResponder];
}
-(void)btnShowpassword:(UIButton *)btneye
{
    btneye.selected = !btneye.selected;
    if(btneye.tag==1)
    {
        mPassword.secureTextEntry=!btneye.selected;

    }
    else
    {
        mConfirmPassword.secureTextEntry=!btneye.selected;
    }
        
        
}
// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else
         {
             NSLog(@"Logged in");
             // Token created successfully and you are ready to get profile info
             [[NSUserDefaults standardUserDefaults]setValue:result.token.userID forKey:@"fbToken"];
             [self getFacebookProfileInfo];
         }
     }];
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
             [fbParaDict setValue:[result objectForKey:@"email"] forKey:@"email"];
             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"fbToken"] forKey:@"facebookId"];
             [fbParaDict setValue:[result objectForKey:@"firstname"] forKey:@"firstname"];
             [fbParaDict setValue:[result objectForKey:@"lastname"] forKey:@"lastname"];

             
             if ([self.strSalespersonCode length] > 0) {
                 [fbParaDict setValue:self.strSalespersonCode forKey:@"salespersonId"];
             }
             else {
                 [fbParaDict setValue:@"" forKey:@"salespersonId"];
             }
             if ([self.strStudentCode length] > 0) {
                 [fbParaDict setValue:self.strStudentCode forKey:@"studentId"];
                 [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"Student"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
             }
             else {
                 [fbParaDict setValue:@"" forKey:@"studentId"];
                 [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Student"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
             }
             
             [fbParaDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
             [fbParaDict setValue:deviceTest forKey:@"deviceType"];
             
             
             //
             
             
             [self callAPIForFBLogin];
         }
         else
         {
             [kAppDelegate hideProgressHUD];         }
     }];
    [connection start];
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
-(void)callAPIForFBLogin
{
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:fbParaDict method:kfbRegisterAPI] completeBlock: ^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        userDetailDict=[[NSMutableDictionary alloc]init];
        userDetailDict=[result valueForKey:@"userDetail"];
        /*********** Done by pooja *************/
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]] && [[result valueForKey:@"isUserGruEdu"] intValue] == 1)
        {
           
                NSString *messageString=[result valueForKey:@"message"] ;
                NSString *appNameStr=@"CyclingWins";
                NSString *appURLString= @"Cyclingwins.com";
                NSString *doubleSlashStr= @"\n";
                messageString=[messageString stringByReplacingOccurrencesOfString:@"appName" withString:appNameStr];
                messageString=[messageString stringByReplacingOccurrencesOfString:@"appLink" withString:appURLString];
                messageString=[messageString stringByReplacingOccurrencesOfString:@"\\n" withString:doubleSlashStr];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:messageString delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                alert.tag = kGruAlertTag;
                [alert show];
            
            [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
        } /**********/
//        else  if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]] && [[result valueForKey:@"isUserGruEdu"] intValue] == 0 && [btnTapped isEqualToString:@"educatorLogin"])
//        {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You didn't enter a valid educator Email Id. If you want to have the app free of cost please enter valid email id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//            [loginManager logOut];
//            [FBSDKAccessToken setCurrentAccessToken:nil];
//        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            if ([[dictProfileData valueForKey:@"classType"]isEqualToString:kGiftClass]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully completed registration.  Now you can gift the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = kGiftAlertTag;
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully completed one step of registration.  Click the next button to go ahead." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            /*commented in order to implement not to log out unpaid user*/
            // [CommonFunction setValueInUserDefault:kUserId value:[result valueForKey:@"userId"]];
            [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
            
            userRegisteredWithFacebook=TRUE;
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
            [CommonFunction fnAlert:@"Registration Failure" message:@"Please enter the complete details"];
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]) {
            [CommonFunction fnAlert:@"Email already exists!" message:@"Please login with your existing email-id "];
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:3]]) {
            [CommonFunction fnAlert:@"Alert!" message:@"Unable to upload image, please choose another valid profile image"];
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
        }
        else
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        [kAppDelegate hideProgressHUD];
    } errorBlock: ^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else {
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [kAppDelegate hideProgressHUD];
    }];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
	[self setMPassword:nil];
	[self setMConfirmPassword:nil];
	[self setLblPassword:nil];
	[self setLblConfirmPwd:nil];
	[self setMConfirmEmail:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark - Button Actions

- (IBAction)btnBackClicked:(id)sender {
	[kAppDelegate.navController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitClicked:(id)sender {
    
    if(userRegisteredWithFacebook)
    {
        
        if ([strEditProfile isEqualToString:@"RegisteredNotPaid"] || [strEditProfile isEqualToString:@"RegisterSuccess"]) {
            /*****Commented and added bu Utkarsha to implement extra donation screen
             IBPaymentVC *objIBPaymentVC;
             
             if (kDevice==kIphone) {
             objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
             }
             else{
             objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
             }
             objIBPaymentVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
             [self.navigationController pushViewController:objIBPaymentVC animated:YES];
             ******/
            NSLog(@"%@", [kAppDelegate dictUserInfo]);
            //			if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 0) {
            //				IBExtraDonationVC *objIBExtraDonationVC;
            //
            //				if (kDevice == kIphone) {
            //					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC" bundle:nil];
            //				}
            //				else {
            //					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC_iPad" bundle:nil];
            //				}
            //				//objIBExtraDonationVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
            //				[self.navigationController pushViewController:objIBExtraDonationVC animated:YES];
            //			}
            //			else {
            //				IBPaymentVC *objIBPaymentVC;
            //
            //				if (kDevice == kIphone) {
            //					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
            //				}
            //				else {
            //					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
            //				}
            //				objIBPaymentVC.strClassTypeForPaymentScreen = @"Dashboard"; //bit for not to hide back button on payment screen.
            //				[self.navigationController pushViewController:objIBPaymentVC animated:YES];
            //			}
            
            ///Krutik Changes
            
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
            
            [kAppDelegate.navController pushViewController:objPaymentProgramVC animated:NO];
            
//            IBRegisterVC *objIBRegisterVC;
//            if (kDevice==kIphone) {
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
//            }
//            else{
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
//            }
//            objIBRegisterVC.strEditProfile=@"Edit";
//            //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
//            objIBRegisterVC.strController = @"My Profile";
//            objIBRegisterVC.isNewUser=YES;
//            //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
//            //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
//            //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
//            // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
//            
//            [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
            //Krutik Change End==================================================================

        }
        
        
        
    }
else
{
    //Method to call the registartion process
    if ([self.txtFirstname.text isEqualToString:@""] || [self.txtFirstname.text isEqual:[NSNull null]] || [self.txtFirstname.text length] == 0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your First Name."];
    }
    else if ([self.txtLastname.text isEqualToString:@""] || [self.txtLastname.text isEqual:[NSNull null]] || [self.txtLastname.text length] == 0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Last Name."];
    }
    else if ([self.txtPhone.text isEqualToString:@""] || [self.txtPhone.text isEqual:[NSNull null]] || [self.txtPhone.text length] == 0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Phone Number."];
    }

    else if ([self.mEmailAddressTextField.text isEqualToString:@""] || [self.mEmailAddressTextField.text isEqual:[NSNull null]] || [self.mEmailAddressTextField.text length] == 0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Email Address."];
    }
    else if (![self.mEmailAddressTextField.text isEqualToString:@""] && ![CommonFunction checkEmail:self.mEmailAddressTextField.text]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter valid Email Address."];
    }
    else if (([self.mPassword.text isEqualToString:@""] || [self.mPassword.text isEqual:[NSNull null]] || [self.mPassword.text length] == 0) && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Password."];
    }
    else if (([self.mConfirmPassword.text isEqualToString:@""] || [self.mConfirmPassword.text isEqual:[NSNull null]] || [self.mConfirmPassword.text length] == 0) && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Confirmed password."];
    }
    else if (![self.mPassword.text isEqualToString:self.mConfirmPassword.text] && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
        [CommonFunction fnAlert:@"" message:@"Your Password & Confirm Password must be same"];
    }
    else {
        if ([strEditProfile isEqualToString:@"RegisteredNotPaid"] || [strEditProfile isEqualToString:@"RegisterSuccess"]) {
            /*****Commented and added bu Utkarsha to implement extra donation screen
             IBPaymentVC *objIBPaymentVC;
             
             if (kDevice==kIphone) {
             objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
             }
             else{
             objIBPaymentVC=[[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
             }
             objIBPaymentVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
             [self.navigationController pushViewController:objIBPaymentVC animated:YES];
             ******/
            NSLog(@"%@", [kAppDelegate dictUserInfo]);
            //			if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 0) {
            //				IBExtraDonationVC *objIBExtraDonationVC;
            //
            //				if (kDevice == kIphone) {
            //					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC" bundle:nil];
            //				}
            //				else {
            //					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC_iPad" bundle:nil];
            //				}
            //				//objIBExtraDonationVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
            //				[self.navigationController pushViewController:objIBExtraDonationVC animated:YES];
            //			}
            //			else {
            //				IBPaymentVC *objIBPaymentVC;
            //
            //				if (kDevice == kIphone) {
            //					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
            //				}
            //				else {
            //					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
            //				}
            //				objIBPaymentVC.strClassTypeForPaymentScreen = @"Dashboard"; //bit for not to hide back button on payment screen.
            //				[self.navigationController pushViewController:objIBPaymentVC animated:YES];
            //			}
            
            ///Krutik Changes
            
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
            
            [kAppDelegate.navController pushViewController:objPaymentProgramVC animated:NO];

            
//            IBRegisterVC *objIBRegisterVC;
//            if (kDevice==kIphone) {
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
//            }
//            else{
//                objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
//            }
//            objIBRegisterVC.strEditProfile=@"Edit";
//            //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
//            objIBRegisterVC.strController = @"My Profile";
//            objIBRegisterVC.isNewUser=YES;
            //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
            //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
            //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
            // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
            
//            [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
            //Krutik Change End==================================================================
        }
        else {
            [kAppDelegate showProgressHUD:self.view];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self callRegistrationService];
                //[self checkMerchantsWithinZipCode];
            });
        }
    }

}
    
	}

- (void)callRegistrationService {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.mEmailAddressTextField.text forKey:@"email"];
    [dict setValue:self.mPassword.text forKey:@"password"];
    [dict setValue:self.txtFirstname.text forKey:@"firstname"];
    [dict setValue:self.txtLastname.text forKey:@"lastname"];
    [dict setValue:self.txtPhone.text forKey:@"phone"];

    if ([self.strSalespersonCode length] > 0)
    {
        [dict setValue:self.strSalespersonCode forKey:@"salespersonId"];
    }
    else
    {
        [dict setValue:@"" forKey:@"salespersonId"];
    }
    if ([self.strStudentCode length] > 0)
    {
        [dict setValue:self.strStudentCode forKey:@"studentId"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"Student"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        [dict setValue:@"" forKey:@"studentId"];
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Student"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
    [dict setValue:deviceTest forKey:@"deviceType"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kNewRegister] completeBlock: ^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            userDetailDict=[[NSMutableDictionary alloc]init];
            userDetailDict=[result valueForKey:@"userDetail"];
            /*********** Done by pooja *************/
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]] && [[result valueForKey:@"isUserGruEdu"] intValue] == 1)
            {
                
                    NSString *messageString=[result valueForKey:@"message"] ;
                    NSString *appNameStr=@"Fire Rescue Funding";
                    NSString *appURLString= @"specialolympicswins.com";
                    NSString *doubleSlashStr= @"\n";
                    messageString=[messageString stringByReplacingOccurrencesOfString:@"appName" withString:appNameStr];
                    messageString=[messageString stringByReplacingOccurrencesOfString:@"appLink" withString:appURLString];
                    messageString=[messageString stringByReplacingOccurrencesOfString:@"\\n" withString:doubleSlashStr];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:messageString delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    alert.tag = kGruAlertTag;
                    [alert show];
                
                [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
                userRegisteredWithFacebook=FALSE;

            } /**********/
//            else  if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]] && [[result valueForKey:@"isUserGruEdu"] intValue] == 0 && [btnTapped isEqualToString:@"educatorLogin"])
//            {
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You didn't enter a valid educator Email Id. If you want to have the app free of cost please enter valid email id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
//            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                if ([[dictProfileData valueForKey:@"classType"]isEqualToString:kGiftClass]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully completed registration.  Now you can gift the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = kGiftAlertTag;
                    [alert show];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully completed one step of registration.  Click the next button to go ahead." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                /*commented in order to implement not to log out unpaid user*/
                // [CommonFunction setValueInUserDefault:kUserId value:[result valueForKey:@"userId"]];
                [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                [CommonFunction fnAlert:@"Registration Failure" message:@"Please enter the complete details"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]) {
                [CommonFunction fnAlert:@"Email already exists!" message:@"Please login with your existing email-id "];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:3]]) {
                [CommonFunction fnAlert:@"Alert!" message:@"Unable to upload image, please choose another valid profile image"];
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

- (IBAction)btnMenuClick:(id)sender {
    [kAppDelegate showMenu];

}

- (IBAction)btnTapLoginClicked:(id)sender {
	IBLoginVC *objIBLoginVC;
	if (kDevice == kIphone) {
		objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
	}
	else {
		objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
	}
	objIBLoginVC.classType = @"RegisterWithSaleCode";
	[self.navigationController pushViewController:objIBLoginVC animated:YES];
}

- (IBAction)btnLoginClick:(id)sender {
    
    IBLoginVC *objIBLoginVC;
    if (kDevice == kIphone) {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
    }
    else {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
    }
    [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBLoginVC] animated:NO];

}

#pragma mark- Initial Settings
- (void)setInitialVaribles {
	self.lblCopyRight.text = [CommonFunction getCopyRightText];
	isSelected = NO;
	if ([strEditProfile isEqualToString:@"RegisteredNotPaid"]) {
		self.lblTop.text = @"REGISTER™";
		[self.btnSubmit setTitle:@"Next" forState:UIControlStateNormal];
//		for (UIView *view in self.mScrollView.subviews) {
//			if ([view isKindOfClass:[UITextField class]]) {
//				UITextField *textField = (UITextField *)view;
//				textField.text = [dictProfileData valueForKey:@"email"];
//				textField.userInteractionEnabled = NO;
//			}
//		}
    
        mEmailAddressTextField.text =[dictProfileData valueForKey:@"email"];
        txtFirstname.text =[dictProfileData valueForKey:@"firstname"];
        txtLastname.text =[dictProfileData valueForKey:@"lastname"];
        txtPhone.text =[dictProfileData valueForKey:@"phone"];
        mEmailAddressTextField.userInteractionEnabled = NO;
        txtFirstname.userInteractionEnabled = NO;
        txtLastname.userInteractionEnabled = NO;
        txtPhone.userInteractionEnabled = NO;

		mPassword.hidden = TRUE;
		mConfirmPassword.hidden = TRUE;
		lblPassword.hidden = TRUE;
		lblConfirmPwd.hidden = TRUE;
	}
	else if ([strEditProfile isEqualToString:@"RegisterSuccess"]) {
		[self.btnSubmit setTitle:@"Next" forState:UIControlStateNormal];
		for (UIView *view in self.mScrollView.subviews) {
			if ([view isKindOfClass:[UITextField class]]) {
				UITextField *textField = (UITextField *)view;
				textField.userInteractionEnabled = NO;
			}
		}
	}

	else {
		[self.btnSubmit setTitle:@"Sign up" forState:UIControlStateNormal];
		self.lblTop.text = @"REGISTER™";
		[self.mEmailAddressTextField becomeFirstResponder];
	}
	for (UIView *view in self.mScrollView.subviews) {
		if ([view isKindOfClass:[UILabel class]]) {
			UILabel *label = (UILabel *)view;
			if (label.tag != 123) {
				label.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
				[label highlightTextInLabel:@"*"];
			}
		}
	}
    if ([strEditProfile isEqualToString:@"fromSplash"])
    
    {
        btnBack.hidden = YES;
        _btnMenu.hidden=false;

    }
    else
    {
        
        btnBack.hidden = false;
        _btnMenu.hidden=true;


    }
	self.lblTop.font = [UIFont fontWithName:kFont size:_lblTop.font.pointSize];
	self.btnSubmit.titleLabel.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
	self.btnTapLogin.titleLabel.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
	if ([self.strSalespersonCode length] > 0) {
		self.btnTapLogin.hidden = NO;
	}
}

- (void)setRegistrationVariables:(NSDictionary *)result {
	kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
	[CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
	[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
	self.strEditProfile = @"RegisterSuccess";
	[self setInitialVaribles];
	[CommonFunction setValueInUserDefault:kEmailId value:@""];
	[CommonFunction setValueInUserDefault:kPassword value:@""];
	[CommonFunction setValueInUserDefault:kRememberMe value:@"NO"];
}

#pragma mark -  Validation methods

- (BOOL)isAlpha:(NSString *)string {
	NSCharacterSet *alphaNumeric = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
	for (int i = 0; i < [string length]; i++) {
		unichar d = [string characterAtIndex:i];
		if (![alphaNumeric characterIsMember:d]) {
			return NO;
		}
		else {
			return YES;
		}
	}
	return YES;
}

//methdo to set the character set for email
- (BOOL)isnumericAlphaForEmail:(NSString *)string {
	NSCharacterSet *NUMBERS = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@._-/0123456789+"];

	for (int i = 0; i < [string length]; i++) {
		unichar letter = [string characterAtIndex:i];
		NSString *letterstring = [[NSString alloc] initWithCharacters:&letter length:1];
		if ([letterstring isEqualToString:@" "]) {
			continue;
		}

		if (![NUMBERS characterIsMember:letter]) {
			return NO;
		}
	}
	return YES;
}

//validating email

#pragma mark - Delegate Methods


#pragma mark - CUSTOM TEXTFIELD DELEGATES
- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField {
	//if (textField == mEmailAddressTextField || textField == self.mPassword || textField == self.mConfirmPassword) {
		_keyboardControls.showSegment = YES;
	//}
	return YES;
}

- (BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered {
	if (textField == self.mEmailAddressTextField) {
		if ([self isnumericAlphaForEmail:textEntered] == FALSE) {
			return NO;
		}
	}
    else if (textField == self.txtPhone) {
        NSCharacterSet *NUMBERS = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [textEntered length]; i++) {
            unichar d = [textEntered characterAtIndex:i];
            if (![NUMBERS characterIsMember:d]) {
                UIAlertView *alertIntCheck = [[UIAlertView alloc]initWithTitle:@"Please enter numbers only." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertIntCheck show];
                return NO;
            }
            NSString *str = @"";
            str = txtPhone.text;
            if (str.length == 0) {
                str = [str stringByAppendingString:@"("];
                txtPhone.text = str;
            }
            if (str.length == 4) {
                str = [str stringByAppendingString:@")"];
                txtPhone.text = str;
            }
            else if (str.length == 8) {
                str = [str stringByAppendingString:@"-"];
                txtPhone.text = str;
            }
            if ([str length] > 12) {
                txtPhone.text = [str substringToIndex:13];
                UIAlertView *alertIntCheck = [[UIAlertView alloc]initWithTitle:@"Phone number can't be greater than 10 digits." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertIntCheck show];
                return NO;
            }
            else {
                return YES;
            }
        }
    }
    else if (textField == self.txtFirstname) {
        if ([textEntered length]) {
            if ([self isAlpha:textEntered] == FALSE) {
                return NO;
            }else
                return true;
//            if ([textField.text length] > 29) {
//                if (!isNameLengthCorrect) {
//                    [CommonFunction fnAlert:@"Alert" message:@"First name can't be greater than 30 characters"];
//                    isNameLengthCorrect = YES;
//                }
//                return NO;
//            }
//            else {
//                return YES;
//            }
        }
    }

	return YES;
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == kNoMerchantAlertTag && buttonIndex == 0) {
		[kAppDelegate showProgressHUD:self.view];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		    [self callRegistrationService];
		});
	}
	else if ([alertView tag] == kShowSideBarAlertTag && buttonIndex == 0) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"showSideControls"
		                                                   object:self];
		[kAppDelegate.navController popViewControllerAnimated:NO];
	}

    else if (alertView.tag == kGruAlertTag) {
        {
            
            if(buttonIndex==1)
            {
                [[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
                //                [[kAppDelegate dictUserInfo]setValue:[CommonFunction getValueFromUserDefault:@"userId"] forKey:@"userId"];
                
                ///Krutik Changes
                
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
                
                [kAppDelegate.navController pushViewController:objPaymentProgramVC animated:NO];
                
//                IBRegisterVC *objIBRegisterVC;

//                if (kDevice==kIphone) {
//                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
//                }
//                else{
//                    objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
//                }
//                objIBRegisterVC.strEditProfile=@"Edit";
//                objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
//                objIBRegisterVC.strController = @"My Profile";
//                objIBRegisterVC.dictProfileData=userDetailDict;
//                [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];

                //Krutik Change End==================================================================

                
                
            }
            else if(buttonIndex==0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[userDetailDict valueForKey:@"email"] forKey:@"email"];
                
                [kAppDelegate showProgressHUD];
                
                
                [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:ksendEmailRaisefunds] completeBlock: ^(NSData *data) {
                    id result = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:nil];
                    
                    
                    
                        [[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
                    
                    ///Krutik Changes
                    
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
                    
                    [kAppDelegate.navController pushViewController:objPaymentProgramVC animated:NO];
                    
//                    IBRegisterVC *objIBRegisterVC;
//                    if (kDevice==kIphone) {
//                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
//                    }
//                    else{
//                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
//                    }
//                    objIBRegisterVC.strEditProfile=@"Edit";
//                    objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
//                    objIBRegisterVC.strController = @"My Profile";
//                    objIBRegisterVC.dictProfileData=userDetailDict;
//                    
//                    
//                    [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
                    //Krutik Change End==================================================================

                    
                    
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
            
            
            
        }
    }
	else if (alertView.tag == kGiftAlertTag) {
		IBPaymentVC *objIBPaymentVC;
		if (kDevice == kIphone) {
			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
		}
		else {
			objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
		}
		[self.navigationController pushViewController:objIBPaymentVC animated:TRUE];
	}
}

@end
