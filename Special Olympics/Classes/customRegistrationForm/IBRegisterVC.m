//
//  IBRegisterVC.m
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBRegisterVC.h"
#import "CustomPickerViewController.h"
#import "UIImageView+WebCache.h"
#define kiPadTableHeight 300
#define kiPhoneTableHeight 200
#define kGruAlertTag 9898
#define kGiftAlertTag 9797
#define kNoMerchantAlertTag 9494
#define kShowSideBarAlertTag 9292
@interface IBRegisterVC ()
{
	NSMutableArray *arrMonth;
	int selectedMonth;
	NSMutableArray *arrDate;
	NSArray *cityFilteredAray;
	NSArray *stateFilteredArray;
	BOOL isAddressLengthCorrect;
    BOOL firstTimeRegister;
}
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) NSString *strData;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
- (IBAction)btnUploadClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSubmitClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblZipCode;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBRegisterVC
@synthesize strData;
//TODO: Remove following textfield & Button.
@synthesize mFirstNameTextField;
@synthesize mEmailAddressTextField;
@synthesize mLastNameTextField;
@synthesize mAddressTextField;
@synthesize mPhoneNumberTextField;
@synthesize mDOB, mState, mCity;
@synthesize keyboardControls = _keyboardControls;
@synthesize strSalespersonCode;
@synthesize mAgeGroupTextField;
@synthesize popOverController;
@synthesize strEditProfile;
@synthesize isNewUser;
@synthesize dictProfileData, strDetailRegistration, strController,objSideBarVC,lblCopyRight;
bool isBrowser;
@synthesize strStudentCode;

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
	[[UIApplication sharedApplication]setStatusBarHidden:TRUE];
   // [self getPaymentToken];

//    if(isBrowser==true)
//    {
//        [self getPaymentToken];
//    }
  //  [self getPaymentToken];

}

- (void)viewDidLoad {
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEditProfileTextValues) name:@"RefreshData" object:nil];
//    if ([strDetailRegistration isEqualToString:@"DetailRegistration"]) {
//        NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kExtraDonationLink,userID]]];
//
//    }
    if(isNewUser==YES)
    {
        isBrowser=true;
        NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
        if([[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue]==1)
        {
            
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
        isNewUser=false;
    }

    mEmailAddressTextField.userInteractionEnabled = YES;
	[self setInitialVaribles];
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
	isNameLengthCorrect = NO;
	isAddressLengthCorrect = NO;

	arrTextFields = [[NSMutableArray alloc] initWithObjects:mFirstNameTextField,mLastNameTextField, _mMonth, _mDate, mAgeGroupTextField, mAddressTextField, mState, mCity, mEmailAddressTextField, _mPassword, _mConfirmPassword, mPhoneNumberTextField,  nil];
    
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

    UIImageView *leftPAdding = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    leftPAdding.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding.contentMode=UIViewContentModeScaleAspectFit;
    _mMonth.rightView = leftPAdding;
    _mMonth.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftPAdding1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  5, 30, 30)];
    leftPAdding1.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding1.contentMode=UIViewContentModeScaleAspectFit;

    _mDate.rightView = leftPAdding1;
    _mDate.rightViewMode = UITextFieldViewModeAlways;

    UIImageView *leftPAdding2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  5, 30, 30)];
    leftPAdding2.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding2.contentMode=UIViewContentModeScaleAspectFit;
    mAgeGroupTextField.rightView = leftPAdding2;
    mAgeGroupTextField.rightViewMode = UITextFieldViewModeAlways;


    UIView *rightArrow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
    _txtZipCode.leftView = rightArrow;
    _txtZipCode.leftViewMode = UITextFieldViewModeAlways;
    _txtZipCode.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
    _txtZipCode.layer.borderWidth = 1;
    [_txtZipCode setValue:[UIColor lightGrayColor]
               forKeyPath:@"_placeholderLabel.textColor"];


	[self createPickerForFields:[NSArray arrayWithObjects:mAgeGroupTextField, nil] withPickerDataInArrayFormat:@[
	     @[@"0-18 years", @"19-39 years", @"40-55 years", @"55-over years"]]
	];
	arrMonth = [NSMutableArray arrayWithArray:@[@"January", @"February", @"March", @"April", @"May", @"Jun", @"July", @"August", @"September", @"October", @"November", @"December"]];


	[self setUpCustomForm];
    [self.mFirstNameTextField becomeFirstResponder];

    
	citiesList.hidden = YES;
	stateList.hidden = YES;
    [self.view bringSubviewToFront:_mScrollView];

//    else
//    {
//        [self getPaymentToken];
//    }

	// Do any additional setup after loading the view from its nib.
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
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            
            isBrowser=false;
            if([[result valueForKey:@"isSubscribed"] isEqualToString:@"1"])
            {
                [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"address" value:[result valueForKey:@"address"]];
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"last_anme" value:[result valueForKey:@"last_name"]];

                [CommonFunction setValueInUserDefault:@"zipCode" value:[result valueForKey:@"zipcode"]];
