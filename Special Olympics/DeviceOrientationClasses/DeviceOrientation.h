//
//  DeviceOrientation.h
//  Rhythm
//
//  Created by iPhone User on 11/12/12.
//  Copyright (c) 2012 iPhone User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (autoRotate)

-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
