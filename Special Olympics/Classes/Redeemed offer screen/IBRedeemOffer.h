//
//  IBRedeemOffer.h
//  iBuddyClient
//
//  Created by Anubha on 15/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBQRCodeViewController.h"
/**
 @class IBRedeemOffer
 @inherits UIViewController
 @description Simple class to redeem.
 */
@interface IBRedeemOffer : UIViewController<UIAlertViewDelegate>{
   NSTimer *changingTimer;
}
@property BOOL isDisappear;
@property id <IBOffersVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (nonatomic, retain)NSMutableDictionary *dict_MerchantInfo;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;

@end