//                NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
//                NSString *statePath = [[NSBundle mainBundle] pathForResource:@"states1" ofType:@"plist"];
//                NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
//                NSMutableArray *arrState = [[NSMutableArray alloc] initWithContentsOfFile:statePath];
//                NSString *city = nil;
//                NSString *state = nil;
//                NSString *stateId = nil;
//                NSString *cityId = nil;
//                for (int cityCounter = 0; cityCounter < [arrCity count]; cityCounter++) {
//                    if ([[[arrCity objectAtIndex:cityCounter] valueForKey:@"ZipCode"] isEqualToString:[CommonFunction getValueFromUserDefault:@"zipCode"]]) {
//                        city =[[arrCity objectAtIndex:cityCounter] valueForKey:@"City_Alias"];
//                        stateId = [[arrCity objectAtIndex:cityCounter] valueForKey:@"StateID"];
//                        cityId = [[arrCity objectAtIndex:cityCounter] valueForKey:@"CityID"];
//                        break;
//                    }
//                }
//                
//                for (int stateCounter = 0; stateCounter < [arrState count]; stateCounter++) {
//                    if ([[[arrState objectAtIndex:stateCounter] valueForKey:@"StateID"] isEqualToString:stateId]) {
//                        state =[[arrState objectAtIndex:stateCounter] valueForKey:@"Name"];
//                        break;
//                    }
//                }
//                
//                if (city.length==0) {
//                }
//                else {
                [CommonFunction setValueInUserDefault:@"SelectedState" value:[result valueForKey:@"stateName"]];
                [CommonFunction setValueInUserDefault:@"SelectedCity" value:[result valueForKey:@"cityName"]];
                [CommonFunction setValueInUserDefault:@"SelectedStateID" value:[result valueForKey:@"stateId"]];
                [CommonFunction setValueInUserDefault:@"SelectedCityID" value:[result valueForKey:@"cityId"]];
             //   }
                if ([[CommonFunction getValueFromUserDefault:@"userName"] length] > 0) {
                    mFirstNameTextField.text = [CommonFunction getValueFromUserDefault:@"userName"];
                }
                else {
                    mFirstNameTextField.text = [dictProfileData valueForKey:@"name"];
                }
                
                if ([[CommonFunction getValueFromUserDefault:@"last_name"] length] > 0) {
                    self.mLastNameTextField.text = [CommonFunction getValueFromUserDefault:@"last_name"];
                }
                else {
                    self.mLastNameTextField.text = [dictProfileData valueForKey:@"last_name"];
                }

                if ([[CommonFunction getValueFromUserDefault:@"address"] length] > 0) {
                    self.mAddressTextField.text = [CommonFunction getValueFromUserDefault:@"address"];
                }
                else {
                    self.mAddressTextField.text = [dictProfileData valueForKey:@"address"];
                }
                mEmailAddressTextField.text = [result valueForKey:@"email"];
                
                if ([[CommonFunction getValueFromUserDefault:@"zipCode"] length] > 0) {
                    self.txtZipCode.text = [CommonFunction getValueFromUserDefault:@"zipCode"];
                    self.mState.enabled = TRUE;
                    self.mCity.enabled = TRUE;
                    self.mState.text = [CommonFunction getValueFromUserDefault:@"SelectedState"];
                    self.mCity.text = [CommonFunction getValueFromUserDefault:@"SelectedCity"];
                    NSLog(@"state id is %@", [CommonFunction getValueFromUserDefault:@"SelectedStateID"]);
                    
                }

            }
            else
            {
                NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kExtraDonationLink,userID]]];

            }
           // strPaymentToken=[result valueForKey:@"paymentToken"];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
            
           // strPaymentToken=@"";
            [kAppDelegate hideProgressHUD];
            
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
            
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
            
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
- (void)viewDidUnload {
	[self setMDOB:nil];
	[self setMState:nil];
	[self setMCity:nil];

	stateList = nil;
	[self setMConfirmEmail:nil];
	[self setMPassword:nil];
	[self setMConfirmPassword:nil];
	[self setLblPassword:nil];
	[self setLblConfirmPwd:nil];
	[self setLblPhoneNumber:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods
#pragma mark - Button Actions


- (IBAction)btnUploadClicked:(id)sender {
	UIActionSheet *actionSheetCapturePhoto = [[UIActionSheet alloc]
	                                          initWithTitle:nil
	                                                           delegate:self
	                                                  cancelButtonTitle:nil
	                                             destructiveButtonTitle:@"Cancel"
	                                                  otherButtonTitles:@"Choose from Gallery", @"Capture Photo", nil];
	actionSheetCapturePhoto.actionSheetStyle = UIActivityIndicatorViewStyleGray;
	//[actionSheetCapturePhoto showInView:self.view];
	if (kAppDelegate.navController.toolbarHidden == YES) {
		[actionSheetCapturePhoto showInView:self.view];
	}
	else {
		[actionSheetCapturePhoto showFromToolbar:kAppDelegate.navController.toolbar];
	}
}

- (IBAction)btnBackClicked:(id)sender {
	if ([strEditProfile isEqualToString:@"Edit"]) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"showSideControls"
		                                                   object:self];
		[kAppDelegate.navController popViewControllerAnimated:NO];
		//[kAppDelegate.navController dismissModalViewControllerAnimated:YES];
	}
	else {
		[[[CustomPickerViewController sharedManager] view] setHidden:YES];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)btnSubmitClicked:(id)sender {
	//Method to call the registartion process
	if ([self.strData isEqualToString:@""] || strData == (id)[NSNull null] || [strData length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select Profile Image."];
	}
	else if ([self.mFirstNameTextField.text isEqualToString:@""] || [self.mFirstNameTextField.text length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter First Name."];
	}
	// Commented by UTKARSHA GUPTA on 4/4/14

	  else if ([self.mLastNameTextField.text isEqualToString:@""]||[self.mLastNameTextField.text length]==0) {

	      [CommonFunction fnAlert:@"Alert" message:@"Please enter Last Name."];
	   }
    // Commented by UTKARSHA GUPTA on 17/10/14

//	else if ([self.mMonth.text isEqualToString:@""] || [self.mMonth.text isEqualToString:@"Month"] || [self.mMonth.text length] == 0) {
//		[CommonFunction fnAlert:@"Alert" message:@"Please fill your Birth Month."];
//	}
//	else if ([self.mDate.text isEqualToString:@""] || [self.mDate.text isEqualToString:@"Day"] || [self.mDate.text length] == 0) {
//		[CommonFunction fnAlert:@"Alert" message:@"Please fill your Birth Date."];
//	}
//	else if ([self.mAgeGroupTextField.text isEqualToString:@""] || [self.mAgeGroupTextField.text length] == 0) {
//		[CommonFunction fnAlert:@"Alert" message:@"Please select your Age Group."];
//	}
//	else if ([self.mAddressTextField.text isEqualToString:@""] || [self.mAddressTextField.text length] == 0) {
//		[CommonFunction fnAlert:@"Alert" message:@"Please enter Address."];
//	}

	else if ([self.mState.text isEqualToString:@""] || [self.mState.text length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select State."];
	}
	else if ([self.mCity.text isEqualToString:@""] || [self.mCity.text length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select City."];
	}
	else if ([self.mEmailAddressTextField.text isEqualToString:@""] || [self.mEmailAddressTextField.text isEqual:[NSNull null]] || [self.mEmailAddressTextField.text length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter your Email Address."];
	}
	// Commented by UTKARSHA GUPTA
//    else if ([self.mConfirmEmail.text isEqualToString:@""] || [self.mConfirmEmail.text isEqual:[NSNull null]]||[self.mConfirmEmail.text length]==0) {
//        [CommonFunction fnAlert:@"Alert" message:@"Please enter your Confirmed Email Address."];
//    }
	else if (([self.mPassword.text isEqualToString:@""] || [self.mPassword.text isEqual:[NSNull null]] || [self.mPassword.text length] == 0) && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter your Password."];
	}
	else if (([self.mConfirmPassword.text isEqualToString:@""] || [self.mConfirmPassword.text isEqual:[NSNull null]] || [self.mConfirmPassword.text length] == 0) && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter your Confirmed password."];
	}
	else if ([self.mPhoneNumberTextField.text isEqualToString:@""] || [self.mPhoneNumberTextField.text length] == 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter your Phone Number."];
	}
	else if (![self.mEmailAddressTextField.text isEqualToString:@""] && ![CommonFunction checkEmail:self.mEmailAddressTextField.text]) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter valid Email Address."];
	}
	else if (mSelectedStateId == -1) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select valid State."];
	}
	else if (mSelectedCityID == -1) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select valid City."];
	}
//    else if (![self.mEmailAddressTextField.text isEqualToString:self.mConfirmEmail.text]) {
//        [CommonFunction fnAlert:@"" message:@"Your Email & Confirm Email must be same"];
//    }
	else if (![self.mPassword.text isEqualToString:self.mConfirmPassword.text] && (![strEditProfile isEqualToString:@"RegisteredNotPaid"] && ![strEditProfile isEqualToString:@"RegisterSuccess"] && ![strEditProfile isEqualToString:@"Edit"])) {
		[CommonFunction fnAlert:@"" message:@"Your Password & Confirm Password must be same"];
	}

	else if ([self.mPhoneNumberTextField.text length] < 13 && [self.mPhoneNumberTextField.text length] > 0) {
		[CommonFunction fnAlert:@"" message:@"Phone number can't be less than 10 digits."];
	}

	else {
		if ([strEditProfile isEqualToString:@"Edit"]) {
			[kAppDelegate showProgressHUD:self.view];
			dispatch_async(dispatch_get_global_queue(0, 0), ^{
			    [self callUpdateProfileService];
			});
		}
		else if ([strEditProfile isEqualToString:@"RegisteredNotPaid"] || [strEditProfile isEqualToString:@"RegisterSuccess"])
        {
			IBPaymentVC *objIBPaymentVC;
			if (kDevice == kIphone)
            {
				objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
			}
			else
            {
				objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
			}
			objIBPaymentVC.strClassTypeForPaymentScreen = @"Dashboard"; //bit for not to hide back button on payment screen.
			[self.navigationController pushViewController:objIBPaymentVC animated:YES];
		}
		
	}
}

- (void)checkMerchantsWithinZipCode {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[NSString stringWithFormat:@"%d", mSelectedCityID] forKey:@"cityId"];
	dispatch_sync(dispatch_get_main_queue(), ^{
	    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetMerchantsin100miles] completeBlock: ^(NSData *data) {
	        id result = [NSJSONSerialization JSONObjectWithData:data
	                                                    options:kNilOptions error:nil];
	        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
	            [kAppDelegate showProgressHUD:self.view];
	            dispatch_async(dispatch_get_global_queue(0, 0), ^{
	                [self callRegistrationService];
				});
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"There are no iBuddyClub merchants within 100 miles of your home zip code.  Are you sure you want to continue registration ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	            alert.tag = kNoMerchantAlertTag;
	            [alert show];
			}

	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
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

- (void)callRegistrationService {
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDate *today = [NSDate date];
	NSDateComponents *components = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
	NSInteger year = [components year];

	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:self.strData forKey:@"imageData"];
	[dict setValue:self.mFirstNameTextField.text forKey:@"firstName"];
	[dict setValue:self.mLastNameTextField.text forKey:@"lastName"];
	[dict setValue:selectedAgeGroup forKey:@"ageGroup"];
	[dict setValue:[NSString stringWithFormat:@"%@-%02d-%@", [NSString stringWithFormat:@"%d", year], selectedMonth, _mDate.text] forKey:@"dob"];
	[dict setValue:[NSString stringWithFormat:@"%d", mSelectedStateId] forKey:@"stateId"];
	[dict setValue:[NSString stringWithFormat:@"%d", mSelectedCityID] forKey:@"cityId"];
	[dict setValue:self.mAddressTextField.text forKey:@"address"];
	[dict setValue:self.mEmailAddressTextField.text forKey:@"email"];
	[dict setValue:self.mPhoneNumberTextField.text forKey:@"phone"];
	[dict setValue:self.mPassword.text forKey:@"password"];
	[dict setValue:self.strSalespersonCode forKey:@"salespersonId"];
	[dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
	[dict setValue:deviceTest forKey:@"deviceType"];
    [dict setValue:self.strStudentCode forKey:@"studentId"];

	dispatch_sync(dispatch_get_main_queue(), ^{
	    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kNewRegister] completeBlock: ^(NSData *data) {
	        id result = [NSJSONSerialization JSONObjectWithData:data
	                                                    options:kNilOptions error:nil];
	        /*********** Done by pooja *************/
	        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]] && [[result valueForKey:@"isUserGruEdu"] intValue] == 1) {
	            if ([[dictProfileData valueForKey:@"classType"]isEqualToString:kGiftClass]) {
	                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully completed registration.  Now you can gift the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	                alert.tag = kGiftAlertTag;
	                [alert show];
				}
	            else {
	                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are only authorized to use this App free on the third Thursday of every month.  If you want these deals every day and help secure support of “GRU Day” for the future, it's only $3.99 per month." delegate:self cancelButtonTitle:@"Pay" otherButtonTitles:@"Use Free", nil];
	                alert.tag = kGruAlertTag;
	                [alert show];
				}
	            [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
			} /**********/

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

- (void)callUpdateProfileService {
//	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
//	NSDate *today = [NSDate date];
//	NSDateComponents *components = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
//	NSInteger year = [components year];

	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
	[dict setValue:self.strData forKey:@"imageData"];
	[dict setValue:self.mFirstNameTextField.text forKey:@"firstName"];
	[dict setValue:self.mLastNameTextField.text forKey:@"lastName"];
	[dict setValue:selectedAgeGroup forKey:@"ageGroup"];
//    if (selectedMonth || _mDate.text) {
//        
//    }
	[dict setValue:[NSString stringWithFormat:@"0000-%02d-%02d", selectedMonth, [_mDate.text integerValue]] forKey:@"dob"];
	[dict setValue:[NSString stringWithFormat:@"%d", mSelectedStateId] forKey:@"stateId"];
	[dict setValue:[NSString stringWithFormat:@"%d", mSelectedCityID] forKey:@"cityId"];
	[dict setValue:self.mAddressTextField.text forKey:@"address"];
	[dict setValue:self.mEmailAddressTextField.text forKey:@"email"];
	[dict setValue:self.mPhoneNumberTextField.text forKey:@"phone"];
	[dict setValue:@"1" forKey:@"dontSendPush"];
	[dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
	[dict setValue:deviceTest forKey:@"deviceType"];

	dispatch_sync(dispatch_get_main_queue(), ^{
	    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kUpdateProfile] completeBlock: ^(NSData *data)
	    {
	        id result = [NSJSONSerialization JSONObjectWithData:data
	                                                    options:kNilOptions error:nil];
	        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
            {
	            [self setUpdateProfileValues:result];
	            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully updated your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	            alert.tag = kShowSideBarAlertTag;
	            [alert show];
	            [self setRegistrationVariables:[NSMutableDictionary dictionaryWithDictionary:result]];
	            [CommonFunction deleteValueForKeyFromUserDefault:@"isRemptionCode"];
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	            [CommonFunction fnAlert:@"Updation Failure" message:@"Please enter the complete details"];
			}

	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]) {
	            [CommonFunction fnAlert:@"Email already exists!" message:@"Please fill your existing email-id "];
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:3]]) {
	            [CommonFunction fnAlert:@"Alert!" message:@"Unable to upload image, please choose another valid profile image"];
			}
	        else
				[CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];

	        [kAppDelegate hideProgressHUD];
		}                          errorBlock: ^(NSError *error) {
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

#pragma mark- Initial Settings
- (void)setInitialVaribles
{
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
	if ([strEditProfile isEqualToString:@"Edit"])
    {
		[self setEditProfileTextValues];
		self.lblTop.text = @"EDIT PROFILE™";
		[self.btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
		NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
		if ([userCompleteIncomplete isEqualToString:@"1"]) {
			_btnBack.hidden = NO;
		}
		else {
			_btnBack.hidden = YES;
		}
		if ([strDetailRegistration isEqualToString:@"DetailRegistration"]) {
			self.lblTop.text = @"REGISTER™";
			[self.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];

		}

        if(isNewUser==YES)
        {
            mEmailAddressTextField.userInteractionEnabled = YES;
        }
        else{
            mEmailAddressTextField.userInteractionEnabled = NO;
        }
		
		_mConfirmEmail.userInteractionEnabled = NO;
		_mPassword.hidden = TRUE;
		_mConfirmPassword.hidden = TRUE;
		_lblPassword.hidden = TRUE;
		_lblConfirmPwd.hidden = TRUE;
		//Jasmeet changes
		self.lblZipCode.frame = CGRectMake(self.lblEmail.frame.origin.x, self.lblEmail.frame.origin.y, self.lblZipCode.frame.size.width, self.self.lblZipCode.frame.size.height);
		self.txtZipCode.frame = self.mEmailAddressTextField.frame;
		self.lblEmail.frame = self.lblPassword.frame;
		self.mEmailAddressTextField.frame = self.mPassword.frame;
		mPhoneNumberTextField.frame = _mConfirmPassword.frame;
		_lblPhoneNumber.frame = _lblConfirmPwd.frame;
//		[self.mScrollView addSubview:self.lblZipCode];
		[self.mScrollView addSubview:self.txtZipCode];
		[self.mScrollView sendSubviewToBack:self.txtZipCode];
//		self.mState.enabled = FALSE;
//		self.mCity.enabled = TRUE;

//            self.mState.text = [CommonFunction getValueFromUserDefault:@"SelectedState"];
//            self.mCity.text = [CommonFunction getValueFromUserDefault:@"SelectedCity"];
//            NSLog(@"staet id is %@",[CommonFunction getValueFromUserDefault:@"SelectedStateID"]);
//            mSelectedStateId = [[CommonFunction getValueFromUserDefault:@"SelectedStateID"]  integerValue];
//            mSelectedCityID = [[CommonFunction getValueFromUserDefault:@"SelectedCityID"] integerValue];
//            [CommonFunction deleteValueForKeyFromUserDefault:@"SelectedState"];
//            [CommonFunction deleteValueForKeyFromUserDefault:@"SelectedCity"];
//            [CommonFunction deleteValueForKeyFromUserDefault:@"SelectedStateID"];
//            [CommonFunction deleteValueForKeyFromUserDefault:@"SelectedCityID"];
	}
	else if ([strEditProfile isEqualToString:@"RegisteredNotPaid"])
    {
		[self setEditProfileTextValues];
		self.lblTop.text = @"REGISTER™";
		[self.btnSubmit setTitle:@"Next" forState:UIControlStateNormal];
		for (UIView *view in self.mScrollView.subviews) {
			if ([view isKindOfClass:[UITextField class]]) {
				UITextField *textField = (UITextField *)view;
				textField.userInteractionEnabled = NO;
			}
		}
		_btnUploadPhoto.userInteractionEnabled = NO;
		mAddressTextField.userInteractionEnabled = YES;
		_mPassword.hidden = TRUE;
		_mConfirmPassword.hidden = TRUE;
		_lblPassword.hidden = TRUE;
		_lblConfirmPwd.hidden = TRUE;
		mPhoneNumberTextField.frame = _mPassword.frame;
		_lblPhoneNumber.frame = _lblPassword.frame;
		_btnBack.hidden = YES;
	}
	else if ([strEditProfile isEqualToString:@"RegisterSuccess"])
    {
		[self.btnSubmit setTitle:@"Next" forState:UIControlStateNormal];
		for (UIView *view in self.mScrollView.subviews) {
			if ([view isKindOfClass:[UITextField class]]) {
				UITextField *textField = (UITextField *)view;
				textField.userInteractionEnabled = NO;
			}
		}
        NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:kAppDelegate.dictUserInfo];
        [[NSUserDefaults standardUserDefaults] setObject:newdata forKey:kdictUserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
		_btnUploadPhoto.userInteractionEnabled = NO;
		mAddressTextField.userInteractionEnabled = YES;
	}
	else
    {

		[self.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
		self.lblTop.text = @"REGISTER™";
		mSelectedStateId = -1;
		mSelectedCityID = -1;
		selectedMonth = -1;
		mEmailAddressTextField.userInteractionEnabled = YES;
	}
	if ([[CommonFunction getValueFromUserDefault:@"isRemptionCode"] isEqualToString:@"yes"]) {
		mAddressTextField.userInteractionEnabled = YES;
	}
	else {
		mAddressTextField.userInteractionEnabled = YES;
	}

	for (UIView *view in self.mScrollView.subviews) {
		if ([view isKindOfClass:[UILabel class]]) {
			UILabel *label = (UILabel *)view;
			if (label.tag != 123 && label.tag!=1001) {
				label.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
				[label highlightTextInLabel:@"*"];
			}
		}
	}
	self.lblTop.font = [UIFont fontWithName:kFont size:_lblTop.font.pointSize];
	self.btnSubmit.titleLabel.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
	self.btnTapLogin.titleLabel.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
	self.btnUploadPhoto.titleLabel.font = [UIFont fontWithName:kFont size:14];
//	self.mAddressTextField.layer.borderColor = [[UIColor lightTextColor]CGColor];
//	self.mAddressTextField.layer.borderWidth = 2.0;
//	self.mAddressTextField.layer.cornerRadius = 5.0;
	self.imgViewProfile.layer.borderColor = [[UIColor lightTextColor]CGColor];
	self.imgViewProfile.layer.borderWidth = 2.0;
	self.imgViewProfile.layer.cornerRadius = 5.0;
	self.imgViewProfile.layer.masksToBounds = YES;

	mDictStates = [[NSMutableArray alloc]init];
	mDictCities = [[NSMutableArray alloc]init];
	mCity.adjustsFontSizeToFitWidth = YES;
	mState.adjustsFontSizeToFitWidth = YES;
    if ([strSalespersonCode length] > 0 || [strStudentCode length]>0) {
        self.btnTapLogin.hidden = NO;
    }
	[self fetchStatePlistData];
}

- (void)setEditProfileTextValues {
	[kAppDelegate showProgressHUD:self.view];
	// dictProfileData = kAppDelegate.dictUserInfo;
	if ([[CommonFunction getValueFromUserDefault:@"userName"] length] > 0) {
		mFirstNameTextField.text = [CommonFunction getValueFromUserDefault:@"userName"];
	}
	else {
		mFirstNameTextField.text = [dictProfileData valueForKey:@"name"];
	}
	if ([[CommonFunction getValueFromUserDefault:@"address"] length] > 0) {
		self.mAddressTextField.text = [CommonFunction getValueFromUserDefault:@"address"];
	}
	else {
		self.mAddressTextField.text = [dictProfileData valueForKey:@"address"];
	}

    if ([[CommonFunction getValueFromUserDefault:@"last_name"] length] > 0) {
        self.mLastNameTextField.text = [CommonFunction getValueFromUserDefault:@"last_name"];
    }
    else {
        self.mLastNameTextField.text = [dictProfileData valueForKey:@"last_name"];
    }

//	mLastNameTextField.text = [dictProfileData valueForKey:@"last_name"];
	_mMonth.text = [dictProfileData valueForKey:@"dobMonthName"];
    if ([[dictProfileData valueForKey:@"dobDay"] isEqualToString:@"00"]) {
        _mDate.text = @"";
    }
    else
    {
	_mDate.text = [dictProfileData valueForKey:@"dobDay"];
    }
	mAgeGroupTextField.text = [self setAgeGroupID:[dictProfileData valueForKey:@"ageGroup"]];
//        mAddressTextField.text=[dictProfileData valueForKey:@"address"];
	mState.text = [dictProfileData valueForKey:@"state"];
	mCity.text = [dictProfileData valueForKey:@"city"];
	self.txtZipCode.text = [dictProfileData valueForKey:@"zipcode"];
	mEmailAddressTextField.text = [dictProfileData valueForKey:@"email"];
	_mConfirmEmail.text = [dictProfileData valueForKey:@"email"];
	mPhoneNumberTextField.text = [dictProfileData valueForKey:@"phone_no"];
	if ([[CommonFunction getValueFromUserDefault:@"zipCode"] length] > 0) {
		self.txtZipCode.text = [CommonFunction getValueFromUserDefault:@"zipCode"];
		self.mState.enabled = TRUE;
		self.mCity.enabled = TRUE;
		self.mState.text = [CommonFunction getValueFromUserDefault:@"SelectedState"];
		self.mCity.text = [CommonFunction getValueFromUserDefault:@"SelectedCity"];
         selectedState=[CommonFunction getValueFromUserDefault:@"SelectedState"];
		NSLog(@"state id is %@", [CommonFunction getValueFromUserDefault:@"SelectedStateID"]);
	}
	if ([[dictProfileData valueForKey:@"stateId"] length] <= 0) {
		mSelectedStateId = [[CommonFunction getValueFromUserDefault:@"SelectedStateID"]  integerValue];
		mSelectedCityID = [[CommonFunction getValueFromUserDefault:@"SelectedCityID"] integerValue];
	}
	else {
		mSelectedStateId = [[dictProfileData valueForKey:@"stateId"]intValue];
		mSelectedCityID = [[dictProfileData valueForKey:@"cityId"]intValue];
		mState.text = [dictProfileData valueForKey:@"state"];
		mCity.text = [dictProfileData valueForKey:@"city"];

		self.mState.enabled = TRUE;
		self.mCity.enabled = TRUE;
	}

	if ([[CommonFunction getValueFromUserDefault:@"isRemptionCode"] isEqualToString:@"yes"]) {
		self.mState.text = @"";
		self.mCity.text = @"";
		mSelectedStateId = -1;
		mSelectedCityID = -1;
		mFirstNameTextField.text = @"";
		self.mAddressTextField.text = @"";
		self.txtZipCode.text = @"";
		mAddressTextField.userInteractionEnabled = YES;
		self.mState.enabled = TRUE;
		self.mCity.enabled = TRUE;
	}

    if([[dictProfileData valueForKey:@"email"] length]<=0)
    {
        mEmailAddressTextField.text=[CommonFunction getValueFromUserDefault:@"EmailId"];
    }
        
            
	[kAppDelegate showProgressHUD:self.view];
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
	    [self fetchCityPlistData:FALSE];
	});

	selectedAgeGroup = [dictProfileData valueForKey:@"ageGroup"];
	selectedMonth = [[dictProfileData valueForKey:@"dobMonth"]intValue];
	if ([[dictProfileData valueForKey:@"profileImage"] length] > 0) {
		[self.imgViewProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dictProfileData valueForKey:@"profileImage"]]]
		                    placeholderImage:[UIImage imageNamed:@"user_placeHolder.png"]];
		[self strDataFromImage:self.imgViewProfile.image];
        self.btnUploadPhoto.userInteractionEnabled=NO;

        selectedState = [dictProfileData valueForKey:@"state"];

//		dispatch_async(dispatch_get_global_queue(0, 0), ^{
//		    [self fetchCityPlistData:FALSE];
//		});
	}
//	[kAppDelegate hideProgressHUD];
}

- (void)setRegistrationVariables:(NSDictionary *)result
{
    if(_btnUploadPhoto.userInteractionEnabled==TRUE)
    {
        firstTimeRegister=TRUE;
    }
    else
    {
        firstTimeRegister=FALSE;
    }
    
	kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
    NSLog(@"%@",kAppDelegate.dictUserInfo);
	[CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
	[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
	self.strEditProfile = @"RegisterSuccess";
	[self setInitialVaribles];
	[CommonFunction setValueInUserDefault:kEmailId value:@""];
	[CommonFunction setValueInUserDefault:kPassword value:@""];
	[CommonFunction setValueInUserDefault:kRememberMe value:@"NO"];
}

- (void)setUpdateProfileValues:(NSDictionary *)result {
	if ([[CommonFunction getValueFromUserDefault:kZipCodeHighlighted]isEqualToString:@"False"]) {
		[CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
	}
	kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
	dictProfileData = [NSMutableDictionary dictionaryWithDictionary:result];
	[CommonFunction deleteValueForKeyFromUserDefault:@"userName"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"SelectedState"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"SelectedCity"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"SelectedStateID"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"SelectedCityID"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"zipCode"];
	[CommonFunction deleteValueForKeyFromUserDefault:@"address"];
}

- (NSInteger)findDaysInMonth:(NSString *)monthNum {
	NSInteger days = 30;

	NSString *selectedmonth = monthNum;
	int item = [arrMonth indexOfObject:selectedmonth] + 1;
	switch (item) {
		case 1:
			days = 31;
			break;

		case 2:
			days = 29;
			break;

		case 3:
			days = 31;
			break;

		case 4:
			days = 30;
			break;

		case 5:
			days = 31;
			break;

		case 6:
			days = 30;
			break;

		case 7:
			days = 31;
			break;

		case 8:
			days = 31;
			break;

		case 9:
			days = 30;
			break;

		case 10:
			days = 31;
			break;

		case 11:
			days = 30;
			break;

		case 12:
			days = 31;
			break;

		default:
			break;
	}
	return days;
}

#pragma mark - Age Group Methods

- (NSString *)setAgeGroupID:(NSString *)dictAgeGroupValue {
	NSString *strAgeGroup;
	if ([dictAgeGroupValue isEqualToString:@"1"]) {
		strAgeGroup = @"0-18 years";
	}
	else if ([dictAgeGroupValue isEqualToString:@"2"]) {
		strAgeGroup = @"19-39 years";
	}
	else if ([dictAgeGroupValue isEqualToString:@"3"]) {
		strAgeGroup = @"40-55 years";
	}
	else if ([dictAgeGroupValue isEqualToString:@"4"]) {
		strAgeGroup = @"55-over years";
	}
	return strAgeGroup;
}

- (void)strDataFromImage:(UIImage *)image {
	UIImage *editedImage = [self resizeImage:image width:100 height:100];
	NSData *data = UIImageJPEGRepresentation(editedImage, 1.0f);
	[Base64 initialize];
	self.strData = [NSString stringWithFormat:@"%@", [Base64 encode:data]];
}

- (NSDate *)setAgeGroup {
	NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
	if ([mAgeGroupTextField.text isEqualToString:@"0-18 years"]) {
		[dateComponents setYear:-9];
		selectedAgeGroup = @"1";
	}
	else if ([mAgeGroupTextField.text isEqualToString:@"19-39 years"]) {
		[dateComponents setYear:-29];
		selectedAgeGroup = @"2";
	}
	else if ([mAgeGroupTextField.text isEqualToString:@"40-55 years"]) {
		[dateComponents setYear:-47];
		selectedAgeGroup = @"3";
	}
	else if ([mAgeGroupTextField.text isEqualToString:@"55-over years"]) {
		[dateComponents setYear:-62];
		selectedAgeGroup = @"4";
	}
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
	return newDate;
}

#pragma mark- get plist data

- (void)fetchStatePlistData {
	//Adding values form State plist into State array
	NSString *statePath = [[NSBundle mainBundle] pathForResource:@"states1" ofType:@"plist"];
	NSMutableArray *arrState = [[NSMutableArray alloc] initWithContentsOfFile:statePath];
	for (int stateCounter = 0; stateCounter < [arrState count]; stateCounter++) {
		[mDictStates addObject:[arrState objectAtIndex:stateCounter]];
	}
}
-(void)getFundraisingLink
{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:mEmailAddressTextField.text forKey:@"email"];
        
        [kAppDelegate showProgressHUD];
        
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:ksendEmailRaisefunds] completeBlock: ^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            
            [kAppDelegate.objSideBarVC showView];

            kAppDelegate.objSideBarVC.lastbtnClicked =  kAppDelegate.objSideBarVC.btnProfile;
            IBDashboardVC *objIBDashboardVC;
            if (kDevice == kIphone) {
                objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
            }
            else {
                objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
            }
            
            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBDashboardVC] animated:NO];

           // [[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
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
//            objIBRegisterVC.dictProfileData=userDetailDict;
//            
//            
//            [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
            
            
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
//Fetching State's data from Plist
- (void)fetchCityPlistData:(BOOL)becomeResponder {
	[mDictCities removeAllObjects];

	NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
	NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
	NSMutableArray *arrUnsortedArray = [[NSMutableArray alloc] init];
    NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"StateID = %@", [NSString stringWithFormat:@"%d", mSelectedStateId]];

    [arrUnsortedArray addObjectsFromArray:[arrCity filteredArrayUsingPredicate:cityPredicate]];
    
//	for (int stateCounter = 0; stateCounter < [arrCity count]; stateCounter++) {
//		if ([[[arrCity objectAtIndex:stateCounter] valueForKey:@"StateID"] isEqualToString:[NSString stringWithFormat:@"%d", mSelectedStateId]]) {
//			[arrUnsortedArray addObject:[arrCity objectAtIndex:stateCounter]];
//		}
//	}
	NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"City_Alias" ascending:YES];
	NSArray *sortDescriptors  = [NSArray arrayWithObject:brandDescriptor];
	if ([[CommonFunction getValueFromUserDefault:@"zipCode"] length] > 0) {
		NSPredicate *zipcodePredicate = [NSPredicate predicateWithFormat:@"ZipCode = %d", [CommonFunction getValueFromUserDefault:@"zipCode"]];
		NSLog(@"city: %@", [arrCity filteredArrayUsingPredicate:zipcodePredicate]);
		[mDictCities addObjectsFromArray:[arrUnsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
	}
	else {
		[mDictCities addObjectsFromArray:[arrUnsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
	    [kAppDelegate hideProgressHUD];
	    if (becomeResponder == TRUE) {
	        [mCity becomeFirstResponder];
		}
	});
}

- (void)filterCityArrayForText:(NSString *)textEntered {
	NSString *stringToSearch = @"";
	if (mCity.text.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:mCity.text];
	}
	if (textEntered.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:textEntered];
	}
	else
		stringToSearch = [stringToSearch substringToIndex:stringToSearch.length - 1];
//    if ([[CommonFunction getValueFromUserDefault:@"zipCode"] length]>0)
//    {
//        NSLog(@"Zip code: %@",[CommonFunction getValueFromUserDefault:@"zipCode"]);
//        NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
//        NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
//        NSPredicate *zipcodePredicate = [NSPredicate predicateWithFormat:@"ZipCode matches[cd] %@",  [CommonFunction getValueFromUserDefault:@"zipCode"]];
//        NSLog(@"city: %@", [arrCity filteredArrayUsingPredicate:zipcodePredicate]);
//
//    }

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"City_Alias BEGINSWITH[cd] %@", stringToSearch];
	NSArray *arrayFileterd = [mDictCities filteredArrayUsingPredicate:predicate];
	NSUInteger count11 = arrayFileterd.count;
	if (count11 > 1000) count11 = 1000;
	cityFilteredAray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];

	[citiesList reloadData];
}

