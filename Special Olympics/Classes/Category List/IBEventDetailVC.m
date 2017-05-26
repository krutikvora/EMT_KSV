//
//  IBEventDetailVC.m
//  iBuddyClient
//
//  Created by Pooja Puri on 12/4/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBEventDetailVC.h"

@interface IBEventDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblVenue;
@property (weak, nonatomic) IBOutlet UILabel *lblDateStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeStatic;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueStatic;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBEventDetailVC
@synthesize eventID,lblCopyRight;
@synthesize strMethod;
#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    //Set Font size and style
    [self setInitialVariables];
    //Get event detail form server
    [self getEventDetail];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidDisappear:(BOOL)animated
{
        [super viewDidDisappear:animated];
        // This is for a bug in MKMapView for iOS6
        [self purgeMapMemory];
}
// This is for a bug in MKMapView for iOS6
// Try to purge some of the memory being allocated by the map
- (void)purgeMapMemory
{
        // Switching map types causes cache purging, so switch to a different map type
        mapView.mapType = MKMapTypeStandard;
        [mapView removeFromSuperview];
        mapView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Set Initial Variables
-(void) setInitialVariables {
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
    mapView=[[MKMapView alloc]init];
    if (kDevice==kIphone) {
        mapView.frame=CGRectMake(0, 42, 320, 161);
    }
    else{
        mapView.frame=CGRectMake(0, 43, 768, 320);
    }
    [self.view addSubview:mapView];
    self.lblDateStatic.font = [UIFont fontWithName:kFont size:16];
    self.lblTimeStatic.font = [UIFont fontWithName:kFont size:16];
    self.lblVenueStatic.font = [UIFont fontWithName:kFont size:16];
    self.lblEventName.font = [UIFont fontWithName:kFont size:16];
    
    self.lblDate.font = [UIFont fontWithName:kFont2 size:14];
    self.lblTime.font = [UIFont fontWithName:kFont2 size:14];
    self.lblVenue.font = [UIFont fontWithName:kFont2 size:14];
    self.lblDescription.font = [UIFont fontWithName:kFont2 size:14];
    self.lblScreenTitle.font=[UIFont fontWithName:kFont size:self.lblScreenTitle.font.pointSize];
    mapView.layer.borderColor = [[UIColor colorWithRed:15.0/255.0 green:125.0/255.0 blue:126.0/255.0 alpha:1] CGColor];
    
    mapView.layer.borderWidth = 3.0;
}
#pragma mark -Get Webservice Data

-(void) getEventDetail {
    
    [kAppDelegate showProgressHUD:self.view];
    NSString *strMethodName;
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    if ([self.strMethod isEqualToString:@"1"]) {
        strMethodName = kGetMerchantEventDetail;
        [dictParams setValue:[NSNumber numberWithInt:self.eventID] forKey:@"merchantEventId"];
    }
    else
    {
        strMethodName = kGetEventDetail;
        [dictParams setValue:[NSNumber numberWithInt:self.eventID] forKey:@"eventId"];
        
    }
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dictParams method:strMethodName] completeBlock:^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
          
            [self setEventDetail:[result valueForKey:@"eventDetail"]];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
        [kAppDelegate hideProgressHUD];
    }];
}

//To set event detail field
-(void) setEventDetail:(NSDictionary *) dictResponse {

    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:self.lblEventName,self.lblDescription,self.lblDateStatic,self.lblDate,self.lblTimeStatic,self.lblTime,self.lblVenueStatic,self.lblVenue,nil];
    
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:[dictResponse valueForKey:@"title"],[dictResponse valueForKey:@"description"],@"Date:",[dictResponse valueForKey:@"event_date"],@"Time:",[NSString stringWithFormat:@"%@ to %@",[dictResponse valueForKey:@"event_start_time"],[dictResponse valueForKey:@"event_end_time"]],@"Venue:",[NSString stringWithFormat:@"%@,%@,%@",[dictResponse valueForKey:@"location"],[dictResponse valueForKey:@"city_alias"],[dictResponse valueForKey:@"state"]], nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:kFont,kFont2,kFont,kFont2,kFont,kFont2,kFont,kFont2, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"Y",@"Y",@"X",@"Y",@"X",@"Y",@"X", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:10 initialYValue:0];
    
    //To show pin on map
    [self setMap:dictResponse];
    
    self.scrollView.contentSize = CGSizeMake(320, self.lblVenue.frame.origin.y + 100);
}
#pragma mark Set Map View
-(void) setMap:(NSDictionary *) dictResponse {
    Annotation * annotation = [[Annotation alloc] initWithLatitude:[[dictResponse valueForKey:@"latitude"]floatValue] andLongitude:[[dictResponse valueForKey:@"longitude"]floatValue]];
    annotation.type  = @"Source";
    
    NSString *pinAddress;
        pinAddress = [dictResponse valueForKey:@"title"];
        pinAddress=[pinAddress stringByAppendingString:@","];
        pinAddress =[pinAddress stringByAppendingString:[dictResponse valueForKey:@"location"]];
        pinAddress=[pinAddress stringByAppendingString:@","];
        pinAddress=[pinAddress stringByAppendingString:[dictResponse valueForKey:@"city_alias"]];
        pinAddress=[pinAddress stringByAppendingString:@","];
        pinAddress=[pinAddress stringByAppendingString:[dictResponse valueForKey:@"state"]];
    
    annotation.title = pinAddress;
    [mapView addAnnotation:annotation];
    [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[dictResponse valueForKey:@"latitude"]floatValue], [[dictResponse valueForKey:@"longitude"]floatValue]), MKCoordinateSpanMake(10, 10))];
    [self setCenterCoordinate:CLLocationCoordinate2DMake([[dictResponse valueForKey:@"latitude"]floatValue], [[dictResponse valueForKey:@"longitude"]floatValue]) zoomLevel:17 animated:YES];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*mapView.frame.size.width/256);
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}



#pragma mark - Button Actions

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
