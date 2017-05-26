//
//  IBQRCodeViewController.h
//  iBuddyClient
//
//  Created by Nishu on 23/12/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBQRCodeViewController : UIViewController
/**
 @property lbl_Top
 @description The title of navigation bar
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_Top;
@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;
@property id <IBOffersVCDelegate> delegate;

@property(nonatomic,strong) NSMutableDictionary *dictDetails;
@end
