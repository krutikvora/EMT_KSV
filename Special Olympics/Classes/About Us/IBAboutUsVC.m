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

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Mission: \"Fire Rescue Funding transforms lives through the joy of sport, every day, everywhere. We are the world's largest sports organization for people with intellectual disabilities: with 4.4 million athletes in 170 countries -- and millions more volunteers and supporters. We are also a global and social movement.\""];
    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"The Compound Giving Effect"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Through the power of sports, people with intellectual disabilities discover new strengths and abilities, skills and success. Our athletes find joy, confidence and fulfillment -- on the playing field and in life. They also inspire people in their communities and elsewhere to open their hearts to a wider world of human talents and potential."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"Supporters thank you for purchasing and utilizing the Fire Rescue Funding “Passport to Savings” Mobile App on behalf of your favorite program. We encourage you to frequent our merchant sponsors and leverage the savings while giving back through the Extra Donation, Plu$1 and renewal trademark features. We make it our goal and promise that you will benefit immensely from this experience and our merchant partners."];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];
    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"\n"];

    strTxtIbUddy=[strTxtIbUddy stringByAppendingString:@"What you appreciate, appreciates!"];
    
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
