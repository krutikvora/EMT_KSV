//
//  IBUserProfileVC.h
//  iBuddyClient
//
//  Created by Anubha on 16/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBUserProfileVC : UIViewController
{
   NSMutableDictionary *dictUserProfileInfo;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic)NSMutableDictionary *dictUserProfileInfo;
@end
