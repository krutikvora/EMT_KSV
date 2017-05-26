//
//  IBReferFriendVC.h
//  iBuddyClient
//
//  Created by Anubha on 17/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>

/**
 @class IBReferFriendVC
 @inherits UIViewController
 @description Simple class to refer offers to friends via facebook, twitter, messages or Email.
 */
@interface IBReferFriendVC : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
/**
 @property arrayOfAccounts
 @description The array Of Accounts
 */
@property(nonatomic,strong) NSArray *arrayOfAccounts;
/**
 @method btnMessageClicked
 @description Calls to refer a friend through messages
 @param param1 sender
 @returns IBAction
 */
-(IBAction)btnMessageClicked:(id)sender;
/**
 @method btnFacebookClicked
 @description Calls to refer a friend through facebook
 @param param1 sender
 @returns IBAction
 */
-(IBAction)btnFacebookClicked:(id)sender;
/**
 @method btnTwitterClicked
 @description Calls to refer a friend through twitter
 @param param1 sender
 @returns IBAction
 */
-(IBAction)btnTwitterClicked:(id)sender;
/**
 @method btnEmailClicked
 @description Calls to refer a friend through email
 @param param1 sender
 @returns IBAction
 */
-(IBAction)btnEmailClicked:(id)sender;
/**
 @method btnCancelClicked
 @description Calls to cancel refer a friend
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnCancelClicked:(id)sender;
/**
 @method btnDoneClicked
 @description Calls to navigate to next screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnDoneClicked:(id)sender;
@end
