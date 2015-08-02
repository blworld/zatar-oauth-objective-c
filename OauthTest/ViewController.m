//
//  ViewController.m
//  OauthTest
//
//  Created by Tom Berarducci on 8/1/15.
//  Copyright (c) 2015 Zebra Technologies. All rights reserved.
//

#import "ViewController.h"
#import "globalSettings.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize authorizeButton, eventLogTextView;

- (void)viewDidLoad {
    [super viewDidLoad];


    // initialize vars
    
    if (!authBuffer) {
        authBuffer = [[NSMutableData alloc]init];
    }

}

-(IBAction)tappedOnAuthorizeButton:(id)sender{

#if DEBUG
    NSLog(@"\n\n...OauthTest...viewController.m...inside tappedOnAuthorizeButton...\n\n");
#endif

    // clear out buffer
    
    [authBuffer setData:(NSData*)NULL];
    
    // first set up request for authorization code by providing clientID/secret and redirect URI in http GET
    
    NSString *targetString = [NSString stringWithFormat:@"%@/authorize?response_type=code&client_id=iphone-app&state=123&redirect_uri=OauthTestApp%%3A%%2F%%2FAuthorize%%2Ecom&scope=read,update,create",ROOT_URI];
    
#if DEBUG || TERSE_DEBUG
    NSLog(@"\n\nzviewController.m...tappedOnAuthorizeButton...targetString = %@\n\n", targetString);
#endif
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetString]];
     
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
