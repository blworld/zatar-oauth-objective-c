# Oauth_Test_1
Using Oauth 2.0 to authorize a native iOS app on Zatar
# Running this sample app
To run this app, simply import the entire project into your own xCode environment. The app was written with xCode 6.4, so make sure you have this version or higher.
## Getting Started
The app should compile and run on any iOS device, including the simulator. It has a minimal UI, but it does use constraints, so it should at least be readable on any device type you choose.
Before you can run the code, you'll need to do the following:

 1. Obtain a valid ClientID and Secret from the site you want to obtain authorization from.  
 2. Enter your ClientID for the "CLIENT_ID" parameter in the "globalSettings.h" file of the project.
 3. You will need to create the Base64 encoded equivalent of your ClientID:Secret and insert it in the globalSettings.h file where indicated for the BASE_64_CLIENT_ID_SECRET parameter.
 4. By default the project is set to go to Zatar.com for authorization, but this can be changed by changing the "ROOTURI" parameter of the globalSettings.h file. Initially this parameter is set to the Zatar beta test site.

That's it! Once you have valid info entered into globalSettings.h for CLIENT_ID, BASE_64_CLIENT_ID_SECRET, and ROOTURI, the app should compile and run.

When the app runs, simply tap on "Authorize" button to initiate the authorization attempt. This should result in a Safari window opening up. You should be asked by target site for your credentials and to authorize the app to access the resources of your account. Enter your credentials to give authorization, and if the credentials are verified, you should be taken back to this app. 

Once the app returns to the foreground, you should be able to review the entire progress of the process on the event log displayed on the app's main screen. At the bottom of the log (you may have to scroll up/down to see the entire log) you should see your Access and Refresh tokens displayed.

If you like you can set DEBUG to TRUE in globalSettings.h, and also view progress of the app on the xCode console.
