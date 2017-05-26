//
//  IBUserPayments.h
//  iBuddyClient
//
//  Created by Anubha on 16/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBUserPayments : UIViewController
{
    IBOutlet UITableViewCell *tblCustomCell;
    NSMutableDictionary *dictUserPayments;
}
/**
 Property of UITableViewCell custom cell
 */
@property (weak, nonatomic) IBOutlet UILabel *lblNoPayements;
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCell;
@property (strong, nonatomic)NSMutableDictionary *dictUserPayments;
@end
