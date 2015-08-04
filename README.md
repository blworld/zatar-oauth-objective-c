# Oauth_Test_1
Using Oauth 2.0 to authorize a native iOS app 
# Running this sample app
To run this app, simply import the entire project into your own Xcode environment. The app was written with Xcode 6.4, so make sure you have this version or higher.
## Getting Started
The app should compile and run on any iOS device, including the simulator. It has a minimal UI, but it does use constraints, so it should at least be readable on any device type you choose.
Before you can run the code, you'll need to do the following:
 1. Obtain a valid ClientID and Secret from the site you want to obtain authorization from. By default, the app is set to try to gain authorization from Zatar but that can be changed in the header file named "globalSettings.h". 
 Just open up this file using Xcode and look for the #define ROOTURI statement. Then change the "rootUri" value to whatever you want.
 2. You will need to create the Base64 encoded equivalent of your ClientID:Secret and insert it in the globalSettings.h file where indicated.
 3. 
