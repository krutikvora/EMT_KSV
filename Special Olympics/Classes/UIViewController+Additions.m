//
//  UIViewController+Additions.m
//  iBuddyClient
//
//  Created by Utkarsha on 11/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

-(void)setLayoutForiOS7
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets=NO;
	}
}
@end
