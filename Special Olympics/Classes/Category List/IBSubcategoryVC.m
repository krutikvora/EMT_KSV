//
//  IBSubcategoryVC.m
//  iBuddyClient
//
//  Created by Utkarsha on 11/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBSubcategoryVC.h"
#import "UIImageView+WebCache.h"
#import "IBMerchantListVC.h"

@interface IBSubcategoryVC ()

@end

@implementation IBSubcategoryVC
@synthesize lblTop, tblSubCategory, tblCustomCellSubCategory,arraySubCategory,lblCopyRight;

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
  self.lblCopyRight.text = [CommonFunction getCopyRightText];
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
	self.lblTop.font = [UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark - Button Actions

- (IBAction)btnBackClicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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
	count = [self.arraySubCategory count];
	return count;
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
	static NSString *CellIdentifier = @"categoryCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (kDevice == kIphone) {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBCustomSubCategoryCell" owner:self options:nil];
			cell = tblCustomCellSubCategory;
		}
	}
	else {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBCustomSubCategoryCell_iPad" owner:self options:nil];
			cell = tblCustomCellSubCategory;
		}
	}
	cell.backgroundColor = nil;
	UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
	[imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kSubCategoryImage,[[self.arraySubCategory valueForKey:@"category_image"] objectAtIndex:indexPath.row]]]
	        placeholderImage:[UIImage imageNamed:@"Pic.png"]];

	//Added by UTKARSHA GUPTA to show featured merchants on the top of the list on 26th jun 14
	UIImageView *imgViewFeatured = (UIImageView *)[cell viewWithTag:106];

	UILabel *lblMerchantCount = (UILabel *)[cell viewWithTag:107];

	lblMerchantCount.textColor = [UIColor whiteColor];
	lblMerchantCount.font = [UIFont fontWithName:kFont size:13];
	//new change added by Utkarsha on 1 aug on featured merchants
	if ([[[self.arraySubCategory valueForKey:@"is_golden_egg"] objectAtIndex:indexPath.row] isEqualToString:@"1"] || [[[self.arraySubCategory valueForKey:@"is_featured"] objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
		if ([[[self.arraySubCategory valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
			[imgViewFeatured setImage:NULL];
			lblMerchantCount.text = @"";
		}
		else {
			[imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
			lblMerchantCount.text = [[self.arraySubCategory valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row];
		}
	}
	else {
		[imgViewFeatured setImage:NULL];
		lblMerchantCount.text = @"";
	}


	UILabel *lblCategoryTitle = (UILabel *)[cell viewWithTag:102];
	lblCategoryTitle.text = [[self.arraySubCategory valueForKey:@"category_name"] objectAtIndex:indexPath.row];

	lblCategoryTitle.frame = CGRectMake(lblCategoryTitle.frame.origin.x, lblCategoryTitle.frame.origin.y, lblCategoryTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[self.arraySubCategory valueForKey:@"category_name"] objectAtIndex:indexPath.row] andWidth:lblCategoryTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
	lblCategoryTitle.textColor = [UIColor whiteColor];
	lblCategoryTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
	return cell;
	/*** end ***/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.dictParameters setObject:[[self.arraySubCategory valueForKey:@"id"] objectAtIndex:indexPath.row] forKey:@"categoryId"];
	[self.dictParameters setObject:[[self.arraySubCategory valueForKey:@"is_gru"] objectAtIndex:indexPath.row] forKey:@"isGru"];

	[self.dictParameters setObject:[[self.arraySubCategory valueForKey:@"category_name"] objectAtIndex:indexPath.row] forKey:@"CategoryTitle"];
    [self.dictParameters setObject:[[self.arraySubCategory valueForKey:@"is_event_category"] objectAtIndex:indexPath.row] forKey:@"IsEvent"];

	IBMerchantListVC *objIBOffersVC;
	if (kDevice == kIphone) {
		objIBOffersVC   = [[IBMerchantListVC alloc]initWithNibName:@"IBMerchantListVC" bundle:nil];
	}
	else {
		objIBOffersVC   = [[IBMerchantListVC alloc]initWithNibName:@"IBMerchantListVC_iPad" bundle:nil];
	}
	objIBOffersVC.webServiceParams = self.dictParameters;
	[self.navigationController pushViewController:objIBOffersVC animated:YES];
}

@end
