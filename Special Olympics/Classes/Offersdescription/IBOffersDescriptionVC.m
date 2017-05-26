//
//  IBOffersDescriptionVC.m
//  iBuddyClient
//
//  Created by Anubha on 13/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBOffersDescriptionVC.h"

#define kRedeemOfferAlertTag 2323
@interface IBOffersDescriptionVC ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDiscription;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDicount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoOfUses;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ValOfDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ValNoUses;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxCount;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxCountValue;

@property (weak, nonatomic) IBOutlet UIImageView *img_OfferImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotPaid;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@property (weak, nonatomic) IBOutlet UIButton *btnRedeemEntertainment;

@property (weak, nonatomic) IBOutlet UIButton *btnRedeem;
- (IBAction)btnRedeemClicked:(id)sender;

@end

@implementation IBOffersDescriptionVC
@synthesize dict_OfferDetail;
@synthesize dict_MerchantList,lblCopyRight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];
    [self setInitialLabels];
    [self setRandomFrames];
    [self displayData];
    [self saveViewedOffer];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload
{
    [self setLbl_OfferTitle:nil];
    [self setLbl_OfferDiscription:nil];
    [self setImg_OfferImg:nil];
    [self setScrlView:nil];
    [self setLbl_OfferDicount:nil];
    [self setLbl_NoOfUses:nil];
    [self setLbl_ValOfDiscount:nil];
    [self setLbl_ValNoUses:nil];
    [self setLblMaxCount:nil];
    [self setLblMaxCountValue:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark -
#pragma mark Custom Methods
-(void)saveViewedOffer
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [dict setValue:[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerId"] forKey:@"offerId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kSaveRedeemedOffers] completeBlock: ^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        NSLog(@"%@", result);

        [kAppDelegate hideProgressHUD];
    } errorBlock: ^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
         //   [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else {
         //   [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [kAppDelegate hideProgressHUD];
    }];
}
/*
 Method to set initial labels
 */
-(void)setInitialLabels
{
    
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:_lbl_ScreenTitle.font.pointSize];
    self.lbl_OfferDicount.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_NoOfUses.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_ValOfDiscount.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_ValNoUses.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_OfferTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_OfferDiscription.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.btnRedeem.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.btnRedeemEntertainment.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];

    self.lblMaxCountValue.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lblMaxCount.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
}

/**-
 @Method    -  displayData -> Display Offer details Data
 Title, Discription, image, Offere Discount & availability of offer.
 */


-(void)displayData{
  //  [kAppDelegate showProgressHUD];
    self.activityIndicator.hidden=FALSE;
    [self.activityIndicator startAnimating];

//    if([[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"is_entertaiment_offer"] boolValue]== TRUE)
//    {
//        [webOfferDetails loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"webViewUrl"]]]];
//        self.scrlView.hidden=YES;
//        self.activityIndicator.hidden=TRUE;
//        [self.activityIndicator stopAnimating];
//        if ((![[[self.dict_OfferDetail valueForKey:@"offersList"]valueForKey:@"availableCount"]isEqualToString:@"0"]&& [[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]&&([[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"])) ||([[[self.dict_OfferDetail valueForKey:@"offersList"]valueForKey:@"availableCount"]isEqualToString:@"-1"]&& [[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"])) {
//           // _lblNotPaid.hidden=YES;
//           // self.btnRedeem.frame=CGRectMake(self.btnRedeem.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.btnRedeem.frame.size.width,self.btnRedeem.frame.size.height);
//            self.btnRedeemEntertainment.hidden=FALSE;
//           // self.scrlView.contentSize=CGSizeMake(0, self.btnRedeem.frame.origin.y+self.btnRedeem.frame.size.height+5);
//            
//        }
//        else
//        {
//            self.webOfferDetails.frame=CGRectMake(self.webOfferDetails.frame.origin.x, self.webOfferDetails.frame.origin.y, self.webOfferDetails.frame.size.width, self.webOfferDetails.frame.size.height+40);
//        }
//    }
//    else
//    {
       // vwEntertainment.hidden=YES;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerImage"]]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image;//=[[UIImage alloc]init];
                image = [UIImage imageWithData: data];
                float kWidth;
                if ( kDevice==kIphone ) {
                    kWidth=240;
                }
                else{
                    kWidth=435;
                }
                if (image.size.width>kWidth) {
                    image=[self imageWithImage:image scaledToWidth:kWidth];
                    self.img_OfferImg.frame=CGRectMake((self.scrlView.frame.size.width-image.size.width)/2, self.img_OfferImg.frame.origin.y,image.size.width,image.size.height);
                    self.img_OfferImg.image=image;
                    [self setRandomFrames];
                }
                else{
                    
                    self.img_OfferImg.frame=CGRectMake((self.scrlView.frame.size.width-image.size.width)/2, self.img_OfferImg.frame.origin.y,image.size.width,image.size.height);
                    self.img_OfferImg.image=image;
                    [self setRandomFrames];
                }
            });
        });
   // }

}
/*
 Method to set Raandom description view
 */
