//
//  IBExtraDonationVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 07/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "CustomFormViewController.h"
/**
   @class IBExtraDonationVC
   @inherits CustomFormViewController
   @description Simple class to donate.
 */
@interface IBExtraDonationVC : CustomFormViewController <BSKeyboardControlsDelegate>
{
	NSString *strDonationValue;
}

/**
   @property btnYesToDonation
   @description The button to say yes to donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btnYesToDonation;
/**
   @property btnNoToDonation
   @description The button to say no to donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btnNoToDonation;
/**
   @property btn5dollar
   @description The button to select 5 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn5dollar;
/**
   @property btn10dollar
   @description The button to select 10 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn10dollar;
/**
   @property btn15dollar
   @description The button to select 15 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn15dollar;
/**
   @property btn20dollar
   @description The button to select 20 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn20dollar;
/**
   @property btn50dollar
   @description The button to select 50 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn50dollar;
/**
   @property btn100dollar
   @description The button to select 100 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn100dollar;
/**
   @property btn150dollar
   @description The button to select 150 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn150dollar;
/**
   @property btn200dollar
   @description The button to select 200 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn200dollar;
/**
   @property btn250dollar
   @description The button to select 250 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn250dollar;
/**
   @property btn300dollar
   @description The button to select 300 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn300dollar;
/**
   @property btn500dollar
   @description The button to select 500 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn500dollar;
/**
   @property btn1000dollar
   @description The button to select 1000 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn1000dollar;
/**
   @property btn1500dollar
   @description The button to select 1500 doller donation
 */
@property (weak, nonatomic) IBOutlet UIButton *btn1500dollar;

/**
   @property lblTop
   @description The title of navigation bar
 */

@property (weak, nonatomic) IBOutlet UILabel *lblTop;


@property (weak, nonatomic) IBOutlet UILabel *lbl5Dollar;
@property (weak, nonatomic) IBOutlet UILabel *lbl10Dollar;
@property (weak, nonatomic) IBOutlet UILabel *lbl15Dollar;
@property (weak, nonatomic) IBOutlet UILabel *lbl20Dollar;
/**
   @property txtOtherPrice
   @description The textbox for extra donations
 */
@property (weak, nonatomic) IBOutlet UITextField *txtOtherPrice;
/**
   @property mScrollView
   @description The scrollbar
 */
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
/**
   @property switchDonorOnOff
   @description The switch to on off donations
 */
@property (weak, nonatomic) IBOutlet UISwitch *switchDonorOnOff;
/**
   @property lblFundraiserName
   @description The name of the fundraiser
 */

@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserName;

/**
   @method btnDoneClicked
   @description Calls to finalize the donation and navigates the controller to payment screen
   @param param1 sender
   @returns IBAction
 */
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnYesToDonationClicked:(id)sender;
- (IBAction)btnNoToDonationClicked:(id)sender;
/**
   @method btnBackClicked
   @description Calls to navigate to previous screen
   @param param1 sender
   @returns IBAction
 */
- (IBAction)btnBackAction:(id)sender;
- (IBAction)btn5DollarClicked:(id)sender;
- (IBAction)btn10dollarClicked:(id)sender;
- (IBAction)btn15dollarClicked:(id)sender;
- (IBAction)btn20dollarClicked:(id)sender;
- (IBAction)btn50dollarClicked:(id)sender;
- (IBAction)btn100dollarClicked:(id)sender;
- (IBAction)btn150dollarClicked:(id)sender;
- (IBAction)btn200dollarClicked:(id)sender;
- (IBAction)btn250dollarClicked:(id)sender;
- (IBAction)btn300dollarClicked:(id)sender;
- (IBAction)btn500dollarClicked:(id)sender;
- (IBAction)btn1000dollarClicked:(id)sender;
- (IBAction)btn1500dollarClicked:(id)sender;
/**
   @method changeSwitch
   @description Calls to on off donations
   @param param1 sender
   @returns IBAction
 */
- (IBAction)changeSwitch:(id)sender;
@end
