//
//  IBShortRegisterVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 02/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "CustomFormViewController.h"
#import "BSKeyboardControls.h"
#import "CustomFormViewController.h"
#import "UILabel+UILabel_highlightColor.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface IBShortRegisterVC : CustomFormViewController<UINavigationControllerDelegate,UIActionSheetDelegate,BSKeyboardControlsDelegate,FBSDKLoginButtonDelegate>
{
    NSDictionary *dictProfileData;
    BOOL isSelected;
    IBOutlet UIButton       *facebookLoginButton;
    NSString *btnTapped;

}
@property (strong, nonatomic) NSString *strStudentCode;
@property (nonatomic,retain)  NSString *btnTapped;
@property (weak, nonatomic) IBOutlet UILabel *lblNextClick;
@property (weak, nonatomic) IBOutlet UIButton *btnAlreadyLogin;

@property (weak, nonatomic) IBOutlet UITextField *mConfirmEmail;
@property (strong, nonatomic) NSDictionary *dictProfileData;
@property (strong, nonatomic) NSString *strEditProfile;
@property (strong, nonatomic) NSString *mTextEntered;
@property (strong, nonatomic) UIPopoverController *popOverController;
@property (strong, nonatomic) NSString *strSalespersonCode;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UITextField *mEmailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPassword;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnTapLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
- (IBAction)btnMenuClick:(id)sender;

- (IBAction)btnTapLoginClicked:(id)sender;

- (IBAction)btnLoginClick:(id)sender;

@end
