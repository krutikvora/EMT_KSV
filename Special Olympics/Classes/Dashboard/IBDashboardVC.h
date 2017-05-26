//
//  IBDashboardVC.h
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBChangePasswordVC.h"
#import "IBUserPayments.h"
#import "IBUserProfileVC.h"
#import "IBUserOffersVC.h"
#import "IBUserMerchantsVC.h"
/**
 @class IBDashboardVC
 @inherits UIViewController
 @description Simple class to view fundraisers facebook page.
 */
@interface IBDashboardVC : UIViewController {
    IBChangePasswordVC *objIBChangePasswordVC;
    IBUserPayments *objIBUserPayments;
    IBUserProfileVC *objIBUserProfileVC;
    IBUserOffersVC *objIBUserOffersVC;
    IBUserMerchantsVC *objIBUserMerchantsVC;
    UINavigationController *navController;
    NSMutableDictionary *dictInfo;
}
- (IBAction)btnAboutClicked:(id)sender;
- (IBAction)btnPaymentsClicked:(id)sender;
- (IBAction)btnOffersClicked:(id)sender;
- (IBAction)btnChangePasswordClicked:(id)sender;
- (IBAction)btnLogOutClicked:(id)sender;
- (IBAction)btnEditProfileClicked:(id)sender;
- (IBAction)showMenu:(id)sender ;


@end
