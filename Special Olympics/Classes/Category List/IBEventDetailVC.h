//
//  IBEventDetailVC.h
//  iBuddyClient
//
//  Created by Pooja Puri on 12/4/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBEventDetailVC
 @inherits UIViewController
 @description This class represents the detail description about the events.
 */
@interface IBEventDetailVC : UIViewController{
    MKMapView *mapView;

}
@property(strong,nonatomic) NSString *strMethod;

/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)backBtnClicked:(id)sender;
@property int eventID;
@end
