//
//  IBCreditCardPaymentVC.h
//  iBuddyClient
//
//  Created by Anubha on 15/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "CustomFormViewController.h"
/**
 @class IBCreditCardPaymentVC
 @inherits UIViewController
 @description Simple class to perform payment through credit card.
 */
@interface IBCreditCardPaymentVC : CustomFormViewController<BSKeyboardControlsDelegate,UIPopoverControllerDelegate>
{
    NSMutableArray *arrTypeOfCards;
    NSString *strCardType;
    UIPopoverController *popView;
    NSMutableDictionary *dictInfo;
    BOOL isCardLength;
    BOOL isCardNumeric;
    NSString *strIsAnonymouDonation;
}
@property(nonatomic,strong)IBOutlet UIButton *btnCancelRegistration;

@property BOOL isExtraDonation;
/**
 @property dictDonationOrNormalInfo
 @description The name of the dictionary to donation information
 */
@property(nonatomic,strong)NSMutableDictionary *dictDonationOrNormalInfo;
/**
 @method btnSubmitClicked
 @description Calls to submit the payment info
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSubmitClicked:(id)sender;
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackAction:(id)sender;
/**
 @method btnAgreeClicked
 @description Calls to select the checkbox to show user has agreed on all terms and conditions
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnAgreeClicked:(id)sender;
/**
 @method btnCheckBoxClicked
 @description Calls to select payment mode
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnCheckBoxClicked:(id)sender;

@end
