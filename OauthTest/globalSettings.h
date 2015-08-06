//
//  globalSettings.h
//  OauthTest
//
//  Created by Tom Berarducci on 8/1/15.
//  Copyright (c) 2015 Zebra Technologies. All rights reserved.
//

#ifndef OauthTest_globalSettings_h
#define OauthTest_globalSettings_h

#define CLIENT_ID @"enterYourClientIDHere"                  // unencoded clientID goes here

#define SECRET  @"enterYourSecretHere"                      // unencoded secret goes here

#define ROOT_URI @"https://beta-api.zatar.com/v2"           // rootURI goes here

#define STATE @"123"                                        // random value for state

#define CUSTOM_URL_SCHEME   @"OauthTestApp"             // this will be the root of your redirect URI; it must also be in your info.plist file!

#define DEBUG TRUE

#endif
