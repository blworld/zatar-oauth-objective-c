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
    [eventLogTextString appendString:[NSString stringWithFormat: @"\nRootUri:\n%@\n", ROOT_URI]];

    eventLogTextView.text = eventLogTextString;

}

-(IBAction)tappedOnAuthorizeButton:(id)sender{

#if DEBUG
    NSLog(@"\n\n...OauthTest...viewController.m...inside tappedOnAuthorizeButton...\n\n");
#endif

    // clear out buffer
    
    [authBuffer setData:(NSData*)NULL];
    
    // first set up request for authorization code by providing clientID/secret and redirect URI in http GET
    
    NSString *targetString = [NSString stringWithFormat:@"%@/authorize?response_type=code&client_id=%@&state=123&redirect_uri=OauthTestApp%%3A%%2F%%2FAuthorize%%2Ecom&scope=read,update,create", ROOT_URI, CLIENT_ID];
    
#if DEBUG
    NSLog(@"\n\nzviewController.m...tappedOnAuthorizeButton...targetString = %@\n\n", targetString);
#endif
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetString]];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    
#if DEBUG
    
    NSLog(@"\n\n...OauthTest...viewController.m...inside viewWillAppear...\n\n");
    
    NSLog(@"\n\n...authorizationToken = %@\n\n", authorizationToken);
    
#endif
    
}

-(void)justBecameActive{
    
#if DEBUG
    
    NSLog(@"\n\n...OauthTest...viewController.m...inside justBecameActive...\n\n");
    
    NSLog(@"\n\n...authorizationToken = %@\n\n", authorizationToken);
    
#endif
    
    if (authorizationToken != NULL) {
        [self getAccessTokenUsingAuthorizationToken];
    }
    else{
        
#if DEBUG
        
        NSLog(@"\n\n...authorization token is NULL ...doing nothing.\n\n");
#endif
        
    }
    
}

-(void)getAccessTokenUsingAuthorizationToken{
    
#if DEBUG
    NSLog(@"\n\n...OauthTest...viewController.m...inside getAccessTokenUsingAuthorizationToken...\n\n");
#endif
    
    [eventLogTextString appendString:@"\n...Attempting to Authenticate..."];
    eventLogTextView.text = eventLogTextString;
    
    NSString *targetString = [NSString stringWithFormat:@"%@/token", ROOT_URI];
    
#if DEBUG
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
    
#if DEBUG || TERSE_DEBUG
    NSLog(@"\n\n...base 64 encoded clientID:secret = %@\n\n", base64EncodedClientIDSecret);
#endif
    
    [AccessTokenRequest setValue:[NSString stringWithFormat:@"Basic %@", base64EncodedClientIDSecret] forHTTPHeaderField:@"Authorization"];
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\n\n...Base 64 encoded clientID:secret:\n%@", base64EncodedClientIDSecret]];
    
    eventLogTextView.text = eventLogTextString;
    
    [AccessTokenRequest setHTTPMethod:@"POST"];
    
    NSString *requestPayload = [NSString stringWithFormat:@"grant_type=authorization_code&code=%@&redirect_uri=OauthTestApp%%3A%%2F%%2FAuthorize%%2Ecom",authorizationToken];
    
    [eventLogTextString appendString:[NSString stringWithFormat:@"\n\n...Request Payload:\n%@", requestPayload]];
    eventLogTextView.text = eventLogTextString;
    
#if DEBUG
    NSLog(@"\n\n...requestPayload = %@\n\n", requestPayload);
#endif
    
    [AccessTokenRequest setHTTPBody:[NSData dataWithBytes:[requestPayload UTF8String] length:[requestPayload length]]];
    
    //[AccessTokenRequest setValue:[NSString stringWithFormat:@"Bearer %@", authorizationToken] forHTTPHeaderField:@"Authorization"];
    
    AccessTokenConnection = [NSURLConnection connectionWithRequest:AccessTokenRequest delegate:self];
    
    if (AccessTokenConnection == nil) {
        
#if DEBUG
        NSLog(@"...get access token connection is NIL");
#endif
        
    }
    else {
        
#if DEBUG
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
    
#if DEBUG
    NSLog(@"\n\n---> Entering connectionDidReceiveResponse...connection = %@\n\n", theConnection);
#endif
        
    NSHTTPURLResponse * httpResponse;
    
    
    httpResponse = (NSHTTPURLResponse *) response;
    
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
        
    currentContentType = httpResponse.MIMEType;
        
        
#if DEBUG
    
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
    
#if DEBUG
    NSLog(@"\n\n---> Entering connectionDidReceiveData...connection = %@\n\n", theConnection);
    NSLog(@"...input buffer length = %i", (int)data.length);
#endif
        
        if (theConnection == AccessTokenConnection) {

            [accessTokenBuffer appendData:data];

        }

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    
#if DEBUG
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
        
        if (theConnection == AccessTokenConnection) {

            // deserialize json response into Dictionary
            
            accessTokenResponseDictionary = [NSJSONSerialization JSONObjectWithData:accessTokenBuffer options:kNilOptions error:nil];

            if (accessTokenResponseDictionary.count != 0) {
                
                accessToken = [accessTokenResponseDictionary objectForKey:@"access_token"];
                refreshToken = [accessTokenResponseDictionary objectForKey:@"refresh_token"];
                scopes = [accessTokenResponseDictionary objectForKey:@"scope"];
                expires = [accessTokenResponseDictionary objectForKey:@"expires_in"];
                
#if DEBUG
                NSLog(@"\n\n... access token response: %@\n\n", accessTokenResponseDictionary);
                
                NSLog(@"\n\n...access token = %@\n\n", accessToken);
                
                NSLog(@"\n\n...refresh token = %@\n\n", [accessTokenResponseDictionary objectForKey:@"refresh_token"]);
                
                NSLog(@"\n\n...scopes: %@\n\n", [accessTokenResponseDictionary objectForKey:@"scope"]);
#endif
                
                // print out in text box
                
                [eventLogTextString appendString: [NSString stringWithFormat:@"\n\nApplication Successfully Authorized\n"]];
                [eventLogTextString appendString: [NSString stringWithFormat:@"\nNew Access Token:\n%@\n", accessToken]];
                [eventLogTextString appendString: [NSString stringWithFormat:@"\nNew Refresh Token:\n%@\n", refreshToken]];
                
                eventLogTextView.text = eventLogTextString;
                               
                
            }
            else{
#if DEBUG
                NSLog(@"\n\n...ERROR ---> Access token response is EMPTY.\n\n");
#endif
            }
        
        
        }
        
        
    }
    else{
        
#if DEBUG
        NSLog(@"\n\nERROR ---> no Json response received. Exiting.\n\n");
#endif
        
    }
    
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
 
#if DEBUG
    NSLog(@"\n\n---> Entering connectionDidFailWithError method...connection = %@\n\n", theConnection);
#endif
    
}



@end
