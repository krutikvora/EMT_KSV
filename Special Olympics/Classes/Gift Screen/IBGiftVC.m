//
//  IBGiftVC.m
//  iBuddyClient
//
//  Created by Anubha on 15/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBGiftVC.h"
#import "IBMultipleAddressVC.h"
#define kLoginRegisterAlertTag 6767
@interface IBGiftVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSmartPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnPostalCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBGiftVC
@synthesize lblCopyRight;
#pragma mark - LifeCycle

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark - Initial Methods
/**
 Set initial labels
 */
-(void)setInitialLabels
{
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font=[UIFont fontWithName:kFont size:label.font.pointSize];
        }
    }
    self.btnEmail.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnPostalCode.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnSmartPhone.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
}
#pragma mark - Button Actions

- (IBAction)btnEmailClicked:(id)sender
{
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];

    if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"]) {
        IBMultipleAddressVC *objIBMultipleAddressVC;
        
        if (kDevice==kIphone) {
            objIBMultipleAddressVC=[[IBMultipleAddressVC alloc]initWithNibName:@"IBMultipleAddressVC" bundle:nil];
        }
        else{
            objIBMultipleAddressVC=[[IBMultipleAddressVC alloc]initWithNibName:@"IBMultipleAddressVC_iPad" bundle:nil];
        }
        objIBMultipleAddressVC.strGiftType=@"Email";
        [self.navigationController pushViewController:objIBMultipleAddressVC animated:YES];
    }
    
    else if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[userPayment isEqualToString:@"inactive"]){
        [kAppDelegate.objSideBarVC callPaymentClass];
        [CommonFunction setValueInUserDefault:@"isGiftVC" value:@"1"];

    }
    else if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[userPayment isEqualToString:@"active"])
    {
        /**** Added by Utkarsha to enable complete registration*****/
        IBRegisterVC *objIBRegisterVC;
        if (kDevice==kIphone) {
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
        }
        else{
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
        }
        objIBRegisterVC.strEditProfile=@"Edit";
        objIBRegisterVC.strController = @"Gift";
        objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
        objIBRegisterVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
        
        //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
        // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
        
        [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
        /******/
        
    }

    else{
       
        [self showAlert];
    }

}
- (IBAction)btnPostalClicked:(id)sender
{
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];

   if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"]) {
        IBMultipleAddressVC *objIBMultipleAddressVC;
        
        if (kDevice==kIphone) {
            objIBMultipleAddressVC=[[IBMultipleAddressVC alloc]initWithNibName:@"IBMultipleAddressVC" bundle:nil];
        }
        else{
            objIBMultipleAddressVC=[[IBMultipleAddressVC alloc]initWithNibName:@"IBMultipleAddressVC_iPad" bundle:nil];
        }
        objIBMultipleAddressVC.strGiftType=@"Address";
        [self.navigationController pushViewController:objIBMultipleAddressVC animated:YES];
    }
   else if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[userPayment isEqualToString:@"inactive"]){
       [kAppDelegate.objSideBarVC callPaymentClass];
       [CommonFunction setValueInUserDefault:@"isGiftVC" value:@"1"];

   }
    else if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[userPayment isEqualToString:@"active"])
    {
        /**** Added by Utkarsha to enable complete registration*****/
        IBRegisterVC *objIBRegisterVC;
        if (kDevice==kIphone) {
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
        }
        else{
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
        }
        objIBRegisterVC.strEditProfile=@"Edit";
        objIBRegisterVC.strController = @"Gift";
        objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
        objIBRegisterVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
        
        //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
        // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
        
        [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
        /******/

    }
    else{
        [self showAlert];
    }
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

#pragma mark - Alert View Delegates
-(void)showAlert
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to either login or register to access the gift feature." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login",@"Register", nil];
    alert.tag=kLoginRegisterAlertTag;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kLoginRegisterAlertTag) {
        
        if (buttonIndex==1) {
            IBLoginVC *objIBLoginVC;
            if (kDevice==kIphone) {
                objIBLoginVC=[[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
            }
            else{
                objIBLoginVC=[[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
            }
            [CommonFunction setValueInUserDefault:@"isGiftVC" value:@"1"];
            objIBLoginVC.classType=kGiftClass;
            [self.navigationController pushViewController:objIBLoginVC animated:YES];
        }
        else if (buttonIndex==2){
            IBShortRegisterVC *objIBRegisterVC;
            if (kDevice==kIphone) {
                objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC" bundle:nil];
            }
            else{
                objIBRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC_iPad" bundle:nil];
            }
            [CommonFunction setValueInUserDefault:@"isGiftVC" value:@"1"];
            NSMutableDictionary *dictClassType=[[NSMutableDictionary alloc]init];
            [dictClassType setObject:kGiftClass forKey:@"classType"];
            objIBRegisterVC.dictProfileData=dictClassType;
            [self.navigationController pushViewController:objIBRegisterVC animated:YES];
        }
    }
}
@end
