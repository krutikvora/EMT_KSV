//
//  IBAboutUsVC.m
//  iBuddyClient
//
//  Created by Anubha on 28/06/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBAboutUsVC.h"

@interface IBAboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBAboutUsVC
@synthesize lblCopyRight;
#pragma mark LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setInitialVariables];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayoutForiOS7];
    //To test iAds
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:35.018217 longitude:-80.9318332];
//    kAppDelegate.checkToStopMethodCall = FALSE;
//    [kAppDelegate fetchAdslocation:loc error:nil];

    //[self setInitialVariables];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setLbl_Top:nil];
    [self setTxtViewAboutUs:nil];
    [self setLblWebsiteText:nil];
    [super viewDidUnload];
}
#pragma mark Set Initial Variables

-(void)setInitialVariables
{
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
    _lbl_Top.font=[UIFont fontWithName:kFont size:_lbl_Top.font.pointSize];
    _txtViewAboutUs.font=[UIFont fontWithName:kFont size:_txtViewAboutUs.font.pointSize];
    _lblWebsiteText.font=[UIFont fontWithName:kFont size:_lblWebsiteText.font.pointSize];
    self.txtViewAboutUs.text=self.txtViewAboutUs.text;

    NSString *strTxtIbUddy=@"";
    // strTxtIbUddy=[NSString stringWithFormat:@"%@ \"\%@\"\%@\"\%@\"\%@",@"By purchasing the iBuddyClub Smart Phone App or Smart Card,",@"The Customer",@" gets a significant ",@"Return On Their Investment",@" and will be contributing and partnering with the community for years to come. Some of the benefits of owning the iBuddyClub Smart Phone App or Smart Card are below."];
    
    //  By purchasing the My Cherry Creek "Passport to Savings" Mobile Application,(powered by iBC, Inc.) you get a significant "Return On Their Investment" and will be contributing and partnering with the community for years to come.
    
    // strTxtIbUddy=[NSString stringWithFormat:@"%@ \"\%@\"\%@\"\%@\"\%@",@"By purchasing the Cherry Creek Mobile App or Smart Card,",@"The Customer",@" gets a significant ",@"Return On Their Investment",@" and will be contributing and partnering with the community for years to come. Some of the benefits of owning the Cherry Creek Mobile App or Smart Card are below."];
//    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:  @"Vision: Dedicated to Excellence"];
//    
//    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
//    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@" Along our goal to protect and serve those who do the same for us, The FireRescueFunding.org Organization strives to:"];
    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Provide for the good and well being of all First Responders who unselfishly give assistance to those in times of need without recognition or personal self gain."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Create camaraderie and fellowship among all First Responders from all of the First Responder agencies nationally."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Render assistance and family support to First Responders who are injured or give the ultimate sacrifice while performing their duties as a First Responder and unselfishly helping others."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Recognize and act on the needs for all First Responders and to become the voice of all of the great citizens of our country who give their time, both professionally and as volunteers, who help those in need."];
    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    
    self.txtViewAboutUs.text=strTxtIbUddy;
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        btnArrowUp.hidden=TRUE;
        btnArrowDown.hidden=FALSE;
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=TRUE;
    }
    else if (scrollOffset > 0&&scrollOffset + scrollViewHeight != scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=FALSE;
    }
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

@end
