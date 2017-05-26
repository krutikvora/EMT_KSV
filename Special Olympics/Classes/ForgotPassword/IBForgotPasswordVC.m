//
//  IBForgotPasswordVC.m
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBForgotPasswordVC.h"
#define kResetPWDAlertTag 6767
#define kMerchantUserPWDAlertTag 6868
@interface IBForgotPasswordVC ()

@property (weak, nonatomic) IBOutlet UILabel *lbl_email;
@property (weak, nonatomic) IBOutlet UILabel *lbl_top;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet UITextField *txt_Email;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBForgotPasswordVC
@synthesize lblCopyRight;
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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLbl_email:nil];
    [self setLbl_top:nil];
    [self setBtn_Submit:nil];
    [self setBtn_Cancel:nil];
    [self setTxt_Email:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark-
#pragma mark - Set Initial Variables

/** Method to set Initial Values
 */
-(void)setInitialLabels
{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    self.lbl_top.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_email.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Submit.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Cancel.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    UIView *leftPAdding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, _txt_Email.frame.size.height)];
    _txt_Email.leftView = leftPAdding;
    _txt_Email.leftViewMode = UITextFieldViewModeAlways;
    _txt_Email.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
    _txt_Email.layer.borderWidth = 1;
    [_txt_Email setValue:[UIColor lightGrayColor]
               forKeyPath:@"_placeholderLabel.textColor"];

}

#pragma mark-
#pragma mark - Buttons Action


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/**-
 @Method    -  submitAction -> Perform forgot password
 @Param     -  User email 
 @Responce  -  status = 1 -> success
 status = 0 -> invalid emailID
 status = -1 -> error
 */
- (IBAction)submitAction:(id)sender {
    [_txt_Email resignFirstResponder];
    if (![self.txt_Email.text length]>0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter Email."];
        
    }
    else if(![CommonFunction checkEmail:self.txt_Email.text]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter valid email address."];
    }
    else {
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.txt_Email.text forKey:@"email"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kForgotPassword] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"isBoth"]isEqualToString:@"no"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successful" message:@"Please check your Email Id to reset your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=kResetPWDAlertTag;
                [alert show];
                return ;
                
            }
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]&&[[result valueForKey:@"isBoth"]isEqualToString:@"yes"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successful" message:@"Do you want to reset your password as Merchant or User?" delegate:self cancelButtonTitle:@"Merchant" otherButtonTitles:@"User", nil];
                alert.tag=kMerchantUserPWDAlertTag;
                [alert show];
                
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Failure" message:@"No user exists with this Email-Id"];
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
- (IBAction)cancelAction:(id)sender {
    if ([self.txt_Email.text length]>0) {
        self.txt_Email.text=@"";
    }
    else{
        [CommonFunction fnAlert:@"Alert!" message:@"No text to reset."];
    }
}


#pragma mark-
#pragma mark - Text Field Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
    
}
#pragma mark-
#pragma mark - Alert View Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0&&alertView.tag==kResetPWDAlertTag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([alertView tag]==kMerchantUserPWDAlertTag && buttonIndex==0){
        [self setUserForForgotPWD:@"merchant"];
    }
    if ([alertView tag]==kMerchantUserPWDAlertTag && buttonIndex==1){
        [self setUserForForgotPWD:@"user"];
        
    }
   
}
#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.txt_Email resignFirstResponder];
        
    }
}

-(void)setUserForForgotPWD:(NSString *)userType{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txt_Email.text forKey:@"email"];
    [dict setValue:userType forKey:@"userOrMerchant"];

    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kSendForgotMail] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successful" message:@"Please check your Email Id to reset your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=kResetPWDAlertTag;
            [alert show];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"Failure" message:@"Please enter valid Email."];
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




@end
