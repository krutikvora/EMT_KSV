 //
//  IBMyCardsVC.m
//  iBuddyClient
//
//  Created by Anubha on 13/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBMyCardsVC.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface IBMyCardsVC ()
{
    NSURLRequest *requestObj;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgCard;

@end

@implementation IBMyCardsVC
@synthesize m_WebView;

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

    self.lblTop.font=[UIFont fontWithName:kFont size:18];
    self.lblTop.text = [[[kAppDelegate dictUserInfo]valueForKey:@"npoName"]stringByAppendingString:@"™"];
    // Commented by Utkarsha so as to add Fundraiser news Page
    //[self getCardImage];
    NSLog(@"%@",[kAppDelegate dictUserInfo]);
     [self openNewsPage];
    // Do any additional setup after loading the view from its nib.
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
- (void)viewDidUnload {
    [super viewDidUnload];
}
#pragma mark - Open Facebook page
-(void)openNewsPage
{
    [kAppDelegate showProgressHUD];
    
    NSString *urlAddress = [[kAppDelegate dictUserInfo]valueForKey:@"fb_link"];
    
    if (![urlAddress hasPrefix:@"http://"] && ![urlAddress hasPrefix:@"https://"]) {
        urlAddress = [NSString stringWithFormat:@"http://%@",urlAddress];
    }
    urlAddress=[urlAddress stringByReplacingOccurrencesOfString:@"www" withString:@"m"];
    NSURL *url;
    //Create a URL object.
    if(![urlAddress isEqualToString:@""])
    {
        url = [NSURL URLWithString:urlAddress];
        
    }

    
    //URL Requst Object
     requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [m_WebView loadRequest:requestObj];
}


#pragma mark - Set Card Image

/*
 Method to get data from server
 */
-(void)getCardImage
{
    [kAppDelegate showProgressHUD];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kUserCards] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            [self setCardImage:[result valueForKey:@"card"]];
        }
        else  {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        [kAppDelegate hideProgressHUD];

    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [kAppDelegate hideProgressHUD];
    }];
}
/*
 Method to set card image
 */
-(void)setCardImage:(NSString *)cardImageURL
{
    [kAppDelegate showProgressHUD];
    NSString *strCardImage=cardImageURL;
    if ([strCardImage length]>0) {
        _imgCard.backgroundColor=[UIColor clearColor];
        _imgCard.contentMode=UIViewContentModeScaleAspectFit;
        [_imgCard setImageWithURL:[NSURL URLWithString:strCardImage]
                    placeholderImage:[UIImage imageNamed:@""]];
        [kAppDelegate hideProgressHUD];
    }
}

#pragma mark - UIWebView Delegate methods

// Delegate methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
  
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [kAppDelegate hideProgressHUD];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
      //[CommonFunction fnAlert:@"Server Error!" message:[error description]];
    [kAppDelegate hideProgressHUD];
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

@end
