//
//  IBCommunicationToolVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 30/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBCommunicationToolVC : UIViewController
{
	NSMutableArray *arrayNotificationHistory;
	NSMutableArray *arrayDateHistory;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UITableViewCell *tblCustomCellNotification;
@property (strong, nonatomic) IBOutlet UITableView *tblNotificationHistory;

- (void)callNotificationService;

@end
