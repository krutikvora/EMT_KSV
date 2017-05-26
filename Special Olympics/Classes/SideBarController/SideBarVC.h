//
//  SideBarVC.h
//  iBuddyClient
//
//  Created by Anubha on 14/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBPaymentVC.h"
#import "IBAboutUsVC.h"
#import "IBSideBarDonationViewController.h"
/**
 @class SideBarVC
 @inherits UIViewController
 @description Simple class to view sidebar including different features of the APP
 */

@interface SideBarVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    BOOL  checkShowhideView;
    NSArray *arrMenuWithOutLogin;
    NSArray *arrMenuWithLogin;
    NSArray *arrIconMenuWithOutLogin;
    NSArray *arrIconMenuWithLogin;

}
@property (weak, nonatomic) IBOutlet UIButton *btnMyOffers;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnCommTool;
@property (weak, nonatomic) UIButton *lastbtnClicked;
@property (strong, nonatomic) IBOutlet UIView *viewFundraiserLogo;
@property (strong, nonatomic) IBOutlet UIImageView *fundraiserImgView;
@property (strong, nonatomic) IBOutlet UILabel *fundraiserName;
@property (strong, nonatomic) IBOutlet UIImageView *fundraiserNameBgIngView;
@property (weak, nonatomic) IBOutlet UIButton *btnExtraDonation;
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;

/**
 @method btnMyCardClicked
 @description Calls to navigate to MyCard screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnMyCardClicked:(id)sender;
/**
 @method btnOffersClicked
 @description Calls to navigate to Offers screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnOffersClicked:(id)sender;
/**
 @method btnJoinClicked
 @description Calls to navigate to Join screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnJoinClicked:(id)sender;
/**
 @method btnProfileClicked
 @description Calls to navigate to Profile screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnProfileClicked:(id)sender;
/**
 @method btnAboutUSClicked
 @description Calls to navigate to About US screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnAboutUSClicked:(id)sender;
/**
 @method btnGiftAppClicked
 @description Calls to navigate to GiftApp screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnGiftAppClicked:(id)sender;
/**
 @method btnGratitudeClicked
 @description Calls to navigate to Gratitude screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnGratitudeClicked:(id)sender;
/**
 @method btnReferFriendClicked
 @description Calls to navigate to Refer Friend screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnReferFriendClicked:(id)sender;
/**
 @method btnCommunicationToolClicked
 @description Calls to navigate to CommunicationTool screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnCommunicationToolClicked:(id)sender;
/**
 @method setButtonImages
 @description Calls to navigate to previous screen
 @param param1 UIButton
 @returns void
 */

- (void)setButtonImages:(UIButton*)button;
/**
 @method hideView
 @description Calls to hide the side bar
 @returns void
 */
-(void)hideView;
/**
 @method showView
 @description Calls to show the side bar
 @returns void
 */
-(void)showView;
/**
 @method setProfileImageUser
 @description Calls to set profile image of the user on sidebar
 @returns void
 */
-(void)setProfileImageUser;
/**
 @method callPaymentClass
 @description Calls to post data related to payment on server
 @returns void
 */
-(void)callPaymentClass;
- (IBAction)btnAboutButtonsUsageClicked:(id)sender;

@end
