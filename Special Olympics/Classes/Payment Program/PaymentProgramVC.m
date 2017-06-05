//
//  PaymentProgramVC.m
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "PaymentProgramVC.h"
#import "IBSalepersonSearchVC.h"
#define minusHeight 210
@interface PaymentProgramVC ()
{
    IBOutlet UISegmentedControl *typeSegmentCntrl;

}
@property (weak, nonatomic) IBOutlet UITextView *txtiBuddy;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymentProgram;
@property (weak, nonatomic) IBOutlet UILabel *lblSalesperson;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UITextField *txtSalesperson;
@property (weak, nonatomic) IBOutlet UILabel *lblSubscriptionstatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRecurringDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOR;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@property (weak, nonatomic) IBOutlet UIButton *btnEducators;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchFundraiser;

@end

@implementation PaymentProgramVC
@synthesize strSearchedSalesperson,lblCopyRight,dictProfileData;
#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _txtSalesperson.text=[CommonFunction getValueFromUserDefault:@"SearchedSalesperson"];
    [CommonFunction deleteValueForKeyFromUserDefault:@"SearchedSalesperson"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialLabels];
    [self checkActiveUser];
    //--- Segment control to select between educators and supporters:
    [typeSegmentCntrl addTarget:self action:@selector(action) forControlEvents:UIControlEventValueChanged];
    typeSegmentCntrl.selectedSegmentIndex=0;
    [self.btnPaymentProgram addTarget:self action:@selector(btnPaymentProgClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark Segment click event
-(void)action
{
    
    if(typeSegmentCntrl.selectedSegmentIndex==0)
    {
        NSLog(@"0");
        [self.btnPaymentProgram setTitle:@"Purchase App Without Fundraiser" forState:UIControlStateNormal];
        [self.btnOK setTitle:@"Purchase App" forState:UIControlStateNormal];
        [self.btnPaymentProgram removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
        [self.btnPaymentProgram addTarget:self action:@selector(btnPaymentProgClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.lblOR.text=@"Or purchase App without a Fundraiser";
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"To get the Mobile App Savings Platform for FREE please use your Ambassador Code only available to USPTA Convention Attendee's. Also Place Dick Stockton's Blue Sky Foundation number(S0150-00150) in Fundraiser Code. Please give as you save." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 9900;
        [alert show];
        
        self.lblOR.text=@"Or Get App without a Fundraiser";

        [self.btnPaymentProgram removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
        [self.btnPaymentProgram setTitle:@"Get App Without Fundraiser" forState:UIControlStateNormal];
        [self.btnOK setTitle:@"Get App" forState:UIControlStateNormal];
        [self.btnPaymentProgram addTarget:self action:@selector(btnEducatorLoginClicked:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    
    
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
#pragma mark - Private Methods

/**
 Set initial labels
 */
-(void)setInitialLabels
{
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
     self.lblDate.font=[UIFont fontWithName:kFont size:self.lblDate.font.pointSize];
     self.lblRecurringDate.font=[UIFont fontWithName:kFont size:self.lblRecurringDate.font.pointSize];
     self.lblSubscriptionstatus.font=[UIFont fontWithName:kFont size:self.lblSubscriptionstatus.font.pointSize];
    self.lblSalesperson.font=[UIFont fontWithName:kFont size:self.lblSalesperson.font.pointSize];
    self.lblSearchFundraiser.font=[UIFont fontWithName:kFont size:self.lblSearchFundraiser.font.pointSize];
    self.lblOR.font=[UIFont fontWithName:kFont size:self.lblOR.font.pointSize];
    self.txtiBuddy.font=[UIFont fontWithName:kFont size: self.txtiBuddy.font.pointSize];
    self.btnOK.titleLabel.font=[UIFont fontWithName:kFont size:self.btnOK.titleLabel.font.pointSize];
    self.btnPaymentProgram.titleLabel.font=[UIFont fontWithName:kFont size:self.btnPaymentProgram.titleLabel.font.pointSize];
    self.btnEducators.titleLabel.font=[UIFont fontWithName:kFont size:self.btnEducators.titleLabel.font.pointSize];
    
    self.lblUniversalCode.font=[UIFont fontWithName:kFont size:self.lblSearchFundraiser.font.pointSize];
    self.lblTitleText.font=[UIFont fontWithName:kFont size:self.lblSearchFundraiser.font.pointSize];

    self.txtiBuddy.editable=NO;
  
    
    NSString *strTxtIbUddy=@"";
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:  @"By purchasing the DCSD Mobile Application,(powered by iBC, Inc.) you get a significant \"Return On Their Investment\" and will be contributing and partnering with the community for years to come."];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Some of the benefits of owning the DCSD Mobile Application are below."];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"1. Save hundreds and in some cases thousands each year on every day purchases."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"2. Pays for itself after the first few redeems or just one Golden Egg redeem coupon."];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"3. Help raise money and awareness for DCSD Fundraising Programs."];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

//    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"4.Discounts always readily available with Smart Phone App or Smart Card."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"4. Discounts always readily available in the palm of your hand."];
    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"5. Use for one full year with automatic renewal on anniversary date of purchase."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"6. New deals and business merchants added to the program every Saturday."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];


    
     strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"7. Support  \"thousands of Colorado merchants\"  because \"Buying Local is Staying Local.\" "];
    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"The DCSD Fun Raising Revolution promises to become a unique experience and lifestyle that contributes too many organizations right in your own backyard."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Thank you for your support!"];
    self.txtiBuddy.text=strTxtIbUddy;
    if (kDevice!=kIphone) {
        _txtSalesperson.frame=CGRectMake(_txtSalesperson.frame.origin.x, _txtSalesperson.frame.origin.y, _txtSalesperson.frame.size.width, _txtSalesperson.frame.size.height+10);

    }

}
/*
 Method to set class after Click of "Ok" Button
 */
-(void)setClassPushAfterOK:(NSString *)salespersonID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if([self.txtSalesperson.text containsString:@"s"] || [self.txtSalesperson.text containsString:@"S"])
    {
        [dict setValue:self.txtSalesperson.text forKey:@"studentId"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"Student"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [dict setValue:@"" forKey:@"salespersonId"];
    }
    else
    {
        [dict setValue:self.txtSalesperson.text forKey:@"salespersonId"];
        [dict setValue:@"" forKey:@"studentId"];
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Student"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];


    }
//    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
//    [dict setValue:deviceTest forKey:@"deviceType"];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kSaveFundraisercode] completeBlock: ^(NSData *data)
         {
             id result = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions error:nil];
             if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
             {
                 [self setUpdateProfileValues:result];
                 IBRegisterVC *objIBRegisterVC;
                 if (kDevice==kIphone)
                 {
                     objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
                 }
                 else
                 {
                     objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
                 }
                 //    objIBRegisterVC.btnTapped=@"educatorLogin";
                 //    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
                 objIBRegisterVC.strEditProfile=@"Edit";
                 objIBRegisterVC.isNewUser=true;
                 
                 //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                 objIBRegisterVC.strController = @"My Profile";
                 
                 if([self.txtSalesperson.text containsString:@"s"] || [self.txtSalesperson.text containsString:@"S"])
                 {
                     objIBRegisterVC.strSalespersonCode=@"";
                     objIBRegisterVC.strStudentCode=[NSString stringWithFormat:@"%@",salespersonID];
                     
                     
                 }
                 else
                 {
                     objIBRegisterVC.strStudentCode=@"";
                     
                     objIBRegisterVC.strSalespersonCode=[NSString stringWithFormat:@"%@",salespersonID];
                     
                 }
                 
                 //    if(typeSegmentCntrl.selectedSegmentIndex==0)
                 //    {
                 //        objIBRegisterVC.btnTapped=@"purchaseWthoutFundraiser";
                 //
                 //    }
                 //    else
                 //    {
                 //        objIBRegisterVC.btnTapped=@"educatorLogin";
                 //        
                 //        
                 //    }
                 kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:objIBRegisterVC];
                 //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                 //    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
                 
                 kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
                 kAppDelegate.navController.navigationBarHidden=true;
                 kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
                 
                 kAppDelegate.sideMenuController.leftViewWidth = 260.0;
                 kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
                 [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];

                 
             }
             else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                 [CommonFunction fnAlert:@"Updation Failure" message:@"Please enter the complete details"];
             }
             
             else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                 [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
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


}

- (void)setUpdateProfileValues:(NSDictionary *)result {
    if ([[CommonFunction getValueFromUserDefault:kZipCodeHighlighted]isEqualToString:@"False"]) {
        [CommonFunction setValueInUserDefault:kZipCode value:[result valueForKey:@"zipcode"]];
    }
    kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:result];
    dictProfileData = [NSMutableDictionary dictionaryWithDictionary:result];
}

#pragma mark - Button Actions

- (void)btnPaymentProgClicked:(id)sender {
      [_txtSalesperson resignFirstResponder];
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
    //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
    objIBRegisterVC.strController = @"My Profile";
    objIBRegisterVC.isNewUser=true;

    //    objIBRegisterVC.btnTapped=@"educatorLogin";
    kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:objIBRegisterVC];
    //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
    //    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
    kAppDelegate.navController.navigationBarHidden=true;

    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
    
    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
    
    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];
}
-(void)btnEducatorLoginClicked:(id)sender
{
    
    
    [_txtSalesperson resignFirstResponder];
    //Krutik vora Changes
//    IBShortRegisterVC *objIBRegisterVC;
//    if (kDevice==kIphone)
//    {
//        objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC" bundle:nil];
//    }
//    else
//    {
//        objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC_iPad" bundle:nil];
//    }
//    objIBRegisterVC.btnTapped=@"educatorLogin";
//    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
    
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
//    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
    
    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
    kAppDelegate.navController.navigationBarHidden=true;

    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
    
    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    [kAppDelegate.window setRootViewController:kAppDelegate.navController];


    
    
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}
#pragma mark Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==9900)
    {
        
       
    }
    
}

- (IBAction)btnOkClicked:(id)sender {
    [_txtSalesperson resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if ([self.txtSalesperson.text isEqualToString:@""]||[self.txtSalesperson.text length]==0) {
       // [self setClassPushAfterOK:@""];
         [CommonFunction fnAlert:@"" message:@"Please enter or search for the Fundraiser code."];
    }
    else{
        
        if([self.txtSalesperson.text containsString:@"s"] || [self.txtSalesperson.text containsString:@"S"])
        {
            [kAppDelegate showProgressHUD:self.view];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.txtSalesperson.text forKey:@"studentCode"];
            [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kValidateStudentCode] completeBlock:^(NSData *data)
             {
                 id result = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions error:nil];
                 if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                     [self setClassPushAfterOK:[result valueForKey:@"studentId"]];
                 }
                 else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                     [CommonFunction fnAlert:@"Failure!" message:@"Invalid code."];
                 }
                 else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                     [CommonFunction fnAlert:@"" message:@"Please try again"];
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
        else
        {
            [kAppDelegate showProgressHUD:self.view];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.txtSalesperson.text forKey:@"salespersonCode"];
            [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kValidateSalespersonCode] completeBlock:^(NSData *data) {
                id result = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions error:nil];
                if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                    [self setClassPushAfterOK:[result valueForKey:@"salespersonId"]];
                }
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                    [CommonFunction fnAlert:@"Failure!" message:@"Invalid code."];
                }
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                    [CommonFunction fnAlert:@"" message:@"Please try again"];
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
        
    }
}

