//
//  KSOfferDetailsViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 13/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSOfferDetailsViewController.h"
#import "KSOfferRedeemedViewController.h"

@interface KSOfferDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDiscription;
@property (weak, nonatomic) IBOutlet UIButton *btn_Scan;
@property (weak, nonatomic) IBOutlet UIImageView *img_OfferImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (weak, nonatomic) IBOutlet UILabel *lbl_OfferDicount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoOfUses;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ValOfDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ValNoUses;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@end

@implementation KSOfferDetailsViewController
@synthesize dict_OfferDetail;
@synthesize userID;
@synthesize isSubscribed;
#pragma mark -
#pragma mark - View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    if(!iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _scrlView.frame=CGRectMake(_scrlView.frame.origin.x
                                         , _scrlView.frame.origin.y, _scrlView.frame.size.width, _scrlView.frame.size.height+40);
        _imgBackground.frame=CGRectMake(_imgBackground.frame.origin.x
                                        , _imgBackground.frame.origin.y, _imgBackground.frame.size.width, _imgBackground.frame.size.height+40);
    }

	// Do any additional setup after loading the view.
    [self displayData];
    [self setInitialLabels];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLbl_OfferTitle:nil];
    [self setLbl_OfferDiscription:nil];
    [self setImg_OfferImg:nil];
    [self setScrlView:nil];
    [self setBtn_Scan:nil];
    [self setLbl_OfferDicount:nil];
    [self setLbl_NoOfUses:nil];
    [self setLbl_ValOfDiscount:nil];
    [self setLbl_ValNoUses:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Custom Methods

/*
 Method to set initial labels
 */
-(void)setInitialLabels
{
//    self.lbl_OfferDicount.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_NoOfUses.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_ValOfDiscount.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_ValNoUses.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_OfferTitle.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_OfferDiscription.font=[UIFont fontWithName:kFontMerchant size:kFontSize];
//    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFontMerchant size:kFontSize2];
//    self.btn_Scan.titleLabel.font=[UIFont fontWithName:kFontMerchant size:kFontSize1];
    
    
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:_lbl_ScreenTitle.font.pointSize];
    self.lbl_OfferDicount.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_NoOfUses.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_ValOfDiscount.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_ValNoUses.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_OfferTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.lbl_OfferDiscription.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.btn_Scan.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
   
}

/**-
 @Method    -  displayData -> Display Offer details Data
                Title, Discription, image, Offere Discount & availability of offer.
 */
-(void)displayData{
    [kAppDelegate showProgressHUD];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"offerImage"]]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image=[[UIImage alloc]init];
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
    });}
/*
 Method to set Raandom description view
 */
