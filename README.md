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

 1. Obtain a valid ClientID and Secret from the site you want to obtain authorization from. NOTE that, although this app should work with any OAuth 2.0 comaptible site, it has only been tested with Zatar's beta site api authentication server (https://beta-api.zatar.com/v2). To obtain a ClientID and Secret for accessing Zatar resources, you need to go to the Zatar Developer Portal at developer.zatar.com and register as a developer (it's free). Then, simply to to the Application Manager section and register your application to receive a ClientID and Secret.
 2. Enter your ClientID for the "CLIENT_ID" parameter in the "globalSettings.h" file of the project.
 3. You will need to create the Base64 encoded equivalent of the quantity ClientID:Secret and insert it in the globalSettings.h file where indicated for the BASE_64_CLIENT_ID_SECRET parameter. An easy way to obtain this value is to go to a site such as https://www.base64encode.org/ and type as input "ClientID:Secret" (no quotes, separated by a colon) and it will encode it for you.
 4. By default, the app is set to go to Zatar for authorization, but this can be changed by changing the "ROOTURI" parameter of the globalSettings.h file. Initially this parameter is set to the Zatar beta test site.

That's it! Once you have valid info entered into globalSettings.h for CLIENT_ID, BASE_64_CLIENT_ID_SECRET, and ROOTURI, the app should compile and run.

When the app runs, simply tap on "Authorize" button to initiate the authorization attempt. This should result in a Safari window opening up. You should be asked by target site for your credentials and to authorize the app to access the resources of your account. Enter your credentials to give authorization, and if the credentials are verified, you should be taken back to this app. 

Once the app returns to the foreground, you should be able to review the entire progress of the process on the event log displayed on the app's main screen. At the bottom of the log (you may have to scroll up/down to see the entire log) you should see your Access and Refresh tokens displayed.

If you like you can set DEBUG to TRUE in globalSettings.h, and also view progress of the app on the Xcode console.
