//
//  ViewController.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 2/28/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",@"crazy");
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"email", @"user_likes"];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@",@"viewWillAppear");
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
        NSLog(@"%@", @"loginViewShowingLoggedInUser ");
    // Upon login, transition to the main UI by pushing it onto the navigation stack.
//    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
//    [self.navigationController pushViewController:((UIViewController *)appDelegate.mainViewController) animated:YES];
}

- (void)loginView:(FBLoginView *)loginView {

//      handleError:(NSError *)error{
//    NSString *alertMessage, *alertTitle;
//        NSLog(@"%@", @"loginView");
//    // Facebook SDK * error handling *
//    // Error handling is an important part of providing a good user experience.
//    // Since this sample uses the FBLoginView, this delegate will respond to
//    // login failures, or other failures that have closed the session (such
//    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
//    // and [- requestPermissionAndPost] on `SCViewController` for further
//    // error handling on other operations.
//    
//    if (error.fberrorShouldNotifyUser) {
//        // If the SDK has a message for the user, surface it. This conveniently
//        // handles cases like password change or iOS6 app slider state.
//        alertTitle = @"Something Went Wrong";
//        alertMessage = error.fberrorUserMessage;
//    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
//        // It is important to handle session closures as mentioned. You can inspect
//        // the error for more context but this sample generically notifies the user.
//        alertTitle = @"Session Error";
//        alertMessage = @"Your current session is no longer valid. Please log in again.";
//    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
//        // The user has cancelled a login. You can inspect the error
//        // for more context. For this sample, we will simply ignore it.
//        NSLog(@"user cancelled login");
//    } else {
//        // For simplicity, this sample treats other errors blindly, but you should
//        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
//        alertTitle  = @"Unknown Error";
//        alertMessage = @"Error. Please try again later.";
//        NSLog(@"Unexpected error:%@", error);
//    }
//    
//    if (alertMessage) {
//        [[[UIAlertView alloc] initWithTitle:alertTitle
//                                    message:alertMessage
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
//}

//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    NSLog(@"%@", @"viewshowinglogged out");
////    // Facebook SDK * login flow *
////    // It is important to always handle session closure because it can happen
////    // externally; for example, if the current session's access token becomes
////    // invalid. For this sample, we simply pop back to the landing page.
////    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
////    if (appDelegate.isNavigating) {
////        // The delay is for the edge case where a session is immediately closed after
////        // logging in and our navigation controller is still animating a push.
////        [self performSelector:@selector(logOut) withObject:nil afterDelay:.5];
////    } else {
////        [self logOut];
////    }
//}

//- (void)logOut {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

//- (IBAction)connectToFacebook:(UIButton *)sender {
//}
//}
}
@end
