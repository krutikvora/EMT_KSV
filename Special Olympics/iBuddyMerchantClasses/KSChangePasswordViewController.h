//
//  KSChangePasswordViewController.h
//  iBuddyClub
//
//  Created by Karamjeet Singh on 12/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    /**  When user select setting from tab bar */
    viewForSettingMerchant,

    /**  When user first time reset the new password */
    viewFromChangePasswordMerchant,
       
}ChangePasswordModeMerchant;
@interface KSChangePasswordViewController : UIViewController
@property (nonatomic)ChangePasswordModeMerchant viewMode;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPwd;
@end
