//
//  IBLoginVC.h
//  iBuddyClient
//
//  Created by Anubha on 06/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UIKit/UIKit.h>
/**
 @class IBLoginVC
 @inherits UIViewController
 @description Simple class to login into APP with register, remember me and forgot password features.
 */
@interface IBLoginVC : UIViewController<FBSDKLoginButtonDelegate>
{
    NSMutableDictionary *dictLoginInfo;
    NSMutableDictionary *dictResult;
    IBOutlet FBSDKLoginButton       *facebookLoginButton;

}
@property(nonatomic,strong)NSString *classType;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@end
