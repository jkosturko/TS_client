/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SCAppDelegate.h"
#import "SCViewController.h"
#import "SCLoginViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "TestFlight.h"

@implementation SCAppDelegate

@synthesize window = _window,
            navigationController = _navigationController,
            mainViewController = _mainViewController,
            loginViewController = _loginViewController,
            isNavigating = _isNavigating;

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {

    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    if ([[FBSession activeSession] handleOpenURL:url]) {
        return YES;
    } else {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        // Otherwise extract the app link data from the url and open a new active session from it.
        NSString *appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
        FBAccessTokenData *appLinkToken = [FBAccessTokenData createTokenFromFacebookURL:url
                                                                                  appID:appID
                                                                        urlSchemeSuffix:nil];
        if (appLinkToken) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            } else {
                [self handleAppLink:appLinkToken];
                return YES;
            }
        }
    }
    return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Facebook SDK * pro-tip *
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Test Flight stuff
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"5ae24908-656b-4824-8202-f81209b8e4be"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    
    
    // If you have not added the -ObjC linker flag, you may need to uncomment the following line because
    // Nib files require the type to have been loaded before they can do the wireup successfully.  
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    // [FBProfilePictureView class];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.mainViewController = [sb instantiateViewControllerWithIdentifier:@"SCViewController"];
    self.loginViewController = [sb instantiateViewControllerWithIdentifier:@"SCLoginViewController"];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.navigationController.delegate = self;
    self.window.rootViewController = self.navigationController;

    [self.window makeKeyAndVisible];
    
    // Facebook SDK * pro-tip *
    // We take advantage of the `FBLoginView` in our loginViewController, which can
    // automatically open a session if there is a token cached. If we were not using
    // that control, this location would be a good place to try to open a session
    // from a token cache.
    
    return YES;
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  [self.loginViewController loginView:nil handleError:error];
                              }
                          }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.isNavigating = NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isNavigating = YES;
}

@end
