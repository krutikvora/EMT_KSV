//
//  IBQRCodeViewController.m
//  iBuddyClient
//
//  Created by Nishu on 23/12/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBQRCodeViewController.h"

@interface IBQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@property (weak, nonatomic) IBOutlet UIWebView *webOfferDetails;
@property (weak, nonatomic) IBOutlet UIView *vwEntertainment;

@end

@implementation IBQRCodeViewController
@synthesize lbl_Top,lblCopyRight;
@synthesize dictDetails;
@synthesize imgQRCode;

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
    
    [self setInitialVariables];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Actions

- (IBAction)btnDoneClicked:(id)sender {

//    [self dismissViewControllerAnimated:YES completion:nil];
//    IBRedeemOffer *redeemOffer=[[IBRedeemOffer alloc]initWithNibName:@"IBRedeemOffer" bundle:nil];
    
    [self.delegate showAlert];
    NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *controller in arrViewControllers)
    {
        if (![controller isEqual:[NSNull null]]) {
            if ([controller isKindOfClass:[IBOffersVC class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        
    }
}
#pragma mark - Set Initial Variables

-(void)setInitialVariables
{
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
    lbl_Top.font=[UIFont fontWithName:kFont size:lbl_Top.font.pointSize];
    _vwEntertainment.hidden=YES;
    [CommonFunction callHideViewFromSideBar];
    NSLog(@"%@",[[NSURL alloc]initWithString:[[self.dictDetails  valueForKey:@"offersList"] valueForKey:@"offer_qr_image"]]);
    [imgQRCode setImage:[[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:[[self.dictDetails  valueForKey:@"offersList"] valueForKey:@"offer_qr_image"]]]]];
    if([[[self.dictDetails  valueForKey:@"offersList"] valueForKey:@"offer_qr_text"]length]>0)
    {
        lbl_Top.text=@"QR Code™";

    }
    else if([[[self.dictDetails  valueForKey:@"offersList"] valueForKey:@"offer_qr_image"]length]>0)
    {
        lbl_Top.text=@"Coupon™";
    }
    if([[[self.dictDetails  valueForKey:@"offersList"]   valueForKey:@"is_entertaiment_offer"] boolValue]== TRUE)
    {
         lbl_Top.text=@"Coupon™";
        _vwEntertainment.hidden=NO;
        [_webOfferDetails loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self.dictDetails  valueForKey:@"offersList"]   valueForKey:@"webViewUrl"]]]];

        
    }

}



@end