-(void)setRandomFrames
{
    
  /*  self.lbl_OfferTitle.frame=CGRectMake(self.lbl_OfferTitle.frame.origin.x, self.lbl_OfferTitle.frame.origin.y, self.lbl_OfferTitle.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerTitle"]] andWidth:self.lbl_OfferTitle.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
    
    self.lbl_OfferTitle.numberOfLines=0;
    
    self.lbl_OfferDicount.frame=CGRectMake(self.lbl_OfferDicount.frame.origin.x, self.lbl_OfferTitle.frame.origin.y+self.lbl_OfferTitle.frame.size.height+5, self.lbl_OfferDicount.frame.size.width, self.lbl_OfferDicount.frame.size.height);
    self.lbl_OfferDicount.numberOfLines=0;
    self.lbl_ValOfDiscount.numberOfLines=0;
    self.lbl_NoOfUses.numberOfLines=0;   
    if (kDevice==kIphone) {
        self.lbl_ValOfDiscount.frame=CGRectMake(self.lbl_ValOfDiscount.frame.origin.x,self.lbl_OfferDicount.frame.origin.y, self.lbl_ValOfDiscount.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerValue"]] andWidth:self.lbl_ValOfDiscount.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
        
        self.lbl_NoOfUses.frame=CGRectMake(self.lbl_NoOfUses.frame.origin.x, self.lbl_OfferDicount.frame.origin.y+self.lbl_ValOfDiscount.frame.size.height, self.lbl_NoOfUses.frame.size.width,  self.lbl_NoOfUses.frame.size.height);
        self.lbl_ValNoUses.frame=CGRectMake(self.lbl_ValNoUses.frame.origin.x,self.lbl_NoOfUses.frame.origin.y, self.lbl_ValNoUses.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"usageCount"]] andWidth:self.lbl_ValNoUses.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
        self.lblMaxCount.frame=CGRectMake(self.lblMaxCount.frame.origin.x, self.lbl_NoOfUses.frame.origin.y+self.lbl_ValNoUses.frame.size.height, self.lblMaxCount.frame.size.width,  self.lblMaxCount.frame.size.height);
        self.lblMaxCountValue.frame=CGRectMake(self.lblMaxCountValue.frame.origin.x,self.lblMaxCount.frame.origin.y, self.lblMaxCountValue.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"maxCount"]] andWidth:self.lblMaxCountValue.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
    }
    else{
        self.lbl_ValOfDiscount.frame=CGRectMake(self.lbl_ValOfDiscount.frame.origin.x,self.lbl_OfferDicount.frame.origin.y+5, self.lbl_ValOfDiscount.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerValue"]] andWidth:self.lbl_ValOfDiscount.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
        
        self.lbl_NoOfUses.frame=CGRectMake(self.lbl_NoOfUses.frame.origin.x, self.lbl_OfferDicount.frame.origin.y+self.lbl_ValOfDiscount.frame.size.height, self.lbl_NoOfUses.frame.size.width,  self.lbl_NoOfUses.frame.size.height);
        self.lbl_ValNoUses.frame=CGRectMake(self.lbl_ValNoUses.frame.origin.x,self.lbl_NoOfUses.frame.origin.y+5, self.lbl_ValNoUses.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"usageCount"]] andWidth:self.lbl_ValNoUses.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
        self.lblMaxCount.frame=CGRectMake(self.lblMaxCount.frame.origin.x, self.lbl_NoOfUses.frame.origin.y+self.lbl_ValNoUses.frame.size.height, self.lblMaxCount.frame.size.width,  self.lblMaxCount.frame.size.height);
        self.lblMaxCountValue.frame=CGRectMake(self.lblMaxCountValue.frame.origin.x,self.lblMaxCount.frame.origin.y+12, self.lblMaxCountValue.frame.size.width, [CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"maxCount"]] andWidth:self.lblMaxCountValue.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
    }
    self.lbl_ValNoUses.numberOfLines=0;
    
    self.lbl_ValOfDiscount.text=[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerValue"];
    self.lbl_ValNoUses.text=[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"usageCount"];
    
    
    self.lblMaxCountValue.text=[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"maxCount"];

    
    self.img_OfferImg.frame=CGRectMake(self.img_OfferImg.frame.origin.x, self.lblMaxCount.frame.origin.y+self.lblMaxCount.frame.size.height+5, self.img_OfferImg.frame.size.width, self.img_OfferImg.frame.size.height);
    
    self.lbl_OfferDiscription.frame=CGRectMake(self.lbl_OfferDiscription.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.lbl_OfferDiscription.frame.size.width,[CommonFunction heightOfLabel:[NSString stringWithFormat:@"%@",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerDesc"]] andWidth:self.lbl_OfferDiscription.frame.size.width fontName:kFont  fontSize:kAppDelegate.fontSizeSmall]);
    
    [self.activityIndicator setCenter:CGPointMake((self.img_OfferImg.frame.origin.x+self.img_OfferImg.frame.size.width/2),(self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height/2))];

    [self.activityIndicator setContentMode:UIViewContentModeCenter];
    self.lbl_OfferTitle.text=[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerTitle"];
    self.lbl_OfferDiscription.text=[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerDesc"];
    self.lbl_OfferDiscription.numberOfLines=0;
  

    self.scrlView.contentSize=CGSizeMake(0, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5);
        
    if ((![[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"0"]&& [[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]) ||([[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"-1"]&& [[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]])) {
        _lblNotPaid.hidden=YES;
        self.btnRedeem.frame=CGRectMake(self.btnRedeem.frame.origin.x, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5, self.btnRedeem.frame.size.width,self.btnRedeem.frame.size.height);
        self.btnRedeem.hidden=FALSE;
        self.scrlView.contentSize=CGSizeMake(0, self.btnRedeem.frame.origin.y+self.btnRedeem.frame.size.height+5);

    }
    if ([[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:0]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length]>0 ) {
        _lblNotPaid.hidden=NO;
        _lblNotPaid.font=[UIFont fontWithName:kFont size:_lblNotPaid.font.pointSize];

    }*/
    
    
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:self.lbl_OfferTitle,self.lbl_OfferDicount,self.lbl_ValOfDiscount,self.lbl_NoOfUses,self.lbl_ValNoUses,self.lblMaxCount,self.lblMaxCountValue,self.lbl_OfferDiscription,nil];
    
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerTitle"],self.lbl_OfferDicount.text,[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerValue"],self.lbl_NoOfUses.text,[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"usageCount"],self.lblMaxCount.text,[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"maxCount"],[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"offerDesc"], nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:kFont,kFont,kFont3,kFont,kFont3,kFont,kFont3,kFont, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"Y",@"X",@"Y",@"X",@"Y",@"X",@"Y", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:10 initialYValue:0];
    
    self.img_OfferImg.frame=CGRectMake(self.img_OfferImg.frame.origin.x, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5, self.img_OfferImg.frame.size.width, self.img_OfferImg.frame.size.height);
      self.scrlView.contentSize=CGSizeMake(0, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5);
    
    
