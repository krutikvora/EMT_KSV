//
//  IBForgotPasswordVC.h
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBForgotPasswordVC
 @inherits UIViewController
 @description Simple class to send an password notification in mail if user forget's his password.
 */
@interface IBForgotPasswordVC : UIViewController
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)backAction:(id)sender;
/**
 @method submitAction
 @description Calls to submit data
 @param param1 sender
 @returns IBAction
 */
- (IBAction)submitAction:(id)sender;
/**
 @method cancelAction
 @description Calls to cancel action
 @param param1 sender
 @returns IBAction
 */
- (IBAction)cancelAction:(id)sender;
@end
