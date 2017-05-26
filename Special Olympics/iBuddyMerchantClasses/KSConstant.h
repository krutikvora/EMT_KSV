//
//  KSConstant.h
//  iBuddyClub
//
//  Created by Karamjeet Singh on 11/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#ifndef iBuddyClub_KSConstant_h
#define iBuddyClub_KSConstant_h


/** Variable ---*/
//#define kAppDelegate ((KSAppDelegate *)[[UIApplication sharedApplication] delegate])

/**- WebServic & Method ----*/
//#define kURL @"http://ibuddyclub.com/webservice/"
#define kLoginMerchant @"merchantlogin"
#define kChangePasswordMerchant @"changemerchantpassword"
#define koffersbymerchant @"offersbymerchant"
#define kuseravailableoffers @"useravailableoffers"
#define kredeemofferMerchant @"redeemoffer"
#define kSkip @"skip"
#define kForgotPasswordMerchant @"merchantforgotpwd"
#define kMerchantDetailByIdEmail @"merchantDetailByIdEmail"
/**- Strings ---*/
//#define kMerchantURL @"http://ibuddyclub.netsmartz.us/media/merchantImages/thumbnail/"
#define kMerchantURL @"http://ibuddyclub.com/media/merchantImages/thumbnail/"

//--> UserDefault
#define kMerchantId @"merchantId"

/**- NSlog macro ---*/
#define DEBUG_MODE

#ifdef DEBUG_MODE
#define KaramNSLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define KaramNSLog( s, ... )
#endif

#endif
