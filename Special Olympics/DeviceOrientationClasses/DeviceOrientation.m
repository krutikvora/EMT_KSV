//
//  DeviceOrientation.m
//  Rhythm
//
//  Created by iPhone User on 11/12/12.
//  Copyright (c) 2012 iPhone User. All rights reserved.
//

#import "DeviceOrientation.h"


@implementation UINavigationController (autoRotate)

#if defined(__IPHONE_6_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

-(BOOL)shouldAutorotate {
   
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}
#endif

@end
