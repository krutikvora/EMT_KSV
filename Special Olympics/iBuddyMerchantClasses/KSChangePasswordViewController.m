//
//  KSChangePasswordViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 12/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSChangePasswordViewController.h"

@interface KSChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fld_OldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fld_NewPassword;
@property (weak, nonatomic) IBOutlet UITextField *fld_ConfermPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_changePassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OldPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ConferPassword;
@end

@implementation KSChangePasswordViewController
@synthesize viewMode;

#pragma mark -
#pragma mark - View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialLabels];
	// Do any additional setup after loading the view.
   
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
    [self setLbl_ScreenTitle:nil];
    [self setLbl_changePassword:nil];
    [self setTxtNewPwd:nil];
    [super viewDidUnload];
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
 @Method    -  updateAction -> Perform change password
 @Param     -  merchantId, oldPassword, NewPassword
 @Responce  -  status = 1 -> success
 status = 0 -> incorrect old pwd
 status = -1 -> error
 */
- (IBAction)updateAction:(id)sender {
    
    [self resignkeyboard];
    if ([self checkFieldValidation]==YES) {
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[CommonFunction getValueFromUserDefault:kMerchantId] forKey:@"merchantId"];
        [dict setValue:self.fld_OldPassword.text forKey:@"oldPassword"];
        [dict setValue:self.fld_NewPassword.text forKey:@"newPassword"];
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kChangePasswordMerchant] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                [CommonFunction setValueInUserDefault:@"Password" value:_txtNewPwd.text];
                [CommonFunction setValueInUserDefault:@"PasswordChanged" value:@"YES"];
                if (viewMode==viewFromChangePasswordMerchant){
                    [self skip_LogOutAction:nil];
                }
                else{
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Password updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alertView.tag=101;
                [alertView show];
            }
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Failure" message:@"Your Old Password may incorrect"];
                [self blankTextFields];
                
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
                [self blankTextFields];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                
            }
            [kAppDelegate hideProgressHUD];
            
        } errorBlock:^(NSError *error) {
            
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            [kAppDelegate hideProgressHUD];
            [self blankTextFields];
        }];
    }
}
/*
 Method used for both
 Log out and skip action
 */
- (IBAction)skip_LogOutAction:(id)sender {
    
    
    if (viewMode==viewFromChangePasswordMerchant){
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[CommonFunction getValueFromUserDefault:kMerchantId] forKey:@"merchantId"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kSkip] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                [CommonFunction setValueInUserDefault:@"PasswordChanged" value:@"YES"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
                kAppDelegate.window.rootViewController = viewController;
                [kAppDelegate.window makeKeyAndVisible];
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                
            }
            [kAppDelegate hideProgressHUD];
            
        } errorBlock:^(NSError *error) {
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            [kAppDelegate hideProgressHUD];
        }];
        
        
    }else{
        [CommonFunction setValueInUserDefault:kUserType value:@""];
        [kAppDelegate  createWindowAgain];
        
    }
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
#pragma mark -
#pragma mark - Initial Methods
-(void)setInitialLabels
{
    UIButton *btnUpdate=(UIButton *)[self.view viewWithTag:339];
    btnUpdate.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    UIButton *btnSkip=(UIButton *)[self.view viewWithTag:340];
    btnSkip.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    if (viewMode==viewForSettingMerchant) {
        btnSkip.titleLabel.text=[NSString stringWithFormat:@"%@",@"Logout"];
//        btnSkip.hidden=TRUE;
        self.lbl_ScreenTitle.text=@"SETTINGS";
        self.lbl_changePassword.hidden=FALSE;
    }
    if (viewMode==viewFromChangePasswordMerchant){
        btnSkip.titleLabel.text=@" Skip ";
        self.lbl_ScreenTitle.text=@"CHANGE PASSWORD";
        self.lbl_changePassword.hidden=TRUE;
    }
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:self.lbl_ScreenTitle.font.pointSize];
    self.lbl_changePassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_OldPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_NewPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_ConferPassword.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
}

#pragma mark -
#pragma mark - Delegate Methods

#pragma mark -
#pragma mark - Segues
/**
 @Method    -  prepareForSegue: -> Use if you want to send/set value to destination controller
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue_ChangePassword"]){
        
    }
}

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
    else if (![self.fld_NewPassword.text isEqualToString:self.fld_ConfermPassword.text]) {
        [CommonFunction fnAlert:@"" message:@"Your New Password & Confirm New Password must be same"];
        returnValue=NO;
    }
    return returnValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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
#pragma mark Alert View Delagate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0&&alertView.tag==101) {
        [self blankTextFields];
    }
}
-(void)blankTextFields
{
    _fld_ConfermPassword.text=@"";
    _fld_NewPassword.text=@"";
    _fld_OldPassword.text=@"";
}
-(void)resignkeyboard{
    [_fld_ConfermPassword resignFirstResponder];
    [_fld_NewPassword resignFirstResponder];
    [_fld_OldPassword resignFirstResponder];
}

@end
