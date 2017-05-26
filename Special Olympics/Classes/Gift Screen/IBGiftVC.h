//
//  IBGiftVC.h
//  iBuddyClient
//
//  Created by Anubha on 15/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBSalepersonSearchVC
 @inherits UIViewController
 @description Simple class to gift this App to your family or friends.
 */
@interface IBGiftVC : UIViewController
/**
 @method btnEmailClicked
 @description Calls to gift this App to your family or friends through email
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnEmailClicked:(id)sender;
/**
 @method btnPostalClicked
 @description Calls to gift this App to your family or friends through postal code
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnPostalClicked:(id)sender;

@end