- (void)filterStateArrayForText:(NSString *)textEntered {
	NSString *stringToSearch = @"";
	if (mState.text.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:mState.text];
	}
	if (textEntered.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:textEntered];
	}
	else
		stringToSearch = [stringToSearch substringToIndex:stringToSearch.length - 1];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[cd] %@", stringToSearch];
	NSArray *arrayFileterd = [mDictStates filteredArrayUsingPredicate:predicate];
	NSUInteger count11 = arrayFileterd.count;
	if (count11 > 1000) count11 = 1000;
	stateFilteredArray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];
	if ([stateFilteredArray count] == 0) {
		mSelectedStateId = -1;
	}
	[stateList reloadData];
}

#pragma mark -  Validation methods

- (BOOL)isAlpha:(NSString *)string {
	NSCharacterSet *alphaNumeric = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "];
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


#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//#warning Potentially incomplete method implementation.
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//#warning Incomplete method implementation.
	// Return the number of rows in the section.

	if ([strStateCityTableType isEqualToString:@"State"]) {
		//[self setStateTableHeight:stateFilteredArray.count];
		return stateFilteredArray.count;
	}
	else {
		//[self setCityTableHeight:cityFilteredAray.count];
		return cityFilteredAray.count;
	}
}

/**
   Method to set state table height*/
