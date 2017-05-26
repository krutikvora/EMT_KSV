//
//  SharedManager.h
//  iBuddyClient
//
//  Created by Anubha on 10/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AddressBook/AddressBook.h>
#import<AddressBookUI/AddressBookUI.h>
typedef void (^completeBlock_p)(NSData *data);
typedef void (^errorBlock_p)(NSError *error);

@interface SharedManager : UIView
{
    completeBlock_p completeBlock_;
    errorBlock_p errorBlock_;
   }


+(SharedManager *) sharedManager;
-(void)setFrames:(NSArray *)labelArray labelValues:(NSArray *)labelValues incrementType:(NSArray *)incrementType kFonts:(NSArray *)kFonts plusfactor:(int)plusFactor initialYValue:(float)initialYValue;
- (void)getFundraisers:(NSString *)timeInterval completeBlock:(completeBlock_p)completeBlock errorBlock:(errorBlock_p)errorBlock;

- (void)postCreditCardData:(NSMutableDictionary *)dictData completeBlock:(completeBlock_p)completeBlock errorBlock:(errorBlock_p)errorBlock;
-(void)subViewAnimation:(UIView *)view;
- (void)removeAnimation:(UIView*)view ;

@end
