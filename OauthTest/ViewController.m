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
    
    if (!eventLogTextString) {
        eventLogTextString = [[NSMutableString alloc]initWithCapacity:2048];
    }
    [eventLogTextView setFont:[UIFont systemFontOfSize:10]];
    [eventLogTextView setEditable:NO];
    
    
    if (!authBuffer) {
        authBuffer = [[NSMutableData alloc]init];
    }
    
    // register to be notified when you are invoked
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(justBecameActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [eventLogTextString appendString:@"OauthTest iOS Native App Oauth Example Project\n"];
    [eventLogTextString appendString:[NSString stringWithFormat: @"\nClientID: %@\n", CLIENT_ID]];
    [eventLogTextString appendString:[NSString stringWithFormat: @"\nSecret: %@\n", SECRET]];
    [eventLogTextString appendString:[NSString stringWithFormat: @"\nState: %@\n", STATE]];
    [eventLogTextString appendString:[NSString stringWithFormat: @"\nRootUri:\n%@\n", ROOT_URI]];

    eventLogTextView.text = eventLogTextString;

}

-(IBAction)tappedOnAuthorizeButton:(id)sender{

#if LOG_MESSAGES_ON
    NSLog(@"\n\n...OauthTest...viewController.m...inside tappedOnAuthorizeButton...\n\n");
#endif

    // clear out buffer
    
    [authBuffer setData:(NSData*)NULL];
    
    // first set up request for authorization code by providing clientID/secret and redirect URI in http GET
    
    // this string will be used to tell the authentication server what type of grant flow, pass parameters, and provide redirect uri
    
    // redirect URI: "<CUSTOM_URL_SCHEME>://Authorize.com"

    NSString *targetString = [NSString stringWithFormat:@"%@/authorize?response_type=code&client_id=%@&state=%@&redirect_uri=%@%%3A%%2F%%2FAuthorize%%2Ecom&scope=read,update,create", ROOT_URI, CLIENT_ID, STATE, CUSTOM_URL_SCHEME];
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\nzviewController.m...tappedOnAuthorizeButton...targetString = %@\n\n", targetString);
#endif
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\nInvoking Browswer with URL set to:\n\n%@\n", targetString]];
    
    eventLogTextView.text = eventLogTextString;     // update event log on device
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetString]];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    
#if LOG_MESSAGES_ON
    
    NSLog(@"\n\n...OauthTest...viewController.m...inside viewWillAppear...\n\n");
    
    NSLog(@"\n\n...authorizationToken = %@\n\n", authorizationToken);
    
#endif
    
}

