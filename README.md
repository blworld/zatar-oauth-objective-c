# Oauth_Test_1
Using Oauth 2.0 to authorize a native iOS app on Zatar
# Background
In order to access resources that live on Zatar, you will first need to obtain an "Access Token" and a "Refresh Token". The Access Token tells Zatar that your app is authorized to access the resources you want, while the Refresh Token allows your app to obtain a new Access Token when your original Access Token expires.

Your app must pass a Valid Access Token to Zatar when accessing resources on behalf of a resource owner. But first, in order to obtain an Access Token, your app must be authorized by the resource owner to act on their behalf. We use Oauth as the process to obtain this authorization. This sample app will show you how to obtain an Access Token and a Refresh Token for Zatar using Oauth.
# Running the Sample app
To run this app, simply import the entire project into your own Xcode environment. The app was written with Xcode 6.4, so make sure you have this version or higher.
## Getting Started
The app should compile and run on any iOS device, including the simulator. It has a minimal UI, but it does use constraints, so it should be readable on any iOS device you choose.
Before you can run the code, you'll need to do the following:

 1. Obtain a valid ClientID and Secret from the site you want to obtain authorization from. NOTE that, although this app should work with any OAuth 2.0 comaptible site, it has only been tested with Zatar's beta site api authentication server (https://beta-api.zatar.com/v2). To obtain a ClientID and Secret for accessing Zatar resources, you need to go to the Zatar Developer Portal at developer.zatar.com and register as a developer (it's free). Then, simply go to the Application Manager section and register your application to receive a ClientID and Secret.
 2. Enter your ClientID for the "CLIENT_ID" parameter in the "globalSettings.h" file of the project.
 3. Enter your Secret for the "SECRET" parameter in the globalSettings.h file of the project.
 4. Enter a value for "STATE" (this can be any valid string) in globalSettings.h or leave it as is if you like.
 5. If you want, you can change the value of "CUSTOM_URL_SCHEME" in globalSettings.h. If you do, you MUST also put this value in the appropriate place in your info.plist file. 
 6. By default, the app is set to go to Zatar for authorization, but this can be changed by changing the "ROOTURI" parameter of the globalSettings.h file. Initially this parameter is set to the Zatar beta test site.

That's it! Once you have valid info entered into globalSettings.h for CLIENT_ID, SECRET, STATE, CUSTOM_URL_SCHEME, and ROOTURI, the app should compile and run.
## Operation
When the app runs, simply tap on "Authorize" button to initiate the authorization attempt. This should result in a Safari window opening up. You should be asked by target site for your credentials and to authorize the app to access the resources of your account. Enter your credentials to give authorization, and if the credentials are verified, you should be taken back to this app. 
## Event Log
Once the app returns to the foreground, you should be able to review the entire progress of the process on the event log displayed on the app's main screen. At the bottom of the log (you may have to scroll up/down to see the entire log) you should see your Access and Refresh tokens displayed.
## Debug Log
If you like you can set LOG_MESSAGES_ON to TRUE in globalSettings.h, and also view progress of the app on the Xcode console.

# Some Details
## Redirect URI
This app uses the "Authorization Code" grant flow of Oauth 2.0. For more info on Oauth, go to http://oauth.net. In order to get this grant flow to work on a native iOS app, you need to configure a couple of things properly. First, you must configure a custom URL scheme for your app which will allow the Oauth Authentication Server to call-back into your app after authorization has been granted by the resource owner. This custom URL scheme is configured in the info.plist file of your app using the key "URL Types" which you must add. You need to add both a URL Identifier and URL Scheme. You must then include a redirect URI in your authorization request that makes use of this URL scheme.

If you want to use this code in your own app, make sure to change any references to Zebra Technologies (like the URL Identifier above), since the entitlements will be different.

## Include "State" parameter
Another security measure in Oauth is the inclusion of a "State" parameter, which is essentially a string of your choice that you add to the grant flow. The authentication server sends this string back during the redirect which you should then verify to make sure the call has not been intercepted somewhere along the way. 

For this sample app, simply enter your value for State in globalSettings.h. The app will verify that the proper value for State is returned in the call-back and if not the app will signal a failure. 

## AppDelegate
In order to receive redirects, your AppDelegate needs to support the method -(BOOL)application:openURL:soureApplication:annotation method. This is where the call-back enters your app.

## Get Notified when App is invoked through Redirection
Another thing this app does is register to be notified when the app becomes active (-(void)justBecameActive method) so it knows when the redirection has taken place.

# Details on Oauth 2.0 Authorization Code Grant Flow implementation in iOS
**Here are the steps this sample app uses to perform the Authorization Code Grant Flow in iOS (pseudo code):**

1. Application opens up browser pointed at the Authorization Server with parameters in URI
  * URL: ```<rootURI>/authorize?response_type=code&client_id=<clientId>&state=<state>&redirect_uri=<custom_url_scheme>://Authorize.com&scope=read,update,create```
2. Browser opens and Authorization Server asks user for credentials, then asks user to authorize app to access their resources. 
3. If user grants permission, then Authorization Server uses Redirect URI from #1 above to “call back” to the app with an Authorization Code embedded as a parameter of the URI (“code=“ parameter).
4. If iOS app has registered the custom URL scheme properly, then when Safari asks for the Redirect URI, the OS will send the request back to the sample app. This causes the ```application:openUrl:sourceApplication:annotation``` method of the app’s AppDelegate to be called.
5. App then uses this Authorization Code to do an HTTP POST command to obtain Access and Refresh Tokens:
  * URL: ```<rootURI>/token```
  * POST “Authorization” header must contain base64 encoded concatenation of ```<clientId>:<secret>```
  * POST Payload must contain: ```grant_type=authorization_code&code=<authorization_code>&redirect_uri=<custom_url_scheme>://Authorize.com```
6. Authorization server then responds with Access and Refresh Tokens in response payload.
7. NOTE this process only needs to be done once to gain authorization. After that, the app uses the Access Token for all requests. When the Access Token expires, it uses the Refresh Token to obtain a new set of Access and Refresh Tokens. If the user revokes access, then the app will need to re-run this process from the beginning.



Refer to the code for more detail.
