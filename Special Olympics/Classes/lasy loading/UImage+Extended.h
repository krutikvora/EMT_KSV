//
//  UImage+Extended.h
//  Puteem
//
//  Created by Abhimanu on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extended)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
//- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect;
@end