- (IBAction)btnSearchClicked:(id)sender
{
     [CommonFunction fnAlert:@"Alert" message:@"Please make sure you search proper Fundraiser or Player"];
    [_txtSalesperson resignFirstResponder];
    IBSalepersonSearchVC *objIBSalepersonSearchVC;
    
    if (kDevice==kIphone) {
        objIBSalepersonSearchVC=[[IBSalepersonSearchVC alloc]initWithNibName:@"IBSalepersonSearchVC" bundle:nil];
    }
    else{
        objIBSalepersonSearchVC=[[IBSalepersonSearchVC alloc]initWithNibName:@"IBSalespersonSearchVC_iPad" bundle:nil];
        
    }
    [self.navigationController pushViewController:objIBSalepersonSearchVC animated:YES];
}
-(void)checkActiveUser
{
    NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
    if ([userID length]>0&&[userPayment isEqualToString:@"active"])
    {
        self.btnOK.hidden=YES;
        self.btnPaymentProgram.hidden=YES;
        self.btnEducators.hidden=YES;
        typeSegmentCntrl.hidden=YES;
        self.txtSalesperson.hidden=YES;
        self.lblSalesperson.hidden=YES;
        self.lblSearchFundraiser.hidden=YES;
        self.btnSearch.hidden=YES;
        self.lblSearchFundlizer.hidden = true;
        self.lblOR.hidden=YES;
        self.lblSubscriptionstatus.hidden=NO;
        self.lblTitleText.hidden=true;
        self.imgLogo.hidden=true;
        self.lblUniversalCode.hidden=YES;

        if ([kAppDelegate.dictUserInfo valueForKey:@"nextPaymentDate"]!=NULL&&[[kAppDelegate.dictUserInfo valueForKey:@"paymentType"]isEqualToString:@"paypal"]){
            self.lblRecurringDate.hidden=NO;
            self.lblDate.hidden=NO;
            self.lblDate.adjustsFontSizeToFitWidth=TRUE;
            self.lblDate.text=[kAppDelegate.dictUserInfo valueForKey:@"nextPaymentDate"];
        }
        else{
            self.lblRecurringDate.hidden=NO;
            self.lblDate.hidden=NO;
            self.lblDate.adjustsFontSizeToFitWidth=TRUE;
            self.lblDate.text=[kAppDelegate.dictUserInfo valueForKey:@"nextPaymentDate"];
        }
    }
    else{
        self.btnOK.hidden=NO;
        self.btnPaymentProgram.hidden=NO;
        self.btnEducators.hidden=NO;
        //typeSegmentCntrl.hidden=NO;
        self.txtSalesperson.hidden=NO;
        self.lblSalesperson.hidden=NO;
        self.lblSearchFundraiser.hidden=NO;

        self.btnSearch.hidden=NO;
        self.lblSearchFundlizer.hidden = false;

        self.lblOR.hidden=NO;
        self.lblSubscriptionstatus.hidden=YES;
        self.lblRecurringDate.hidden=YES;
        self.lblDate.hidden=YES;
        self.lblTitleText.hidden=false;
        self.imgLogo.hidden=false;
        self.lblUniversalCode.hidden=false;

    }
}

