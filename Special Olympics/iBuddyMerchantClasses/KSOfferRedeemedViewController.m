//
//  KSOfferRedeemedViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 15/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSOfferRedeemedViewController.h"
#import "CommonFunction.h"
@interface KSOfferRedeemedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbl_Offervalue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_screenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDis;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDicval;
@property (weak, nonatomic) IBOutlet UIButton *btn_Done;
@property (weak, nonatomic) IBOutlet UILabel *lbl_offerDicVal2;

@end

@implementation KSOfferRedeemedViewController
@synthesize str_OfferValue;
#pragma mark -
#pragma mark - View Life Cycle
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setInitialLabels];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setLbl_Offervalue:nil];
    [self setLbl_offerDicVal2:nil];
    [self setScrlView:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark-
#pragma mark - Private Methods

#pragma mark-
#pragma mark - Buttons Action


- (IBAction)doneAction:(id)sender {
    
   NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
     [self.navigationController popToViewController:[arrViewControllers objectAtIndex:1] animated:YES];
}
#pragma mark-
#pragma mark - Initial Methods
-(void)setInitialLabels
{
    self.lbl_screenTitle.font=[UIFont fontWithName:kFont size:self.lbl_screenTitle.font.pointSize];
    self.lbl_Offervalue.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_OfferDis.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_OfferDicval.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lbl_offerDicVal2.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btn_Done.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    
    /*if (kDevice==kIphone) {
        self.lbl_OfferDis.frame=CGRectMake(self.lbl_OfferDis.frame.origin.x, self.lbl_OfferDis.frame.origin.y, self.lbl_OfferDis.frame.size.width, [Utility heightOfLabel:self.lbl_OfferDis.text andWidth:self.lbl_OfferDis.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSize]);
        self.lbl_offerDicVal2.text=str_OfferValue;
        self.lbl_offerDicVal2.frame=CGRectMake(self.lbl_offerDicVal2.frame.origin.x, self.lbl_OfferDis.frame.origin.y+self.lbl_OfferDis.frame.size.height, self.lbl_offerDicVal2.frame.size.width, [Utility heightOfLabel:str_OfferValue andWidth:self.lbl_offerDicVal2.frame.size.width fontName:kFont  fontSize:kFontSize]);
        
        float height=self.lbl_offerDicVal2.frame.origin.y+self.lbl_offerDicVal2.frame.size.height+5;
        self.btn_Done.frame=CGRectMake(self.btn_Done.frame.origin.x, height, self.btn_Done.frame.size.width, self.btn_Done.frame.size.height);
        self.scrlView.contentSize=CGSizeMake(0, self.btn_Done.frame.origin.y+self.btn_Done.frame.size.height+5);
           }
    else{
       self.lbl_OfferDis.frame=CGRectMake(self.lbl_OfferDis.frame.origin.x, self.lbl_OfferDis.frame.origin.y, self.lbl_OfferDis.frame.size.width, [Utility heightOfLabel:self.lbl_OfferDis.text andWidth:self.lbl_OfferDis.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSize]);
        self.lbl_Offervalue.text=str_OfferValue;

       self.lbl_Offervalue.frame=CGRectMake(self.lbl_Offervalue.frame.origin.x, self.lbl_OfferDis.frame.origin.y+self.lbl_OfferDis.frame.size.height+10, self.lbl_Offervalue.frame.size.width, [Utility heightOfLabel:str_OfferValue andWidth:self.lbl_Offervalue.frame.size.width fontName:kFont  fontSize:kFontSize1]);
       self.btn_Done.frame=CGRectMake(self.btn_Done.frame.origin.x, self.lbl_Offervalue.frame.origin.y+self.lbl_Offervalue.frame.size.height+10, self.btn_Done.frame.size.width, self.btn_Done.frame.size.height);
    }*/
    
    self.lbl_OfferDis.frame=CGRectMake(self.lbl_OfferDis.frame.origin.x, self.lbl_OfferDis.frame.origin.y, self.lbl_OfferDis.frame.size.width, [CommonFunction heightOfLabel:self.lbl_OfferDis.text andWidth:self.lbl_OfferDis.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSize]);
    self.lbl_Offervalue.text=str_OfferValue;
    self.lbl_Offervalue.frame=CGRectMake(self.lbl_Offervalue.frame.origin.x, self.lbl_OfferDis.frame.origin.y+self.lbl_OfferDis.frame.size.height+5, self.lbl_Offervalue.frame.size.width,[CommonFunction heightOfLabel:str_OfferValue andWidth:self.lbl_Offervalue.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSize]);
    
    self.btn_Done.frame=CGRectMake(self.btn_Done.frame.origin.x, self.lbl_Offervalue.frame.origin.y+self.lbl_Offervalue.frame.size.height+5, self.btn_Done.frame.size.width, self.btn_Done.frame.size.height);
    self.scrlView.contentSize=CGSizeMake(0, self.btn_Done.frame.origin.y+self.btn_Done.frame.size.height+5);
    
}
@end
