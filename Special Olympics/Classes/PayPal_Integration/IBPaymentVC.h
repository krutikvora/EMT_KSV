//
//  IBPaymentVC.h
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
/**
 @class IBPaymentVC
 @inherits UIViewController
 @description Simple class to perform payment
 */

@interface IBPaymentVC : UIViewController<BSKeyboardControlsDelegate>
{
    NSString *btnSelected;
    float kDynamicViewPlusHeightTextField;
    float kDynamicViewPlusHeightControls;
    IBOutlet UIButton *btnArrowDown;
    IBOutlet UIButton *btnArrowUp;
    NSString *donationValue;
    BOOL ambassdorClicked;
     NSString *donationAmount;
    BOOL isDonation;
    BOOL isTextfieldSelected;
    
}

- (IBAction)btnNextClicked:(id)sender;
- (IBAction)btn5Dollarclicked:(id)sender;
- (IBAction)btn20dollarClicked:(id)sender;
- (IBAction)btnDonationOFFClicked:(id)sender;
- (IBAction)btn10dollarclicked:(id)sender;
- (IBAction)btnPaypalClicked:(id)sender;
- (IBAction)btnCreditCardClicked:(id)sender;
- (IBAction)btnDonationONClicked:(id)sender;
/**
 @method btnRedemptionCodeClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnRedemptionCodeClicked:(id)sender;
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;

@property(nonatomic, strong) NSString *strClassTypeForPaymentScreen;
@property(nonatomic, strong) NSString *donationAmount;
@end
