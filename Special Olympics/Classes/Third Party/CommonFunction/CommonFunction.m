//
//  CommonFunction.m
//  iAssetTracking
//
//  Created by netsmartz2 on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction


#pragma mark - Alert View Custom Method
+(void)fnAlert:(NSString*) Title message:(NSString*) msg{
	UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:Title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	[myAlertView show];
}
#pragma mark - Empty String Validation Method
+(BOOL) IsBlank: (NSString *) strInput {	
	NSString *tmp = [strInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	if ([tmp length]>0)
		return FALSE;
	else 
	{
		return TRUE;
	}
}
#pragma mark - Method to set & get User defaults

/** set & get the value from NSUserDefault */
+(void)setValueInUserDefault:(NSString*)Key value:(NSString*)Value{
    [[NSUserDefaults standardUserDefaults]setObject:Value forKey:Key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSString *)getValueFromUserDefault:(NSString *)Key{
    return [[NSUserDefaults standardUserDefaults]valueForKey:Key];
}
+(void)deleteValueForKeyFromUserDefault:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark - Height calculate Method
+ (CGFloat) heightOfLabel :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size
{
	CGSize titleSize = {0, 0};
	if (text && ![text isEqualToString:@""]){
		titleSize = [text sizeWithFont:[UIFont fontWithName:name size:size]
                     constrainedToSize:CGSizeMake(width, 2000)
                         lineBreakMode:NSLineBreakByWordWrapping];}
    else{
        titleSize.height=20;
    }
	return ceil(titleSize.height);
}
#pragma mark - Height calculate Method
+ (CGFloat) heightOfOfferCell :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size
{
	CGSize titleSize = {0, 0};
	if (text && ![text isEqualToString:@""]){
		titleSize = [text sizeWithFont:[UIFont fontWithName:name size:size]
                     constrainedToSize:CGSizeMake(width, 999)
                         lineBreakMode:NSLineBreakByWordWrapping];}
    else{
        titleSize.height=20;
    }
	return ceil(titleSize.height);
}
#pragma mark - Show hide Side navigation

+(void)callHideViewFromSideBar
{
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideView"
    //                                                       object:self];
    //[kAppDelegate.objSideBarVC hideView];
    [kAppDelegate hideMenu];

    
}

+(void)callShowViewFromSideBar
{
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowView"
    //                                                       object:self];
    //[kAppDelegate.objSideBarVC showView];
    [kAppDelegate showMenu];

  /*  [kAppDelegate.objSideBarVC setProfileImageUser];
    [kAppDelegate.objSideBarVC setButtonImages:kAppDelegate.objSideBarVC.lastbtnClicked];*/


    
}
#pragma mark - Check String Card Number
/**
 Method to check card number validation
 */

+ (BOOL)validateStringCardNumber:(NSString *) _string {
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[_string length]];
    [_string enumerateSubstringsInRange:NSMakeRange(0, [_string length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    unsigned int odd_sum = 0, even_sum = 0;
    for (int i = 0; i < [reversedString length]; i++) {
        
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            
            odd_sum += digit;
        }
        else {
            even_sum += digit / 5 + ( 2 * digit) % 10;
        }
    }
    return (odd_sum + even_sum) % 10 == 0;
}
#pragma mark Get String from date
/*
 Method to convert date from string on redeem offer page
 */
+(NSString*)stringFromDate:(NSDate*)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EE, MMM dd,  yyyy"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [df stringFromDate:date];
}
+(BOOL)checkEmail:(NSString*)email {
    BOOL validEmail = NO;
    
    if (email.length<=0){
        validEmail=YES;
        return validEmail;
    }
    char *str_Email_Validation_chr = (char *)[email UTF8String];
    
    for (int i=0; i<strlen(str_Email_Validation_chr);i++) {
        
        if(str_Email_Validation_chr[i] == '@') {
            
            for(int j=i+1;j<strlen(str_Email_Validation_chr);j++) {
                
                if(str_Email_Validation_chr[j] != '.') {
                    
                    if(str_Email_Validation_chr[j+1] == '.') {
                        
                        for (int k=j+2; k<strlen(str_Email_Validation_chr); k++) {
                            
                            if (str_Email_Validation_chr[k] != '.' ){
                                validEmail = YES;
                            }
                            else {
                                validEmail = NO;
                            }
                        }
                    }
                }
            }
        }
    }
    return validEmail;
}
+(NSString *)stringAfterTriming:(NSString *)str{
    
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
    
}
+(NSString *)getDeviceName:(NSString *)name{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        name = [NSString stringWithFormat:@"%@iPad",name];
    }else{
        name = [NSString stringWithFormat:@"%@iPhone",name];
    }
    return name;
}
+(NSString *)getCopyRightText
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    NSString *copyRightStr = [NSString stringWithFormat:@"© %@ Fire Rescue Funding, Inc. All Rights Reserved",yearString];
    return copyRightStr;
}

@end
