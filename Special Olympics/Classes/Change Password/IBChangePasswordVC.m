//
//  IBChangePasswordVC.m
//  iBuddyClient
//
//  Created by Anubha on 16/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBChangePasswordVC.h"

@interface IBChangePasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *fld_OldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fld_NewPassword;
@property (weak, nonatomic) IBOutlet UITextField *fld_ConfermPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OldPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ConferPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnLogOut;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation IBChangePasswordVC

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setFld_OldPassword:nil];
    [self setFld_NewPassword:nil];
    [self setFld_ConfermPassword:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);

    
}

#pragma mark-
#pragma mark - Buttons Action

/**-
 @Method    -  updateAction -> Perform change password
 @Param     -  merchantId, oldPassword, NewPassword
 @Responce  -  status = 1 -> success
 status = 0 -> incorrect old pwd
 status = -1 -> error
 */
- (IBAction)updateAction:(id)sender {
    
    if ([self checkFieldValidation]==YES) {
        [kAppDelegate showProgressHUD:self.view];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:self.fld_OldPassword.text forKey:@"oldPassword"];
        [dict setValue:self.fld_NewPassword.text forKey:@"newPassword"];
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kChangePassword] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                
                [CommonFunction setValueInUserDefault:kPassword value:_fld_NewPassword.text];
                [CommonFunction fnAlert:@"" message:@"Password updated successfully"];
                [CommonFunction setValueInUserDefault:kPasswordChanged value:@"YES"];
               
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Failure" message:@"Your Old Password may incorrect"];
                
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"Failure" message:@"Your Old Password may incorrect"];
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
/*
 Method used for 
 Log out 
 */
- (IBAction)LogOutAction:(id)sender {
        [kAppDelegate showProgressHUD:self.view];
       [CommonFunction deleteValueForKeyFromUserDefault:@"userName"];
   
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"tokenId"];
        [dict setValue:deviceTest forKey:@"deviceType"];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kLogOut] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                [kAppDelegate setDictUserInfo:nil];
                [kAppDelegate hideProgressHUD];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"You are successfully logged out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=101;
                [alert show];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
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


#pragma mark -
#pragma mark - Initial Methods
-(void)setInitialLabels
{
    self.btnUpdate.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnLogOut.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_OldPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_NewPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_ConferPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    [self setTextboxborder:_fld_OldPassword];
    [self setTextboxborder:_fld_NewPassword];
    [self setTextboxborder:_fld_ConfermPassword];
    _backView.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
    _backView.layer.borderWidth = 1;
    [_fld_OldPassword becomeFirstResponder];



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
    
    BOOL returnValue=YES;
    if (self.fld_OldPassword.text.length<=0&&self.fld_NewPassword.text.length<=0&&self.fld_ConfermPassword.text.length<=0) {
        [CommonFunction fnAlert:@"" message:@"Please enter Old Password,New Password and Confirm New Password"];
        returnValue=NO;
    }
    else if (self.fld_OldPassword.text.length<=0&&self.fld_NewPassword.text.length!=0&&self.fld_ConfermPassword.text.length!=0) {
        [CommonFunction fnAlert:@"" message:@"Please enter Old Password"];
        returnValue=NO;
    }
    else if (self.fld_NewPassword.text.length<=0&&self.fld_ConfermPassword.text.length<=0&&self.fld_OldPassword.text.length!=0) {
        [CommonFunction fnAlert:@"" message:@"Please enter New Password and Confirm New Password"];
        returnValue=NO;
    }
    else if (self.fld_NewPassword.text.length<6&&self.fld_OldPassword.text.length!=0) {
        [CommonFunction fnAlert:@"" message:@"Please enter password of minimum 6 letters"];
        returnValue=NO;
    }

    else if (![self.fld_NewPassword.text isEqualToString:self.fld_ConfermPassword.text]) {
        [CommonFunction fnAlert:@"" message:@"Your New Password & Confirm New Password must be same"];
        returnValue=NO;
    }
    return returnValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [CommonFunction callHideViewFromSideBar];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x,-50, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
	return YES;
}
-(void)setTextboxborder:(UITextField *)textbox
{
        UIView *leftPAdding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, textbox.frame.size.height)];
        textbox.leftView = leftPAdding;
        textbox.leftViewMode = UITextFieldViewModeAlways;
        textbox.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
        textbox.layer.borderWidth = 1;
        [textbox setValue:[UIColor lightGrayColor]
           forKeyPath:@"_placeholderLabel.textColor"];

}

@end