- (void)setStateTableHeight:(int)count {
	if (kDevice == kIphone) {
		if (count < 4) {
			stateList.frame = CGRectMake(stateList.frame.origin.x, stateList.frame.origin.y, stateList.frame.size.width, count * 50);
		}
		else {
			stateList.frame = CGRectMake(stateList.frame.origin.x, stateList.frame.origin.y, stateList.frame.size.width, kiPhoneTableHeight);
		}
	}
	else {
		if (count < 6) {
			stateList.frame = CGRectMake(stateList.frame.origin.x, stateList.frame.origin.y, stateList.frame.size.width, count * 50);
		}
		else {
			stateList.frame = CGRectMake(stateList.frame.origin.x, stateList.frame.origin.y, stateList.frame.size.width, kiPadTableHeight);
		}
	}
}

/**
   Method to set city table height*/

- (void)setCityTableHeight:(int)count {
	if (kDevice == kIphone) {
		if (count < 4) {
			citiesList.frame = CGRectMake(citiesList.frame.origin.x, citiesList.frame.origin.y, citiesList.frame.size.width, count * 50);
		}
		else {
			citiesList.frame = CGRectMake(citiesList.frame.origin.x, citiesList.frame.origin.y, citiesList.frame.size.width, kiPhoneTableHeight);
		}
	}
	else {
		if (count < 6) {
			citiesList.frame = CGRectMake(citiesList.frame.origin.x, citiesList.frame.origin.y, citiesList.frame.size.width, count * 50);
		}
		else {
			citiesList.frame = CGRectMake(citiesList.frame.origin.x, citiesList.frame.origin.y, citiesList.frame.size.width, kiPadTableHeight);
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([strStateCityTableType isEqualToString:@"State"]) {
		static NSString *CellIdentifier = @"StateList";

		// UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		if (stateFilteredArray.count > 0) {
			UILabel *lblStateName = [[UILabel alloc]init];
			lblStateName.frame = CGRectMake(2, 3, tableView.frame.size.width, 30);
			lblStateName.tag = 101;
			lblStateName.text = [[stateFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
            if (kDevice == kIphone) {

                lblStateName.font = [UIFont fontWithName:kFont size:kFontText];
            }
            else
            {
                lblStateName.font = [UIFont fontWithName:kFont size:18];

            }
			lblStateName.adjustsFontSizeToFitWidth = TRUE;
			[cell.contentView addSubview:lblStateName];
		}
		else {
			UILabel *lblStateName = (UILabel *)[cell viewWithTag:101];
			lblStateName.text = [[stateFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
			lblStateName.textColor = [UIColor blackColor];
			lblStateName.adjustsFontSizeToFitWidth = TRUE;

            if (kDevice == kIphone) {
                
                lblStateName.font = [UIFont fontWithName:kFont size:kFontText];
            }
            else
            {
                lblStateName.font = [UIFont fontWithName:kFont size:18];
                
            }
		}
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"CityList";

		//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		if (cityFilteredAray.count > 0) {
			UILabel *lblCityName = [[UILabel alloc]init];
			lblCityName.frame = CGRectMake(2, 3, tableView.frame.size.width, 30);
			lblCityName.tag = 101;
			lblCityName.text = [NSString stringWithFormat:@"%@,%@", [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row], selectedState];
			lblCityName.font = [UIFont fontWithName:kFont size:kFontText];
			lblCityName.adjustsFontSizeToFitWidth = TRUE;
			[cell.contentView addSubview:lblCityName];

			UILabel *lblZipCode = [[UILabel alloc]init];
			lblZipCode.frame = CGRectMake(2, 20, tableView.frame.size.width, 30);
			lblZipCode.backgroundColor = [UIColor clearColor];
			lblZipCode.textColor = [UIColor blackColor];

			lblZipCode.tag = 102;
			lblZipCode.adjustsFontSizeToFitWidth = TRUE;
			lblZipCode.text = [NSString stringWithFormat:@"Zip Code:- %@", [[cityFilteredAray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
			lblZipCode.font = [UIFont fontWithName:kFont size:kFontText];

			[cell.contentView addSubview:lblZipCode];
		}
		else {
			UILabel *lblCityName = (UILabel *)[cell viewWithTag:101];
			lblCityName.text = [NSString stringWithFormat:@"%@,%@", [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row], selectedState];
			lblCityName.textColor = [UIColor blackColor];
			lblCityName.adjustsFontSizeToFitWidth = TRUE;

			lblCityName.font = [UIFont fontWithName:kFont size:kFontText];

			UILabel *lblZipCode = (UILabel *)[cell viewWithTag:102];
			lblZipCode.text = [NSString stringWithFormat:@"Zip Code:- %@", [[cityFilteredAray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
			lblZipCode.textColor = [UIColor blackColor];
			lblZipCode.adjustsFontSizeToFitWidth = TRUE;

			lblZipCode.font = [UIFont fontWithName:kFont size:kFontText];
		}
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([strStateCityTableType isEqualToString:@"State"]) {
		mState.text = [[stateFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
		mSelectedStateId = [[[stateFilteredArray valueForKey:@"StateID"] objectAtIndex:indexPath.row]intValue];
		selectedState = [[stateFilteredArray valueForKey:@"ShortName"] objectAtIndex:indexPath.row];
		mCity.text = @"";
		mSelectedCityID = -1;
		[kAppDelegate showProgressHUD:self.view];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		    [self fetchCityPlistData:TRUE];
		});
		[mState resignFirstResponder];
		_keyboardControls.showSegment = YES;
	}
	else {
		NSString *strCity = [NSString stringWithFormat:@"%@", [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row]];
		mCity.text = strCity;
		self.txtZipCode.text = [[cityFilteredAray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row];
		mSelectedCityID = [[[cityFilteredAray valueForKey:@"CityID"] objectAtIndex:indexPath.row] intValue];
		[mCity resignFirstResponder];
		[mEmailAddressTextField becomeFirstResponder];
		_keyboardControls.showSegment = YES;
	}
	// [self removeScrollAnimation];
	tableView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kDevice == kIphone) {
        return 50.0f;

    }
    else
    {
        return 80.0f;

        
    }
}

#pragma mark - ImagePickerController Delegate methods

//Delegate method of imagePickerController
- (void)imagePickerController:(UIImagePickerController *)Imagepicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	if (![strEditProfile isEqualToString:@"Edit"]) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"showSideControls"
		                                                   object:self];
	}
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

	//not production code,  do not use hard coded string in real app
	if ([mediaType isEqualToString:@"public.image"]) {
		UIImage *imagePhoto = [info objectForKey:UIImagePickerControllerEditedImage];
		Imagepicker.delegate = nil;
		UIImage *editedImage = [self resizeImage:imagePhoto width:100 height:100];
		NSData *data = UIImageJPEGRepresentation(editedImage, 1.0f);
		[Base64 initialize];
		self.strData = [NSString stringWithFormat:@"%@", [Base64 encode:data]];
		self.imgViewProfile.image = imagePhoto;
		[Imagepicker dismissViewControllerAnimated:YES completion:nil];
		[popOverController dismissPopoverAnimated:NO];
	}
	//not production code,  do not use hard coded string in real app
	else if ([mediaType isEqualToString:@"public.movie"]) {
		[Imagepicker dismissViewControllerAnimated:YES completion:nil];
		[popOverController dismissPopoverAnimated:NO];
		[CommonFunction fnAlert:@"Alert" message:@"Use a photo to upload,don't use video to upload"];
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (UIImage *)resizeImage:(UIImage *)oldImage width:(float)imageWidth height:(float)imageHeight {
	UIImage *newImage = oldImage;
	CGSize itemSize = CGSizeMake(imageWidth, imageHeight);
	UIGraphicsBeginImageContext(itemSize);
	CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
	[oldImage drawInRect:imageRect];
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//Delegate method to dismiss the image picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	if (kDevice == kIphone) {
		//      //  [[NSNotificationCenter defaultCenter]postNotificationName:@"AddAdsView"
		//                                                           object:self];
	}
	[picker dismissViewControllerAnimated:NO completion:nil];
	[popOverController dismissPopoverAnimated:NO];
	if (![strEditProfile isEqualToString:@"Edit"]) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"showSideControls"
		                                                   object:self];
	}
}

#pragma mark - Actionsheet delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[tempTextField resignFirstResponder];
	[self dismissKeypad];
	if (buttonIndex == 1) {
		[self clickPhotoActionsheetchooseFrmGallery];
	}
	else if (buttonIndex == 2) {
		[self clickPhotoActionsheetCapturePhotoAction];
	}
}

//Choose from gallery button clicked of  action sheet
- (void)clickPhotoActionsheetchooseFrmGallery {
	//Showing the photo gallery of the iPhone
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	imagePickerController.wantsFullScreenLayout = NO;
	NSArray *media = [UIImagePickerController availableMediaTypesForSourceType:
	                  UIImagePickerControllerSourceTypeCamera];
	if ([media count] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePickerController.mediaTypes = media;
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	else {
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	if (kDevice == kIphone) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"hideSideControls"
		                                                   object:self];
		[self presentViewController:imagePickerController animated:NO completion:nil];
	}
	else {
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
		[popover presentPopoverFromRect:CGRectMake(self.btnUploadPhoto.frame.origin.x + self.btnUploadPhoto.frame.size.width, self.btnUploadPhoto.frame.origin.y + _imgViewProfile.frame.size.height, self.btnUploadPhoto.frame.size.width, self.btnUploadPhoto.frame.size.height)
		                         inView:self.view
		       permittedArrowDirections:UIPopoverArrowDirectionUp
		                       animated:YES];
		[[UIApplication sharedApplication]setStatusBarHidden:TRUE];

		self.popOverController = popover;
		[[NSNotificationCenter defaultCenter]postNotificationName:@"hideSideControls"
		                                                   object:self];
	}
}

//Capture photo button clicked of action sheet
- (void)clickPhotoActionsheetCapturePhotoAction {
	//Opening the camera for capturing photo
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	imagePickerController.wantsFullScreenLayout = NO;

	NSArray *media = [UIImagePickerController availableMediaTypesForSourceType:
	                  UIImagePickerControllerSourceTypeCamera];
	if ([media count] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"hideSideControls"
		                                                   object:self];
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		imagePickerController.mediaTypes = media;
		imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
		imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
		imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
		[self presentViewController:imagePickerController animated:NO completion:nil];
	}
	else {
		[CommonFunction fnAlert:@"Alert" message:@"No Camera found on your Device."];
		return;
	}
}

#pragma mark - CUSTOM TEXTFIELD DELEGATES
- (void)customFormKeyboardControlsDonePressed:(BSKeyboardControls *)controls {
	if (controls.activeTextField == mState) {
		stateList.hidden = TRUE;
		mState.text = @"";
		citiesList.hidden = TRUE;
		mCity.text = @"";
	}
	if (controls.activeTextField == mCity) {
		citiesList.hidden = TRUE;
		mCity.text = @"";
		stateList.hidden = TRUE;
		mState.text = @"";
	}
}

- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField {
	tempTextField = textField;
	if (![strEditProfile isEqualToString:@"Edit"]) {
		[CommonFunction callHideViewFromSideBar];
	}

	if (textField == _mMonth) {
		if (kDevice == kIphone) {
			[self addScrollAnimationWithFrame:textField.frame];
			_mDate.text = @"";
			[self dismissKeypad];
			CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
			customPicker.arrPicker = arrMonth;

			[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
			    textField.text = text;
			    selectedMonth = row + 1;
			} OnHiding: ^(int direction) {
			    if (direction == DirectionNext) {
			        [_mDate becomeFirstResponder];
				}
			    if (direction == DirectionPrevious) {
			        [mLastNameTextField becomeFirstResponder];
				}
			    if (direction == DirectionDone) {
			        [self removeScrollAnimation:_mMonth.frame];
				}
			} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
			return NO;
		}
		else {
			[self dismissKeypad];
			CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
			if (popView) {
				if (popView.popoverVisible)
					[popView dismissPopoverAnimated:YES];

				popView = nil;
			}
			popView = [[UIPopoverController alloc] initWithContentViewController:customPicker];
			[popView setContentViewController:customPicker];
			[popView setDelegate:self];
			popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height + customPicker.toolBar.frame.size.height);
			[popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height, 10, 10)
			                         inView:self.mScrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
			customPicker.arrPicker = arrMonth;

			[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
			    textField.text = text;
			    selectedMonth = row + 1;
			} OnHiding: ^(int direction) {
			    [popView dismissPopoverAnimated:YES];
			    if (direction == DirectionNext) {
			        [_mDate becomeFirstResponder];
				}
			    if (direction == DirectionPrevious) {
			        [mLastNameTextField becomeFirstResponder];
				}
			    if (direction == DirectionDone) {
			        [self removeScrollAnimation:_mMonth.frame];
				}
			} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
			return NO;
		}
	}

	if (textField == _mDate) {
		if (kDevice == kIphone) {
			[self addScrollAnimationWithFrame:textField.frame];
			[self dismissKeypad];
			CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
			arrDate = [[NSMutableArray alloc] init];
			if ([_mMonth.text length] <= 0) {
				[CommonFunction fnAlert:@"Alert!" message:@"Please select the month first."];
				[self dismissKeypad];
				return NO;
			}
			else {
				NSInteger days = [self findDaysInMonth:_mMonth.text];

				for (int i = 1; i <= days; i++) {
					[arrDate addObject:[[NSString alloc] initWithFormat:@"%02d", i]];
				}
				customPicker.arrPicker = arrDate;

				[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
				    textField.text = text;
				} OnHiding: ^(int direction) {
				    if (direction == DirectionNext) {
				        [mAgeGroupTextField becomeFirstResponder];
					}
				    if (direction == DirectionPrevious) {
				        [_mMonth becomeFirstResponder];
					}
				    if (direction == DirectionDone) {
				        [self removeScrollAnimation:_mDate.frame];
					}
				} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
				return NO;
			}
		}
		else {
			[self dismissKeypad];

			CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
            arrDate = [[NSMutableArray alloc] init];
			if ([_mMonth.text length] <= 0) {
				[CommonFunction fnAlert:@"Alert!" message:@"Please select the month first."];
				[self dismissKeypad];
				return NO;
			}
			else {
				NSInteger days = [self findDaysInMonth:_mMonth.text];
                
				for (int i = 1; i <= days; i++) {
					[arrDate addObject:[[NSString alloc] initWithFormat:@"%02d", i]];
				}

			if (popView) {
				if (popView.popoverVisible)
					[popView dismissPopoverAnimated:YES];
				popView = nil;
			}
			popView = [[UIPopoverController alloc] initWithContentViewController:customPicker];
			[popView setDelegate:self];
			popView.popoverContentSize =  popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height + customPicker.toolBar.frame.size.height);
			[popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height, 10, 10)
			                         inView:self.mScrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
			customPicker.arrPicker = arrDate;
			[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
			    textField.text = text;
			} OnHiding: ^(int direction) {
			    [popView dismissPopoverAnimated:YES];
			    if (direction == DirectionNext) {
			        [mAgeGroupTextField becomeFirstResponder];
				}
			    if (direction == DirectionPrevious) {
			        [_mMonth becomeFirstResponder];
				}
			    if (direction == DirectionDone) {
			        [self removeScrollAnimation:_mDate.frame];
				}
			} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
			return NO;
		}
	}
    }

	if (kDevice != kIphone && textField == self.mAgeGroupTextField) {
		[self dismissKeypad];

		CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
		if (popView) {
			if (popView.popoverVisible)
				[popView dismissPopoverAnimated:YES];
			popView = nil;
		}
		popView = [[UIPopoverController alloc] initWithContentViewController:customPicker];
		[popView setDelegate:self];
		popView.popoverContentSize =  popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height + customPicker.toolBar.frame.size.height);
		[popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height, 10, 10)
		                         inView:self.mScrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		customPicker.arrPicker = [NSMutableArray arrayWithArray:@[@"0-18 years", @"19-39 years", @"40-55 years", @"55-over years"]];

		[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
		    textField.text = text;
		    [self setAgeGroup];
		} OnHiding: ^(int direction) {
		    [popView dismissPopoverAnimated:YES];
		    if (direction == DirectionNext) {
		        [mAddressTextField becomeFirstResponder];
			}
		    if (direction == DirectionPrevious) {
		        [_mDate becomeFirstResponder];
			}
		    if (direction == DirectionDone) {
		        [self removeScrollAnimation:self.mAgeGroupTextField.frame];
			}
		} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
		return NO;
	}
	if (kDevice == kIphone && textField == self.mAgeGroupTextField) {
		[self addScrollAnimationWithFrame:textField.frame];
		[self dismissKeypad];
		CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
		customPicker.arrPicker = [NSMutableArray arrayWithArray:@[@"0-18 years", @"19-39 years", @"40-55 years", @"55-over years"]];
		[customPicker showPickerOnCompletion: ^(NSString *text, int row) {
		    textField.text = text;
		    [self setAgeGroup];
		} OnHiding: ^(int direction) {
		    if (direction == DirectionNext) {
		        [mAddressTextField becomeFirstResponder];
			}
		    if (direction == DirectionPrevious) {
		        [_mDate becomeFirstResponder];
			}
		    if (direction == DirectionDone) {
		        [self removeScrollAnimation:self.mAgeGroupTextField.frame];
			}
		} selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
		return NO;
	}
	if (textField == mState) {
		citiesList.hidden = YES;
		mCity.text = @"";
		mState.text = @"";
		self.txtZipCode.text = @"";
		strStateCityTableType = @"State";
		_keyboardControls.showSegment = NO;
	}
	if (textField == mCity) {
		if (mSelectedStateId > 0 || mState.text.length > 0) {
			mCity.text = @"";
			strStateCityTableType = @"City";
			_keyboardControls.showSegment = NO;
		}
		else {
			mState.text = @"";
			mCity.text = @"";
			self.txtZipCode.text = @"";
			citiesList.hidden = YES;
			stateList.hidden = YES;

			[CommonFunction fnAlert:@"Alert!" message:@"Please select valid state so that the cities of a selected state will be displayed"];
			return NO;
		}
		if (mCity.text.length) {
		}
	}
	if (textField == mEmailAddressTextField || textField == self.mConfirmEmail || textField == self.mPassword || textField == self.mConfirmPassword || textField == self.mPhoneNumberTextField) {
		_keyboardControls.showSegment = YES;
	}
	return YES;
}

- (void)customTextFieldDidChangePickerValue:(UITextField *)textField index:(int)index {
	if (textField == mState) {
		mSelectedStateId = [[[mDictStates valueForKey:@"StateID"] objectAtIndex:index]intValue];
		selectedState = [[mDictStates valueForKey:@"ShortName"] objectAtIndex:index];
		[kAppDelegate showProgressHUD:self.view];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		    [self fetchCityPlistData:TRUE];
		});
	}
	else if (textField == mCity) {
		mSelectedCityID = [[[mDictCities valueForKey:@"CityID"] objectAtIndex:index]intValue];
	}
}

- (BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered {
	if (textField == self.mPhoneNumberTextField) {
		NSCharacterSet *NUMBERS = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
		for (int i = 0; i < [textEntered length]; i++) {
			unichar d = [textEntered characterAtIndex:i];
			if (![NUMBERS characterIsMember:d]) {
				UIAlertView *alertIntCheck = [[UIAlertView alloc]initWithTitle:@"Please enter numbers only." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertIntCheck show];
				return NO;
			}
			NSString *str = @"";
			str = mPhoneNumberTextField.text;
			if (str.length == 0) {
				str = [str stringByAppendingString:@"("];
				mPhoneNumberTextField.text = str;
			}
			if (str.length == 4) {
				str = [str stringByAppendingString:@")"];
				mPhoneNumberTextField.text = str;
			}
			else if (str.length == 8) {
				str = [str stringByAppendingString:@"-"];
				mPhoneNumberTextField.text = str;
			}
			if ([str length] > 12) {
				mPhoneNumberTextField.text = [str substringToIndex:13];
				UIAlertView *alertIntCheck = [[UIAlertView alloc]initWithTitle:@"Phone number can't be greater than 10 digits." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertIntCheck show];
				return NO;
			}
			else {
				return YES;
			}
		}
	}
	else if (textField == self.mFirstNameTextField) {
		if ([textEntered length]) {
			if ([self isAlpha:textEntered] == FALSE) {
				return NO;
			}
			if ([textField.text length] > 29) {
				if (!isNameLengthCorrect) {
					[CommonFunction fnAlert:@"Alert" message:@"First name can't be greater than 30 characters"];
					isNameLengthCorrect = YES;
				}
				return NO;
			}
			else {
				return YES;
			}
		}
	}
	// Commented by UTKARSHA GUPTA on 4/4/14

	 else if ( textField == self.mLastNameTextField) {
	    if([textEntered length]){
	        if ([self isAlpha:textEntered]==FALSE)
	        {
	            return NO;
	        }

	        if ([textField.text length]>9) {
	            [CommonFunction fnAlert:@"Alert" message:@"Last name can't be greater than 10 characters"];
	            return NO;
	        }
	        else{
	            return YES;
	        }
	    }
	   }

	else if (textField == self.mEmailAddressTextField) {
		if ([self isnumericAlphaForEmail:textEntered] == FALSE) {
			return NO;
		}
	}
	else if (textField == mCity) {
		if ((textField.text.length == 0 && textEntered.length > 0) || textField.text.length) {
			citiesList.hidden = NO;
			[self filterCityArrayForText:textEntered];
		}
		else
			citiesList.hidden = YES;

		if (textField.text.length == 1 && textEntered.length <= 0)
			citiesList.hidden = YES;
	}
	else if (textField == mState) {
		if ((textField.text.length == 0 && textEntered.length > 0) || textField.text.length) {
			stateList.hidden = NO;
			stateList.frame = stateList.frame;
			[self filterStateArrayForText:textEntered];
		}
		else {
			stateList.hidden = YES;
		}

		if (textField.text.length == 1 && textEntered.length <= 0) {
			stateList.hidden = YES;
		}
	}
	else if (textField == self.mAddressTextField) {
		if ([textEntered length]) {
			if ([textField.text length] > 29) {
				if (!isAddressLengthCorrect) {
					[CommonFunction fnAlert:@"" message:@"Address can't be greater than 30 Characters."];
					isAddressLengthCorrect = YES;
				}
				return NO;
			}
			else {
				return YES;
			}
		}
	}

	return YES;
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == kNoMerchantAlertTag && buttonIndex == 0)
    {
		[kAppDelegate showProgressHUD:self.view];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		    [self callRegistrationService];
		});
	}
	else if ([alertView tag] == kShowSideBarAlertTag && buttonIndex == 0)
    {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"showSideControls"
		                                                   object:self];
		// Added by Utkarsha Gupta on 4/4/14.
		NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
		if ([userCompleteIncomplete isEqualToString:@"1"])
        {
			if ([strController isEqualToString:@"Join"])
            {
				PaymentProgramVC *objPaymentProgramVC;
				if (kDevice == kIphone) {
					objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC" bundle:nil];
				}
				else {
					objPaymentProgramVC = [[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC_iPad" bundle:nil];
				}
				[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objPaymentProgramVC] animated:NO];
			}
			else if ([strController isEqualToString:@"My Card"])
            {
				IBMyCardsVC *objIBMyCardsVC;
				if (kDevice == kIphone) {
					objIBMyCardsVC = [[IBMyCardsVC alloc]initWithNibName:@"IBMyCardsVC" bundle:nil];
				}
				else {
					objIBMyCardsVC = [[IBMyCardsVC alloc]initWithNibName:@"IBMyCardsVC_iPad" bundle:nil];
				}
				[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBMyCardsVC] animated:NO];
			}

			else if ([strController isEqualToString:@"My Profile"])
            {
                
                  if(firstTimeRegister==TRUE)
                  {
                      /*commented by abhinav*/
                      /*
                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Would you like to rally your community around your tennis team, club or programs? Would you like year round income coming from donors, supporters and followers who are savings thousands because of you? Just click YES to learn more or start your campaign at www.cyclingwins.com" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                      alert.tag = 8890;
                      [alert show];
                       */
                  }
                else
                {
                    [kAppDelegate.objSideBarVC showView];
                    kAppDelegate.objSideBarVC.lastbtnClicked =  kAppDelegate.objSideBarVC.btnProfile;
                    IBDashboardVC *objIBDashboardVC;
                    if (kDevice == kIphone) {
                        objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
                    }
                    else {
                        objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
                    }
                    
                    [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBDashboardVC] animated:NO];

                }
            }
			else if ([strController isEqualToString:@"Gift"])
            {
				IBGiftVC *objIBGiftVC;
				if (kDevice == kIphone) {
					objIBGiftVC = [[IBGiftVC alloc]initWithNibName:@"IBGiftVC" bundle:nil];
				}
				else {
					objIBGiftVC = [[IBGiftVC alloc]initWithNibName:@"IBGiftVC_iPad" bundle:nil];
				}
				[kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBGiftVC] animated:NO];
			}
		}
	}
	else if (alertView.tag == kGruAlertTag) {
		if (buttonIndex == 0) {
			IBPaymentVC *objIBPaymentVC;
			if (kDevice == kIphone) {
				objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
			}
			else {
				objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
			}
			[self.navigationController pushViewController:objIBPaymentVC animated:TRUE];
		}
		else {
			[kAppDelegate.objSideBarVC btnOffersClicked:nil];
		}
	}
	else if (alertView.tag == kGiftAlertTag) {
		[self.navigationController popViewControllerAnimated:YES];
	}
    else if (alertView.tag==8890)
    {
        if (buttonIndex == 1)
        {
             [self getFundraisingLink];
        }
        else
        {
            [kAppDelegate.objSideBarVC showView];
            kAppDelegate.objSideBarVC.lastbtnClicked =  kAppDelegate.objSideBarVC.btnProfile;
            IBDashboardVC *objIBDashboardVC;
            if (kDevice == kIphone) {
                objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
            }
            else {
                objIBDashboardVC = [[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
            }
            
            [kAppDelegate.navController setViewControllers:[NSArray arrayWithObject:objIBDashboardVC] animated:NO];

        }
       
    }
}

@end