-(void)justBecameActive{
    

    
#if LOG_MESSAGES_ON
    
    NSLog(@"\n\n...OauthTest...viewController.m...inside justBecameActive...\n\n");
    
    NSLog(@"\n\n...authorizationToken = %@\n\n", authorizationToken);
    
#endif
    
    if (authorizationToken != NULL) {
        
        [eventLogTextString appendString:[NSString stringWithFormat:@"\n--> Received Authorization Code:\n%@\n", authorizationToken]];
        eventLogTextView.text = eventLogTextString;
        
        [self getAccessTokenUsingAuthorizationToken];
    }
    else{
        
#if LOG_MESSAGES_ON
        
        NSLog(@"\n\n...authorization token is NULL ...TAP Authorize Button\n\n");
#endif
        
        [eventLogTextString appendString:[NSString stringWithFormat:@"\n...No Valid Authorization Code Detected...\n"]];
        eventLogTextView.text = eventLogTextString;
        
        if (!infoAlert) {
            infoAlert =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Valid Authorization Code Detected\nPlease Tap Authorize Button\nYour browser will then open and you will be taken to the host website to log in and provide authorization for this app to access your resources\nThen you will be returned to this app to view your Access and Refresh Tokens" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        }
        
        [infoAlert show];
        
    }
    
}

-(void)getAccessTokenUsingAuthorizationToken{
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n...OauthTest...viewController.m...inside getAccessTokenUsingAuthorizationToken...\n\n");
#endif
    
    [eventLogTextString appendString:@"\n...Attempting to Obtain Access/Refresh Tokens..."];
    eventLogTextView.text = eventLogTextString;
    
    NSString *targetString = [NSString stringWithFormat:@"%@/token", ROOT_URI];
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n...targetString = %@\n\n", targetString);
#endif
    
    accessTokenBuffer = [[NSMutableData alloc]init];
    
    [accessTokenBuffer setData:(NSData*) NULL];            // clear out data buffer so we don't mistakenly use last update somehow
    
    NSMutableURLRequest *AccessTokenRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: targetString]];
    
    [AccessTokenRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [AccessTokenRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Accept"];
    
    // put app base-64 encoded clientID:secret for your app into "authorization" field
    
    NSMutableString *clientIDSecret = [[NSMutableString alloc]initWithCapacity:256];
    
    [clientIDSecret setString:[NSString stringWithFormat:@"%@:%@", CLIENT_ID, SECRET]];   // initialize with clientID:secret from globalsettings.h
    
    NSData *binaryUTF8encodedClientIDSecret = [clientIDSecret dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64EncodedClientIDSecret = [binaryUTF8encodedClientIDSecret base64EncodedStringWithOptions:0];
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n...base 64 encoded clientID:secret for Auhorization Header = %@\n\n", base64EncodedClientIDSecret);
#endif
    
    [AccessTokenRequest setValue:[NSString stringWithFormat:@"Basic %@", base64EncodedClientIDSecret] forHTTPHeaderField:@"Authorization"];
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\n\n...Base 64 encoded clientID:secret:\n%@", base64EncodedClientIDSecret]];
    
    eventLogTextView.text = eventLogTextString;
    
    [AccessTokenRequest setHTTPMethod:@"POST"];
    
    NSString *requestPayload = [NSString stringWithFormat:@"grant_type=authorization_code&code=%@&redirect_uri=%@%%3A%%2F%%2FAuthorize%%2Ecom",authorizationToken, CUSTOM_URL_SCHEME];
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\n\n...Request Payload:\n%@", requestPayload]];
    
    eventLogTextView.text = eventLogTextString;
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n...requestPayload = %@\n\n", requestPayload);
#endif
    
    [AccessTokenRequest setHTTPBody:[NSData dataWithBytes:[requestPayload UTF8String] length:[requestPayload length]]];
    
    //[AccessTokenRequest setValue:[NSString stringWithFormat:@"Bearer %@", authorizationToken] forHTTPHeaderField:@"Authorization"];
    
    AccessTokenConnection = [NSURLConnection connectionWithRequest:AccessTokenRequest delegate:self];
    
    if (AccessTokenConnection == nil) {
        
#if LOG_MESSAGES_ON
        NSLog(@"...get access token connection is NIL");
#endif
        
    }
    else {
        
#if LOG_MESSAGES_ON
        NSLog(@"...get access token request successfully generated...waiting for callback...");
#endif
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma NSURL_callbacks

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n---> Entering connectionDidReceiveResponse...connection = %@\n\n", theConnection);
#endif
        
    NSHTTPURLResponse * httpResponse;
    
    
    httpResponse = (NSHTTPURLResponse *) response;
    
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
        
    currentContentType = httpResponse.MIMEType;
        
        
#if LOG_MESSAGES_ON
    
    NSDictionary *responseHeaders = [[NSDictionary alloc]init];

        NSLog(@"\n\nHTTP response status code = %li\n\n", (long)httpResponse.statusCode);
        NSLog(@"HTTP target URL = %@", httpResponse.URL);
        NSLog(@"HTTP Content-Type = %@", [httpResponse MIMEType]);
        NSLog(@"HTTP Response Header = %@", [httpResponse description]);
        NSLog(@"HTTP response headers:\n%@", responseHeaders);
        NSLog(@"HTTP responseHeaders.count = %lu", (unsigned long)responseHeaders.count);
#endif
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\n\n...HTTP Response Status Code: %li", (long)httpResponse.statusCode]];
    eventLogTextView.text = eventLogTextString;
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n---> Entering connectionDidReceiveData...connection = %@\n\n", theConnection);
    NSLog(@"...input buffer length = %i", (int)data.length);
#endif
        
        if (theConnection == AccessTokenConnection) {

            [accessTokenBuffer appendData:data];

        }

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    
#if LOG_MESSAGES_ON
    NSLog(@"\n\n---> Entering connectionDidFinishLoading method...connection = %@\n\n", theConnection);
    NSLog(@"\n\n...size of access token buffer = %i bytes\n\n", (int)accessTokenBuffer.length);
    
    int i;
    
    NSMutableString *messageString = [[NSMutableString alloc]init];
    
    char* debugPointer;
    
    debugPointer = (char*)accessTokenBuffer.bytes;
    
    for (i=0; i<accessTokenBuffer.length; i++) {
        [messageString appendString:[NSString stringWithFormat:@"%c", *debugPointer]];
        debugPointer++;
    }
    [messageString appendString:@"\n"];
    NSLog(@"\n\n...processJsonReturnData: Json received =\n\n");
    NSLog(@"\n\n%@\n\n", messageString);
    
#endif
    
    NSDictionary *accessTokenResponseDictionary = [[NSDictionary alloc]init];   // this will store the access token request response
    
    if ([currentContentType isEqualToString:@"application/json"]) {
        
        NSString *finalString = @"";
        
        if (theConnection == AccessTokenConnection) {

            // deserialize json response into Dictionary
            
            accessTokenResponseDictionary = [NSJSONSerialization JSONObjectWithData:accessTokenBuffer options:kNilOptions error:nil];
            
            if ([accessTokenResponseDictionary objectForKey:@"error"] || [accessTokenResponseDictionary objectForKey:@"violations"]) {
                
                // an error occurred - display it and exit
                
                [eventLogTextString appendString:[NSString stringWithFormat:@"\n\nERROR: Response from server:\n\n%@\n\n", [accessTokenResponseDictionary description]]];
                
                finalString = [NSString stringWithFormat:@"\n---> OauthTestApp exiting - Authorization Attempt Failed.\n"];
                
                [eventLogTextString appendString:finalString];
                
            }
            else{

            if (accessTokenResponseDictionary.count != 0) {
                
                accessToken = [accessTokenResponseDictionary objectForKey:@"access_token"];
                refreshToken = [accessTokenResponseDictionary objectForKey:@"refresh_token"];
                scopes = [accessTokenResponseDictionary objectForKey:@"scope"];
                expires = [accessTokenResponseDictionary objectForKey:@"expires_in"];
                
#if LOG_MESSAGES_ON
                NSLog(@"\n\n... access token response: %@\n\n", accessTokenResponseDictionary);
                
                NSLog(@"\n\n...access token = %@\n\n", accessToken);
                
                NSLog(@"\n\n...refresh token = %@\n\n", [accessTokenResponseDictionary objectForKey:@"refresh_token"]);
                
                NSLog(@"\n\n...scopes: %@\n\n", [accessTokenResponseDictionary objectForKey:@"scope"]);
#endif
                
                [eventLogTextString appendString: [NSString stringWithFormat:@"\n\nNew Access Token:\n%@\n", accessToken]];
                [eventLogTextString appendString: [NSString stringWithFormat:@"\nNew Refresh Token:\n%@\n", refreshToken]];

                
                // print out in text box
                
                
                if (![self thisValueIsNull:accessToken] && ![self thisValueIsNull:refreshToken]) {
                    
                    // if all tokens are NOT NULL, then print out success message
                    
                    finalString = [NSString stringWithFormat:@"\n\n--> Application Successfully Authorized\n"];
                    
                    [eventLogTextString appendString: finalString];
                    
#if LOG_MESSAGES_ON
                    NSLog(@"\n\n...Application Successfully Authorized\n\n");
#endif
                    
                }
                else{
                    
                    // else print out error message
                    
                    finalString = [NSString stringWithFormat:@"\n\n--> ERROR - NULL Token(s) Received\n"];
                    
                    [eventLogTextString appendString: finalString];
                    
#if LOG_MESSAGES_ON
                    NSLog(@"\n\n...ERROR ---> NULL Token(s) receieved.\n\n");
#endif
                }
                


            }
            else{
#if LOG_MESSAGES_ON
                NSLog(@"\n\n...ERROR ---> Access token response is EMPTY.\n\n");
#endif
            }
                
                
            
            }
            
            // update eventlogtextstring and scroll to the bottom
            
            eventLogTextView.text = eventLogTextString;
            
            NSRange subRange = [eventLogTextView.text rangeOfString:finalString];
            
            if (subRange.location != NSNotFound) {
                [eventLogTextView scrollRangeToVisible:subRange];
            }
        
        
        }
        
        
    }
    else{
        
#if LOG_MESSAGES_ON
        NSLog(@"\n\nERROR ---> no Json response received. Exiting.\n\n");
#endif
        
    }
    
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
 
#if LOG_MESSAGES_ON
    NSLog(@"\n\n---> Entering connectionDidFailWithError method...connection = %@\n\n", theConnection);
#endif
    
}

-(BOOL)thisValueIsNull:(NSString*)inputString{
    
    if (inputString == NULL || [inputString isEqual:[NSNull null]] || [inputString isEqual:nil]) {
        return YES;
    }
    else return NO;
}



@end
