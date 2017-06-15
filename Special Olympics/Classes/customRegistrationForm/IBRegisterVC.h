//
//  IBRegisterVC.h
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "CustomFormViewController.h"
#import "UILabel+UILabel_highlightColor.h"
#import "SideBarVC.h"
/**
   @class IBRegisterVC
   @inherits CustomFormViewController
   @description Simple class to register users
 */
@interface IBRegisterVC : CustomFormViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, BSKeyboardControlsDelegate, UIPopoverControllerDelegate>
{
    SideBarVC *objSideBarVC;
	NSMutableArray *mDictStates;
	NSMutableArray *mDictCities;
	int mSelectedStateId;
	int mSelectedCityID;
	NSString *selectedAgeGroup;
	NSString *checkSelectedAgeGroup;
	UIPopoverController *popOverController;
	UIPopoverController *popView;
	NSString *selectedState;
	IBOutlet UITableView *citiesList;
	IBOutlet UITableView *stateList;
	NSString *strStateCityTableType;
	NSDictionary *dictProfileData;
	NSString *strDetailRegistration;
	BOOL isNameLengthCorrect;
	NSString *strController;
	UITextField *tempTextField;
}
@property BOOL isNewUser;
@property (strong,nonatomic)SideBarVC *objSideBarVC;
@property (strong, nonatomic) NSString *strController;
@property (strong, nonatomic) NSString *strDetailRegistration;
@property (strong, nonatomic) NSDictionary *dictProfileData;
@property (strong, nonatomic) NSString *strEditProfile;
@property (strong, nonatomic) NSString *mTextEntered;
@property (strong, nonatomic) UIPopoverController *popOverController;
@property (strong, nonatomic) NSString *strSalespersonCode;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) NSString *strStudentCode;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;
@property (weak, nonatomic) IBOutlet UILabel *lblNextbutton;

/**
   @property UITextFields
   @description The UITextField required to fill the registration form
 */
@property (strong, nonatomic) IBOutlet UITextField *mFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mEmailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *mLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *mPhoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *mMonth;
@property (strong, nonatomic) IBOutlet UITextField *mDate;
@property (strong, nonatomic) IBOutlet UITextField *mDOB;
@property (strong, nonatomic) IBOutlet UITextField *mState;
@property (strong, nonatomic) IBOutlet UITextField *mCity;
@property (weak, nonatomic) IBOutlet UITextField *mAgeGroupTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnTapLogin;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmEmail;
@property (weak, nonatomic) IBOutlet UITextField *mPassword;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPassword;
/**
   @property UILabel
   @description The UILabel required to fill the registration form
 */
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPwd;
- (IBAction)btnTapLoginClicked:(id)sender;

@end