//    if ((![[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"0"]&& [[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]) ||([[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"-1"]&& [[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]])) {
//        _lblNotPaid.hidden=YES;
//        self.btnRedeem.frame=CGRectMake(self.btnRedeem.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.btnRedeem.frame.size.width,self.btnRedeem.frame.size.height);
//        self.btnRedeem.hidden=FALSE;
//        self.scrlView.contentSize=CGSizeMake(0, self.btnRedeem.frame.origin.y+self.btnRedeem.frame.size.height+5);
//        
////    }
//
//    NSLog(@"[[kAppDelegate dictUserInfo]valueForKey %@",[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]);
////    if ([[self.dict_OfferDetail  valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:0]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"] ) {
////        _lblNotPaid.hidden=NO;
////        _lblNotPaid.font=[UIFont fontWithName:kFont size:_lblNotPaid.font.pointSize];
////        
////    }
//    
//    if ((![[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"0"]&& [[self.dict_OfferDetail  valueForKey:@"profileComplete"]isEqualToString:@"1"]) ||([[[self.dict_OfferDetail  valueForKey:@"offersList"]  valueForKey:@"availableCount"]isEqualToString:@"-1"]&& [[self.dict_OfferDetail  valueForKey:@"profileComplete"]isEqualToString:@"1"])) {
//        _lblNotPaid.hidden=YES;
//        self.btnRedeem.frame=CGRectMake(self.btnRedeem.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.btnRedeem.frame.size.width,self.btnRedeem.frame.size.height);
//        self.btnRedeem.hidden=FALSE;
//        self.scrlView.contentSize=CGSizeMake(0, self.btnRedeem.frame.origin.y+self.btnRedeem.frame.size.height+5);
//        
//    }
    
    
    
    if ((![[[self.dict_OfferDetail valueForKey:@"offersList"]valueForKey:@"availableCount"]isEqualToString:@"0"]&& [[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]&&([[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"])) ||([[[self.dict_OfferDetail valueForKey:@"offersList"]valueForKey:@"availableCount"]isEqualToString:@"-1"]&& [[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"])) {
      _lblNotPaid.hidden=YES;
      self.btnRedeem.frame=CGRectMake(self.btnRedeem.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.btnRedeem.frame.size.width,self.btnRedeem.frame.size.height);
       self.btnRedeem.hidden=FALSE;
       self.scrlView.contentSize=CGSizeMake(0, self.btnRedeem.frame.origin.y+self.btnRedeem.frame.size.height+5);
        
        }
    
    
//    if ([[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:0]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length]>0&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"1"] ) {
//         _lblNotPaid.hidden=NO;
//         _lblNotPaid.font=[UIFont fontWithName:kFont size:_lblNotPaid.font.pointSize];
//         
//        }
    
    if ([[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:0]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length]>0 ) {
        _lblNotPaid.hidden=NO;
        _lblNotPaid.font=[UIFont fontWithName:kFont size:_lblNotPaid.font.pointSize];
        
    }
    
    if ([[self.dict_OfferDetail valueForKey:@"isSubscribed"]isEqual:[NSNumber numberWithChar:1]]&&[[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"]&&[[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length]>0 ) {
        _lblNotPaid.text=@"You have not completed registration yet";
        _lblNotPaid.hidden=NO;
        _lblNotPaid.font=[UIFont fontWithName:kFont size:_lblNotPaid.font.pointSize];
        
    }
    
    [self.activityIndicator setCenter:CGPointMake((self.img_OfferImg.frame.origin.x+self.img_OfferImg.frame.size.width/2),(self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height/2))];
    
    [self.activityIndicator setContentMode:UIViewContentModeCenter];
    self.activityIndicator.hidden=TRUE;
    [self.activityIndicator stopAnimating];

}
#pragma mark -
#pragma mark - Buttons Action
/*
 Action back button
 */
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRedeemClicked:(id)sender {
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you at the merchant location and sure you want to redeem this offer?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alertView.tag=kRedeemOfferAlertTag;
    [alertView show];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kRedeemOfferAlertTag && buttonIndex==0) {
        
        [kAppDelegate showProgressHUD];
        self.btnRedeem.userInteractionEnabled=FALSE;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:[[self.dict_OfferDetail  valueForKey:@"offersList"] valueForKey:@"offerId"] forKey:@"offerId"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kRedeemoffer] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            NSLog(@"%@",result);
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                IBRedeemOffer *objIBRedeemOffer;
                if (kDevice==kIphone) {
                    objIBRedeemOffer =[[IBRedeemOffer alloc]initWithNibName:@"IBRedeemOffer" bundle:nil];
                }
                else{
                    objIBRedeemOffer =[[IBRedeemOffer alloc]initWithNibName:@"IBRedeemOffer_iPad" bundle:nil];
                }
               objIBRedeemOffer.delegate=self.delegate;
               objIBRedeemOffer.dict_MerchantInfo=self.dict_OfferDetail;
               self.btnRedeem.userInteractionEnabled=TRUE;
                [self.navigationController pushViewController:objIBRedeemOffer animated:YES];
              }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                 [CommonFunction fnAlert:@"" message:[NSString stringWithFormat:@"%@%@",@"It can be used again ",[[self.dict_OfferDetail  valueForKey:@"offersList"]   valueForKey:@"alert"]]];
                self.btnRedeem.userInteractionEnabled=TRUE;
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
                self.btnRedeem.userInteractionEnabled=TRUE;
            }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                [CommonFunction fnAlert:@"" message:@"Your subscription Expired.  Please renew your subscription."];
                self.btnRedeem.userInteractionEnabled=TRUE;
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                self.btnRedeem.userInteractionEnabled=TRUE;

            }
            //[kAppDelegate hideProgressHUD];
            self.activityIndicator.hidden=TRUE;
            [self.activityIndicator stopAnimating];
            [kAppDelegate hideProgressHUD];
            
        } errorBlock:^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
            [kAppDelegate hideProgressHUD];
            self.activityIndicator.hidden=TRUE;
            [self.activityIndicator stopAnimating];
        }];
    }
}
/*
 Method to scale image
 */
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




@end
