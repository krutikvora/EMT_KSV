//
//  Annotation.h
//  iBuddyClient
//
//  Created by Vishwajeet on 03/10/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
    NSString                *title;
    NSString                *subtitle;
    CLLocationCoordinate2D  coordinate;
    NSString                *type;
    NSString                *trailLabel;
    int                      routeCount;
}
    @property(nonatomic,assign)int isTrolley;
@property (nonatomic, assign) int                       routeCount;
@property (nonatomic, copy)   NSString                  *title;
@property (nonatomic, copy)   NSString                  *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D    coordinate;
@property (nonatomic, copy)   NSString                  *type;
@property (nonatomic, strong) NSString                  *trailLabel;
@property int annotationTag;

-(id) initWithLatitude: (float) latitude andLongitude:(float) longitude;
@end
