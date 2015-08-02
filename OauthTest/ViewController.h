//
//  ViewController.h
//  OauthTest
//
//  Created by Tom Berarducci on 8/1/15.
//  Copyright (c) 2015 Zebra Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *authorizationToken;

@interface ViewController : UIViewController{
    
    UIButton *authorizeButton;
    UITextView *eventLogTextView;
    
    NSMutableData *authBuffer;
    
    NSURLConnection *requestAuthTokenConnection;
    
}

@property(nonatomic, retain) IBOutlet UIButton *authorizeButton;
@property(nonatomic, retain) IBOutlet UITextView *eventLogTextView;

-(IBAction)tappedOnAuthorizeButton:(id)sender;


@end