#pragma mark TextField Delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered {
    if (textField == _txtSalesperson) {
        if([textEntered length]<=0)
        {
            return YES;
        }
        NSString *str = [_txtSalesperson.text stringByReplacingCharactersInRange:range withString:textEntered];
        // [_txtSalesperson setText:[_txtSalesperson.text stringByReplacingCharactersInRange:range withString:textEntered]];
        // str = _txtSalesperson.text;
        if (str.length == 5) {
            str = [str stringByAppendingString:@"-"];
            _txtSalesperson.text = str;
            return NO;
        }
        
        else {
            return YES;
        }
    }
    
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [CommonFunction callHideViewFromSideBar];

    if (textField == self.txtSalesperson) {
        
    [UIView beginAnimations:@"Animate Text Field Up" context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
        self.view.frame=CGRectMake(0, self.view.frame.origin.y-minusHeight, self.view.frame.size.width, self.view.frame.size.height+40);

    
    [UIView commitAnimations];
    }
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"Animate Text Field Up" context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:@"Animate Text Field Up" context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setLblSubscriptionstatus:nil];
    [self setLblRecurringDate:nil];
    [self setLblDate:nil];
    [self setLblOR:nil];
    [super viewDidUnload];
}
#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        btnArrowUp.hidden=TRUE;
        btnArrowDown.hidden=FALSE;
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=TRUE;
    }
    else if (scrollOffset > 0&&scrollOffset + scrollViewHeight != scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=FALSE;
    }
}
@end