-(void)setRandomFrames
{
   /* self.lbl_OfferTitle.frame=CGRectMake(self.lbl_OfferTitle.frame.origin.x, self.lbl_OfferTitle.frame.origin.y, self.lbl_OfferTitle.frame.size.width, [Utility heightOfLabel:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"offerTitle"]] andWidth:self.lbl_OfferTitle.frame.size.width fontName:kFontMerchant  fontSize:kFontSize]);
    
    self.lbl_OfferTitle.numberOfLines=0;
    
    self.lbl_OfferDicount.frame=CGRectMake(self.lbl_OfferDicount.frame.origin.x, self.lbl_OfferTitle.frame.origin.y+self.lbl_OfferTitle.frame.size.height+5, self.lbl_OfferDicount.frame.size.width, self.lbl_OfferDicount.frame.size.height);
    self.lbl_OfferDicount.numberOfLines=0;
    
    self.lbl_ValOfDiscount.frame=CGRectMake(self.lbl_ValOfDiscount.frame.origin.x,self.lbl_OfferDicount.frame.origin.y, self.lbl_ValOfDiscount.frame.size.width, [Utility heightOfLabel:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"offerValue"]] andWidth:self.lbl_ValOfDiscount.frame.size.width fontName:kFontMerchant  fontSize:kFontSize]);
    
    self.lbl_ValOfDiscount.numberOfLines=0;
    
    self.lbl_NoOfUses.frame=CGRectMake(self.lbl_NoOfUses.frame.origin.x, self.lbl_OfferDicount.frame.origin.y+self.lbl_ValOfDiscount.frame.size.height+5, self.lbl_NoOfUses.frame.size.width,  self.lbl_NoOfUses.frame.size.height);
    self.lbl_NoOfUses.numberOfLines=0;
    self.lbl_ValNoUses.frame=CGRectMake(self.lbl_ValNoUses.frame.origin.x,self.lbl_NoOfUses.frame.origin.y, self.lbl_ValNoUses.frame.size.width, [Utility heightOfLabel:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"usageCount"]] andWidth:self.lbl_ValNoUses.frame.size.width fontName:kFontMerchant  fontSize:kFontSize]);
    
    self.lbl_ValNoUses.numberOfLines=0;
    
       
    self.img_OfferImg.frame=CGRectMake(self.img_OfferImg.frame.origin.x, self.lbl_NoOfUses.frame.origin.y+self.lbl_NoOfUses.frame.size.height+5, self.img_OfferImg.frame.size.width, self.img_OfferImg.frame.size.height);
 
    self.lbl_OfferDiscription.frame=CGRectMake(self.lbl_OfferDiscription.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.lbl_OfferDiscription.frame.size.width,[Utility heightOfLabel:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"offerDesc"]] andWidth:self.lbl_OfferDiscription.frame.size.width fontName:kFontMerchant  fontSize:kFontSize]);
    self.lbl_OfferDiscription.frame=CGRectMake(self.lbl_OfferDiscription.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5, self.lbl_OfferDiscription.frame.size.width,[Utility heightOfLabel:[NSString stringWithFormat:@"%@",[dict_OfferDetail valueForKey:@"offerDesc"]] andWidth:self.lbl_OfferDiscription.frame.size.width fontName:kFontMerchant  fontSize:kFontSize]);
    
    self.lbl_OfferTitle.text=[dict_OfferDetail valueForKey:@"offerTitle"];
    self.lbl_OfferDiscription.text=[dict_OfferDetail valueForKey:@"offerDesc"];
    self.lbl_ValOfDiscount.text=[dict_OfferDetail valueForKey:@"offerValue"];
    self.lbl_ValNoUses.text=[dict_OfferDetail valueForKey:@"usageCount"];
    self.lbl_OfferDicount.text=@"Offer Discount :";
    self.lbl_NoOfUses.text=@"No. Of Uses :";

    self.lbl_OfferDiscription.numberOfLines=0;
    
    self.scrlView.contentSize=CGSizeMake(0, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5);
    
    if (![[dict_OfferDetail valueForKey:@"availableCount"]isEqualToString:@"0"] && self.isSubscribed==TRUE) {
        self.btn_Scan.frame=CGRectMake(self.btn_Scan.frame.origin.x, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5, self.btn_Scan.frame.size.width,self.btn_Scan.frame.size.height);
        self.btn_Scan.hidden=FALSE;
        self.scrlView.contentSize=CGSizeMake(0, self.btn_Scan.frame.origin.y+self.btn_Scan.frame.size.height+5);
    }
    [kAppDelegate hideProgressHUD];*/
    
    
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:self.lbl_OfferTitle,self.lbl_OfferDicount,self.lbl_ValOfDiscount,self.lbl_NoOfUses,self.lbl_ValNoUses,self.lbl_OfferDiscription,nil];
    
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:[self.dict_OfferDetail   valueForKey:@"offerTitle"],@"Offer Discount :",[self.dict_OfferDetail    valueForKey:@"offerValue"],@"No. Of Uses :",[self.dict_OfferDetail   valueForKey:@"usageCount"],[self.dict_OfferDetail valueForKey:@"offerDesc"], nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:kFont,kFont,kFont3,kFont,kFont3,kFont, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"Y",@"X",@"Y",@"X",@"Y", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:10 initialYValue:0];
    
    self.img_OfferImg.frame=CGRectMake(self.img_OfferImg.frame.origin.x, self.lbl_OfferDiscription.frame.origin.y+self.lbl_OfferDiscription.frame.size.height+5, self.img_OfferImg.frame.size.width, self.img_OfferImg.frame.size.height);
    self.scrlView.contentSize=CGSizeMake(0, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+5);
    
    if (![[dict_OfferDetail valueForKey:@"availableCount"]isEqualToString:@"0"] && self.isSubscribed==TRUE) {
        self.btn_Scan.frame=CGRectMake(self.btn_Scan.frame.origin.x, self.img_OfferImg.frame.origin.y+self.img_OfferImg.frame.size.height+10, self.btn_Scan.frame.size.width,self.btn_Scan.frame.size.height);
        self.btn_Scan.hidden=FALSE;
        self.scrlView.contentSize=CGSizeMake(0, self.btn_Scan.frame.origin.y+self.btn_Scan.frame.size.height+5);
    }
    [kAppDelegate hideProgressHUD];
}



#pragma mark -
#pragma mark - Buttons Action
/*
 Action back button
 */
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 Action redeem butoon
 */
- (IBAction)scanAction:(id)sender {
    [kAppDelegate showProgressHUD:self.view];

    self.btn_Scan.userInteractionEnabled=FALSE;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userID forKey:@"userId"];
    [dict setValue:[dict_OfferDetail valueForKey:@"offerId"] forKey:@"offerId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kredeemofferMerchant] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            [self performSegueWithIdentifier:@"Segue_OfferRedeemed" sender:self];
            self.btn_Scan.userInteractionEnabled=TRUE;
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            // [UIAlertView alertViewWithTitle:@"" message:@"User can't avail this offer"];
            
            [CommonFunction fnAlert:@"" message:[NSString stringWithFormat:@"%@%@",@"It can be used again ",[self.dict_OfferDetail valueForKey:@"alert"]]];
            
            self.btn_Scan.userInteractionEnabled=TRUE;
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
              [CommonFunction fnAlert:@"" message:@"Please try again"];
            self.btn_Scan.userInteractionEnabled=TRUE;
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
            [CommonFunction fnAlert:@"" message:@"Your iBuddyClub account is not active, please subscribe or renew."];
            self.btn_Scan.userInteractionEnabled=TRUE;
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            self.btn_Scan.userInteractionEnabled=TRUE;

        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        [kAppDelegate hideProgressHUD];
    }];
 //[self performSegueWithIdentifier:@"Segue_OfferRedeemed" sender:self];
}
#pragma mark -
#pragma mark - Segues
/**
 @Method    -  prepareForSegue: -> Use if you want to send/set value to destination controller
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Segue_OfferRedeemed"]){
        [segue.destinationViewController setStr_OfferValue:[dict_OfferDetail valueForKey:@"offerValue"]];
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
