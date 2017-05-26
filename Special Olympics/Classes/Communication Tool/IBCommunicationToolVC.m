//
//  IBCommunicationToolVC.m
//  iBuddyClient
//
//  Created by Utkarsha on 30/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBCommunicationToolVC.h"

@interface IBCommunicationToolVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBCommunicationToolVC
@synthesize lblTop,lblCopyRight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.

	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
	arrayNotificationHistory = [[NSMutableArray alloc]init];
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
	self.lblTop.font = [UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
	[kAppDelegate showProgressHUD:self.view];
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
	    [self callNotificationService];
	});
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Load fundraisers
- (void)callNotificationService {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
	[dict setValue:userID forKey:@"userId"];
	dispatch_sync(dispatch_get_main_queue(), ^{
	    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:knotificationhistory] completeBlock: ^(NSData *data) {
	        id result = [NSJSONSerialization JSONObjectWithData:data
	                                                    options:kNilOptions error:nil];
	        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	            [CommonFunction fnAlert:@"No Records" message:@"No records found."];
	            arrayNotificationHistory = NULL;
	            [self.tblNotificationHistory reloadData];
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
			}
	        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
	            arrayNotificationHistory = [result valueForKey:@"notifications"];
	            [self.tblNotificationHistory reloadData];
			}
	        else
				[CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
	        [kAppDelegate hideProgressHUD];
		} errorBlock: ^(NSError *error) {
	        if (error.code == NSURLErrorTimedOut) {
	            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
			}
	        else {
	            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
			}
	        [kAppDelegate hideProgressHUD];
		}];
	});
}

#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// #warning Potentially incomplete method implementation.
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//#warning Incomplete method implementation.
	// Return the number of rows in the section.
	int count;
	count = [arrayNotificationHistory count];
	return count;
}

/** This is the method that determines the height of each cell.*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *text = [[arrayNotificationHistory valueForKey:@"comment"] objectAtIndex:indexPath.row];
	CGSize constraint;
    CGSize size;
	if (kDevice == kIphone)
    {
        constraint = CGSizeMake(170, 40000.0f);
	 size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
        size.height = MAX(size.height, 36);
        return size.height + 75;
    }
    else
    {
        constraint = CGSizeMake(478, 40000.0f);
     size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
        size.height = MAX(size.height, 36);
        return size.height + 100;
    }
	

	// Return the size of the current row.
	// 80 is the minimum height! Update accordingly - or else, cells are going to be too thin.
	
}

- (CGSize)frameForText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
	NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
	                                      font, NSFontAttributeName,
	                                      nil];
	CGRect frame = [text boundingRectWithSize:size
	                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
	                               attributes:attributesDictionary
	                                  context:nil];

	// This contains both height and width, but we really care about height.
	return frame.size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"notificationCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (kDevice == kIphone) {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBComToolCell" owner:self options:nil];
			cell = _tblCustomCellNotification;
		}
	}
	else {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBComToolCell_iPad" owner:self options:nil];
			cell = _tblCustomCellNotification;
		}
	}
	cell.backgroundColor = nil;

	// Set Title
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:102];
	NSString *text = [[arrayNotificationHistory valueForKey:@"comment"] objectAtIndex:indexPath.row];
	
	if (kDevice == kIphone) {
        CGSize constraint = CGSizeMake(170, 40000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:constraint lineBreakMode:nil];
        size.height = MAX(size.height, 36);
		lblTitle.frame = CGRectMake(7, 40, 170, size.height+30);
	}
	else {
         CGSize constraint = CGSizeMake(478, 40000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
        size.height = MAX(size.height, 36);
		lblTitle.frame = CGRectMake(14, 62, 478, size.height+40);
	}
	//Set Donation Date
	UILabel *lblDate = (UILabel *)[cell viewWithTag:103];

	//Set Fundraiser Name
	UILabel *lblFundraiserName = (UILabel *)[cell viewWithTag:104];
	lblFundraiserName.text = [[arrayNotificationHistory valueForKey:@"fundraiser"] objectAtIndex:indexPath.row];
	//Set salesperson name
	UILabel *lblSalespersonName = (UILabel *)[cell viewWithTag:105];
	lblSalespersonName.text = [[arrayNotificationHistory valueForKey:@"salesperson"] objectAtIndex:indexPath.row];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *orignalDate   =  [dateFormatter dateFromString:[[arrayNotificationHistory valueForKey:@"date_created"] objectAtIndex:indexPath.row]];
	[dateFormatter setDateFormat:@"MM/dd/yy"];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	NSString *finalString = [dateFormatter stringFromDate:orignalDate];
	lblDate.text = [NSString stringWithFormat:@"%@", finalString];
	lblTitle.text = [[arrayNotificationHistory valueForKey:@"comment"] objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
	/*** end ***/
}


- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

@end
