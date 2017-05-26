//
//  Annotation.m
//  iBuddyClient
//
//  Created by Vishwajeet on 03/10/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//




#import "Annotation.h"

@implementation Annotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize type;
@synthesize routeCount;
@synthesize trailLabel;
@synthesize annotationTag;
@synthesize isTrolley;
-(id) initWithLatitude:(float) latitude andLongitude:(float) longitude
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = latitude;
		coordinate.longitude =longitude;
    }
	return self;
}


@end
