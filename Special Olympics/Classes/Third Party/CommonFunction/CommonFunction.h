//
//  CommonFunction.h
//  iAssetTracking
//
//  Created by ; on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 A class that handles Common functions 
 */
@interface CommonFunction : UIViewController<UIAlertViewDelegate>
{
   
}
/** Class Method to show alert
 */
+(void)fnAlert:(NSString*)Title message:(NSString*) msg;
//+(void)fnAlert:(NSString*) Title tag:(NSInteger)tag dict:(NSDictionary*) offerDict;
/** Class Method to check string length of textField
 */
+(BOOL) IsBlank: (NSString *) strInput;
/** Set the value from NSUserDefault */
+(void)setValueInUserDefault:(NSString*)Key value:(NSString*)Value;
/**Get the value from NSUserDefault */

+(NSString *)getValueFromUserDefault:(NSString *)Key;
/**Method to delete value from user default
 */

+(void)deleteValueForKeyFromUserDefault:(NSString *)key;
/** Method to claculate height of label
 */
+ (CGFloat) heightOfLabel :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size;
/**Method to hide side navigation
 */
+(void)callHideViewFromSideBar;
/**Method to show side navigation
 */
+(void)callShowViewFromSideBar;
/**Method to chcek card number
 */
+ (BOOL)validateStringCardNumber:(NSString *) _string;
/**Method to change sttring to date
 */
+(NSString*)stringFromDate:(NSDate*)date;
+ (CGFloat) heightOfOfferCell :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size;
+(BOOL)checkEmail:(NSString*)email;
+(NSString *)stringAfterTriming:(NSString *)str;
+(NSString *)getDeviceName:(NSString *)name;
+(NSString *)getCopyRightText;
@end
