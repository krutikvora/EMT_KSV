//
//  IBRedeemOffer.m
//  iBuddyClient
//
//  Created by Anubha on 15/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBRedeemOffer.h"
#import "UIImageView+WebCache.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSTextCheckingResult+ExtendedURL.h"
#import "CoreTextUtils.h"

@interface IBRedeemOffer ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgMerchant;
@property (weak, nonatomic) IBOutlet UILabel *lblMerchantName;
@property (weak, nonatomic) IBOutlet UILabel *lblOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblNPOName;
@property (weak, nonatomic) IBOutlet UILabel *lblApproved;
@property (weak, nonatomic) IBOutlet UILabel *lblProud;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@property (weak, nonatomic) IBOutlet UIButton *btnShowCoupon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;

@end

@implementation IBRedeemOffer
@synthesize dateFormatter;
@synthesize dict_MerchantInfo;
@synthesize lblCopyRight;
@synthesize scrlView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialLabels];
    [self setUIViewValues];
    [self setTimer];
    self.isDisappear=TRUE;

    //[self performSelector:@selector(showAlert) withObject:nil afterDelay:1];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated{
//
//    self.isDisappear=TRUE;
//}
-(void)viewWillDisappear:(BOOL)animated{
    //Changes by client 27/2/14
    if(self.isDisappear==TRUE)
    {
        [self.delegate showAlert];
    }
    [super viewWillDisappear:YES];
}
#pragma mark - Set Card Image


- (void)viewDidUnload {
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark Set Timer
-(void)setTimer
{
    NSDate *today = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh : mm : ss a"];
    
    NSString *currentTime = [self.dateFormatter stringFromDate: today];
    self.lblCurrentTime.text = currentTime;
    
    changingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(changeTime)
                                                  userInfo:nil
                                                   repeats:YES];
}
- (void) changeTime
{
    NSDate *today = [[NSDate alloc] init];
    NSString *currentTime = [self.dateFormatter stringFromDate: today];
    self.lblCurrentTime.text = currentTime;
}

#pragma mark-
#pragma mark - Button Actions 
- (IBAction)btnDoneClicked:(id)sender {
    [self.delegate showAlert];
    self.isDisappear=NO;

    NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *controller in arrViewControllers)
    {
        if ([controller isKindOfClass:[IBOffersVC class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }

}
- (IBAction)btnBackClicked:(id)sender {
    // [self.delegate showAlert];
    [self.delegate showAlert];
    
    self.isDisappear=NO;
    NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *controller in arrViewControllers)
    {
        if ([controller isKindOfClass:[IBOffersVC class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}
- (IBAction)btnCouponClicked:(id)sender {
    IBQRCodeViewController *obj;
    self.isDisappear=NO;
    if (kDevice==kIphone) {
        obj=[[IBQRCodeViewController alloc]initWithNibName:@"IBQRCodeViewController" bundle:nil];
    }
    else{
        obj=[[IBQRCodeViewController alloc]initWithNibName:@"IBQRCodeViewController_iPad" bundle:nil];
    }
    obj.delegate=self.delegate;

    obj.dictDetails=dict_MerchantInfo;
    [self.navigationController pushViewController:obj animated:YES];
    // [self.view addSubview:obj.view];
    //[self presentViewController:obj animated:YES completion:nil];
}


#pragma mark-
#pragma mark - Initial Methods
/**
 Set initial labels
 */
-(void)setInitialLabels
{
    self.lblCopyRight.text = [CommonFunction getCopyRightText];

    _lblTop.font=[UIFont fontWithName:kFont size:_lblTop.font.pointSize];
    self.lblNPOName.font=[UIFont fontWithName:kFont size:_lblNPOName.font.pointSize];
    self.lblUserName.font=[UIFont fontWithName:kFont size:_lblUserName.font.pointSize];
    self.lblCurrentDate.font=[UIFont fontWithName:kFont size:_lblCurrentDate.font.pointSize];
    self.lblMerchantName.font=[UIFont fontWithName:kFont size:_lblMerchantName.font.pointSize];
    self.lblCurrentTime.font=[UIFont fontWithName:kFont size:_lblCurrentTime.font.pointSize];
    
    self.lblOfferName.font=[UIFont fontWithName:kFont size:_lblOfferName.font.pointSize];
    self.lblApproved.font=[UIFont fontWithName:kFont size:_lblApproved.font.pointSize];
    self.lblApproved.textColor=[UIColor redColor];
    self.lblProud.font = [UIFont boldSystemFontOfSize:_lblProud.font.pointSize];
    self.lblProud.font = [UIFont italicSystemFontOfSize:_lblProud.font.pointSize];
    //self.txtEmailId.font=[UIFont fontWithName:kFont size:kFontSize1];
}
-(void)setUIViewValues{
    


    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.imgUser.center;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    [self.imgUser addSubview:activityIndicator];
 NSString *str = [[[kAppDelegate dictUserInfo]valueForKey:@"profileThumb"] stringByReplacingOccurrencesOfString:@"thumbnail/" withString:@""];
    NSLog(str);
    [self.imgUser setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"dummy_image@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [activityIndicator removeFromSuperview];
    }];
    __block UIActivityIndicatorView *activityIndicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2.center = self.imgMerchant.center;
    activityIndicator2.hidesWhenStopped = YES;
    [activityIndicator2 startAnimating];
    
    [self.imgMerchant addSubview:activityIndicator2];
    [self.imgMerchant setImageWithURL:[NSURL URLWithString:[[self.dict_MerchantInfo valueForKey:@"merchant"] valueForKey:@"merchantThumb"]] placeholderImage:[UIImage imageNamed:@"dummy_image@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [activityIndicator2 removeFromSuperview];
    }];
    NSLog(@"%@",[kAppDelegate dictUserInfo]);
    self.lblUserName.text=[[kAppDelegate dictUserInfo]valueForKey:@"name"];
    self.lblNPOName.text=[[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
    

    self.lblMerchantName.text=[[self.dict_MerchantInfo valueForKey:@"merchant"]valueForKey:@"merchantName"];
    self.lblOfferName.text=[self.dict_MerchantInfo valueForKey:@"offerTitle"];
    self.lblCurrentDate.text=[CommonFunction stringFromDate:[NSDate date]];;
    
    if([[[self.dict_MerchantInfo  valueForKey:@"offersList"] valueForKey:@"offer_qr_text"]length]>0)
    {
        [_btnShowCoupon setTitle:@"Show QR Code" forState:UIControlStateNormal];

    }
    else if([[[self.dict_MerchantInfo  valueForKey:@"offersList"] valueForKey:@"offer_qr_image"]length]>0)
    {
        [_btnShowCoupon setTitle:@"Show Coupon" forState:UIControlStateNormal];
        

    }
    else
    {
        self.btnShowCoupon.hidden=YES;
    }
    if([[[self.dict_MerchantInfo  valueForKey:@"offersList"]   valueForKey:@"is_entertaiment_offer"] boolValue]== TRUE)
    {
        
        [_btnShowCoupon setTitle:@"Show Coupon" forState:UIControlStateNormal];

        _btnShowCoupon.hidden=NO;
        _lblApproved.hidden=YES;
        
    }

  
}


@end
