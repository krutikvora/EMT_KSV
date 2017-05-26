//
//  IBUserOfferSecription.h
//  iBuddyClient
//
//  Created by Anubha on 17/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBUserOfferSecription : UIViewController
@property (nonatomic, retain)NSMutableArray *dict_OfferDetail;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)btnBackAction:(id)sender;
@end
