//
//  KSViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 11/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSLoginViewController.h"

@interface KSLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fld_Email;
@property (weak, nonatomic) IBOutlet UITextField *fld_Password;
@property (weak, nonatomic) IBOutlet UIImageView *img_TikUntik;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_EmailId;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Password;
@property (weak, nonatomic) IBOutlet UILabel *lbl_reminder;
@property (weak, nonatomic) IBOutlet UIButton *btn_Login;
@property (weak, nonatomic) IBOutlet UIButton *btn_forgotPwd;
-(BOOL)checkFieldValidation;
@end

@implementation KSLoginViewController


#pragma mark -
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

	// Do any additional setup after loading the view, typically from a nib.
    if (![[CommonFunction getValueFromUserDefault:kMerchantId] isEqualToString:@"-1"]){
    }
    [self setInitialLabels];
    [self ChecKRememberMe];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setFld_Email:nil];
    [self setFld_Password:nil];
    [self setImg_TikUntik:nil];
    [self setBtn_forgotPwd:nil];
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
 @Method    -  loginAction -> Perform user Login
 @Param     -  emailId, Password
 @Responce  -  status = 1 -> success - return merchantId
 status = 0 -> invalid username/password
 status = -1 -> error
 */

- (IBAction)loginAction:(id)sender {
    [_fld_Email resignFirstResponder];
    [_fld_Password resignFirstResponder];
    if ([self checkFieldValidation]==YES) {
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.fld_Email.text forKey:@"email"];
        [dict setValue:self.fld_Password.text forKey:@"password"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kLoginMerchant] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
               [CommonFunction setValueInUserDefault:kMerchantId value:[result valueForKey:kMerchantId]];
                if ([[result valueForKey:@"isSkip"]isEqualToString:@"yes"]) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                    kAppDelegate.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
                    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
                    kAppDelegate.window.rootViewController = viewController;
                    [kAppDelegate.window makeKeyAndVisible];
                }
                else {
                    [self performSegueWithIdentifier:@"segue_ChangePassword" sender:self];
                }
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
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
            
        } errorBlock:^(NSError *error) {
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            [kAppDelegate hideProgressHUD];
        }];
    }
}
/*
 Action of Remember Me button
 */
- (IBAction)rememberAction:(id)sender {
    if ([self.img_TikUntik.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1@2x.png"]]) {
        self.img_TikUntik.image=[UIImage imageNamed:@"Settings_CheckBox2_2@2x.png"];
        [CommonFunction setValueInUserDefault:@"RememberMe" value:@"YES"];
        [CommonFunction setValueInUserDefault:@"EmailId" value:self.fld_Email.text];
        [CommonFunction setValueInUserDefault:@"Password" value:self.fld_Password.text];
        
    }else{
        self.img_TikUntik.image=[UIImage imageNamed:@"Settings_CheckBox1_1@2x.png"];
        
        [CommonFunction setValueInUserDefault:@"RememberMe" value:@"NO"];
        [CommonFunction setValueInUserDefault:@"EmailId" value:@""];
        [CommonFunction setValueInUserDefault:@"Password" value:@""];
    }
}
/*
 Method to check remeber ME 
 */
-(void)ChecKRememberMe
{
    if ([[CommonFunction getValueFromUserDefault:@"RememberMe"] isEqualToString:@"YES"]) {
        self.fld_Email.text=[CommonFunction getValueFromUserDefault:@"EmailId"];
        self.fld_Password.text=[CommonFunction getValueFromUserDefault:@"Password"];
        self.img_TikUntik.image=[UIImage imageNamed:@"Settings_CheckBox2_2@2x.png"];
    }
}
/*
 Method to set initial labels
 */
-(void)setInitialLabels
{
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:self.lbl_ScreenTitle.font.pointSize];
    self.lbl_EmailId.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_Password.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_reminder.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Login.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_forgotPwd.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
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
    if ([emailTest evaluateWithObject:self.fld_Email.text] != YES ) {
        str=@"valid Email-Id";
    }
    if (self.fld_Email.text.length==0) {
        str=@"Email-Id";
    }
    if (self.fld_Password.text.length<=0 || [CommonFunction stringAfterTriming:self.fld_Password.text].length<=0 )
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
        [CommonFunction fnAlert:[NSString stringWithFormat:@"Please enter %@.",str] message:@""];
        return NO;
    }
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered
{
    BOOL returnVal=YES;
    if (textField==self.fld_Email) {
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
    return returnVal;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x,-50, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField==self.fld_Email) {
      if ([[CommonFunction getValueFromUserDefault:@"RememberMe"] isEqualToString:@"YES"])
      {
           [CommonFunction setValueInUserDefault:@"EmailId" value:self.fld_Email.text];
      }
      else{
          [CommonFunction setValueInUserDefault:@"EmailId" value:@""];
      }
        
    }else{
        if ([[CommonFunction getValueFromUserDefault:@"RememberMe"] isEqualToString:@"YES"])
        {
            [CommonFunction setValueInUserDefault:@"Password" value:self.fld_Password.text];
        }
        else{
            [CommonFunction setValueInUserDefault:@"Password" value:@""];
        }
    }
   
	return YES;
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


@end
