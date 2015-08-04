//
//  AppDelegate.m
//  OauthTest
//
//  Created by Tom Berarducci on 8/1/15.
//  Copyright (c) 2015 Zebra Technologies. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    // called when app is invoked as a response to a URI redirect
    
    // method will verify that the redirect was valid and if so update authorizationToken global variable and return YES
    
    // if not successfull, authorizationToken will not be updated and method will return NO
    
#if DEBUG
    NSLog(@"\n\n...OauthTest AppDelegate...inside applicationOpenUrlSourceApplicationAnnotation!!\n\n");
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
#endif
    
    NSMutableString *tempString = [[NSMutableString alloc]initWithCapacity:128];
    
    NSRange subRange;

    if ([[url scheme] isEqualToString:@"oauthtestapp"]) {
        
        // valid callback has occurred - now get authorization token
        
#if DEBUG
        NSLog(@"\n\n...VALID URL scheme detected - loading Authorization token into global variable\n\n");
#endif
        [tempString setString:[url query]];

        subRange = [tempString rangeOfString:@"code="];

        // first remove 'code=' from the beginning of the string
        
        if (subRange.location != NSNotFound) {
            
            //[tempString deleteCharactersInRange:NSMakeRange(subRange.location,5)];
            
            [tempString deleteCharactersInRange:NSMakeRange(subRange.location, 5)];

            
        }
        else{
            
#if DEBUG
            NSLog(@"\n\n...ERROR cannot find 'code=' in returned URL callback...returning NO and NOT updating authorizationToken\n\n");
#endif
            return NO;
            
        }
        
        // now remove '&state=xyz' from the end
        
        subRange = [tempString rangeOfString:@"&state=123"];
        
        if (subRange.location != NSNotFound) {
            
            //[tempString deleteCharactersInRange:NSMakeRange(subRange.location,5)];
            
            [tempString deleteCharactersInRange:NSMakeRange(subRange.location, 10)];
            
            
        }
        else{
            
#if DEBUG
            NSLog(@"\n\n...ERROR cannot find '&state=123' in returned URL callback..returning NO and NOT updating authorizationToken\n\n");
#endif
            return NO;
        }
        
        authorizationToken = (NSString*)tempString;
        
#if DEBUG
        NSLog(@"...\n\n...appDelegate...authorization token received = %@...updating authorizationToken and returning YES\n\n", authorizationToken);
#endif
        
        return YES;
        
    }
    
    else return NO;
        
}

@end
