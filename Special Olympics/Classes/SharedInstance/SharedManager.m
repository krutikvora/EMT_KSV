//
//  SharedManager.m
//  iBuddyClient
//
//  Created by Anubha on 10/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

#pragma mark -
#pragma mark Life Cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
static SharedManager *sharedInstance = nil;

+(SharedManager *) sharedManager
{
    if(!sharedInstance || sharedInstance == nil) {
        sharedInstance = [[SharedManager alloc] init];
    }
    return sharedInstance;
}
#pragma mark -
#pragma mark Method to Set Frames
-(void)setFrames:(NSArray *)labelArray labelValues:(NSArray *)labelValues incrementType:(NSArray *)incrementType kFonts:(NSArray *)kFonts plusfactor:(int)plusFactor initialYValue:(float)initialYValue{
    
    int incrementFactor=plusFactor;
    float yNext=initialYValue;
    float heightNext=0;
    float yPrevious=0;
    float heightPrevious=0;
    for (int i=0; i<[labelArray count]; i++) {
        UILabel *label=[labelArray objectAtIndex:i];
        if ([[incrementType objectAtIndex:i]isEqualToString:@"Y"]) {
            yPrevious=yNext;
            heightPrevious=heightNext;
            label.frame=CGRectMake(label.frame.origin.x, yNext+heightNext+incrementFactor, label.frame.size.width,[CommonFunction heightOfLabel:[labelValues objectAtIndex:i] andWidth:label.frame.size.width fontName:[kFonts objectAtIndex:i]  fontSize:label.font.pointSize]);
            yNext=label.frame.origin.y;
            label.text=[labelValues objectAtIndex:i];
            heightNext=label.frame.size.height;
        }
        else{
            
            label.frame=CGRectMake(label.frame.origin.x, yPrevious+heightPrevious+incrementFactor, label.frame.size.width,[CommonFunction heightOfLabel:[labelValues objectAtIndex:i] andWidth:label.frame.size.width fontName:[kFonts objectAtIndex:i]  fontSize:label.font.pointSize]);
            yNext=label.frame.origin.y;
            label.text=[labelValues objectAtIndex:i];
            heightNext=label.frame.size.height;
        }
        label.font=[UIFont fontWithName:[kFonts objectAtIndex:i] size:label.font.pointSize];

    }
}
#pragma mark -
#pragma mark Method to Get Fundraisers List

- (void)getFundraisers:(NSString *)timeInterval completeBlock:(completeBlock_p)completeBlock errorBlock:(errorBlock_p)errorBlock
{
    completeBlock_=[completeBlock copy];
    errorBlock_=[errorBlock copy];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [kAppDelegate showProgressHUD];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kgetfundraisers] completeBlock:^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            [kAppDelegate hideProgressHUD];
            completeBlock_(data);
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"" message:@"No Details exist."];
            [kAppDelegate hideProgressHUD];
            errorBlock_(nil);

        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
            errorBlock_(nil);

        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
            errorBlock_(nil);
        }
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [kAppDelegate hideProgressHUD];
        errorBlock_(error);

    }];
}
#pragma mark -
#pragma mark Method to Post Credit Card
- (void)postCreditCardData:(NSMutableDictionary *)dictData completeBlock:(completeBlock_p)completeBlock errorBlock:(errorBlock_p)errorBlock{
    completeBlock_=[completeBlock copy];
    errorBlock_=[errorBlock copy];
    [kAppDelegate showProgressHUD];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dictData method:khandleplusonedonations] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            completeBlock_(data);
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"Error while processing the payment!" message:[result valueForKey:@"error"]];
            errorBlock_(nil);

        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"Alert!" message:@"Please enter correct information of your credit card."];
            errorBlock_(nil);

        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
            [CommonFunction fnAlert:@"Alert!" message:@"Server error"];
            errorBlock_(nil);
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            errorBlock_(nil);
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
        }
        [kAppDelegate hideProgressHUD];
        errorBlock_(error);

    }];
}

#pragma mark -
#pragma mark Method to Show Pop Up Animation
-(void)subViewAnimation:(UIView *)view
{
    [kAppDelegate hideProgressHUD];
    view.hidden=NO;
    view.alpha = 1.0;
    view.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    void (^animationBlock)(BOOL) = ^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
                         completion:^(BOOL finished){
                             
                             
                             [UIView animateWithDuration:0.1 animations:^{
                                 view.transform = CGAffineTransformMakeScale(1.02, 1.02);
                             }
                                              completion:^(BOOL finished){[UIView animateWithDuration:0.1 animations:^{
                                 view.transform = CGAffineTransformIdentity;
                             }
                                                                                           completion:^(BOOL finished){
                                                                                               view.hidden=NO;
                                                                                               
                                                                                           }];
                                              }];
                         }];
    };
    
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut
                     animations:^{view.alpha = 1.0;
                         view.transform = CGAffineTransformMakeScale((YES ? 1.05 : 1.0), (YES ? 1.05 : 1.0));
                     }
                     completion:(YES ? animationBlock : ^(BOOL finished) {
        
    })];
}
#pragma mark -
#pragma mark Method to Remove Animation
- (void)removeAnimation:(UIView*)view {
    [kAppDelegate hideProgressHUD];
    [UIView animateWithDuration:0.3
					 animations:^{
                         view.alpha = 0;
						 view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
					 }
					 completion:^(BOOL finished){
                         view.hidden = YES;
                         
					 }];
}


@end
