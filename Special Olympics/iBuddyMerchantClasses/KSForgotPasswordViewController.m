//
//  KSForgotPasswordViewController.m
//  iBuddyClub
//
//  Created by Anubha on 10/04/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSForgotPasswordViewController.h"

@interface KSForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_email;
@property (weak, nonatomic) IBOutlet UILabel *lbl_top;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet UITextField *txt_Email;

@end

@implementation KSForgotPasswordViewController

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

    self.lbl_top.font=[UIFont fontWithName:kFont size:self.lbl_top.font.pointSize];
    self.lbl_email.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Submit.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Cancel.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
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
#pragma mark - Private Methods

#pragma mark-
#pragma mark - Buttons Action


- (IBAction)backAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
/**-
 @Method    -  submitAction -> Perform forgot password
 @Param     -  merchantEmailId
 @Responce  -  status = 1 -> success
 status = 0 -> invalid emailID
 status = -1 -> error
 */
- (IBAction)submitAction:(id)sender {
     if ([self.txt_Email.text length]>0) {
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txt_Email.text forKey:@"merchantEmailId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kForgotPassword] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successful" message:@"Please check your Email Id to reset your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"Failure" message:@"Please enter valid Email."];}
       else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again."];
        }
       else {
           [CommonFunction fnAlert:@"Server Error!" message:@"Please try again."];
           
       }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        [kAppDelegate hideProgressHUD];
    }];
    }
     else{
         [CommonFunction fnAlert:@"Alert!" message:@"Please enter Email."];
     }
}

- (IBAction)cancelAction:(id)sender {
    if ([self.txt_Email.text length]>0) {
        self.txt_Email.text=@"";
    }
    else{
        [CommonFunction fnAlert:@"Alert!" message:@"No text to delete."];
    }
}
#pragma mark-
#pragma mark - Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
} 
@end
