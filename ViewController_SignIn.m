//
//  ViewController_SignIn.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/3/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#define _GETURL @"http://tsdev.spielly.com/users/login.json"
#define _POSTURL @"http://tsdev.spielly.com/users/login.json"
#define _SEGUETOPROFILE @"signInToMain"
#import "ViewController_SignIn.h"
#import "SCViewController.h"

@interface ViewController_SignIn () {
    NSMutableDictionary *userLoginInfo;
}
- (void)configureView;
@end

@implementation ViewController_SignIn

- (void)setDetailItem:(id)newDetailItem
{


}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.userPassword.delegate = self;
    self.userEmail.delegate = self;
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Data from JSON
- (NSArray *)signInUser:(NSString *)username password:(NSString *)password {
    NSString *myURL = [[NSString stringWithFormat:@"%@?username=%@&password=%@", _GETURL, username, password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonFeed = [NSData dataWithContentsOfURL:[NSURL URLWithString:myURL]];
    
    NSArray *dataArray = nil;
    if (jsonFeed) {
        dataArray = [NSJSONSerialization JSONObjectWithData:jsonFeed options:kNilOptions error:nil];
    }
    
    return dataArray;
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginUser:(UIBarButtonItem *)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@", _GETURL, _userEmail.text, _userPassword.text];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", urlString, [responseCode statusCode]);
    }

    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:oResponseData options:kNilOptions error:&error];
    userLoginInfo = [[NSMutableDictionary alloc] initWithDictionary:json];
    [self handleUserLoginFeedback:json];
}

//View: This will check if the userID was returned and allow enterance into the app
//and also push the segue
- (void)handleUserLoginFeedback:(NSDictionary *)returnedUserObj {
    if ([returnedUserObj objectForKey:@"id"])
    {
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:_SEGUETOPROFILE sender:self];
    }
}

//Data: Sends data to next view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:_SEGUETOPROFILE]) {
        SCViewController *myController = segue.destinationViewController;
        [myController setUserItem:userLoginInfo];
    }
}

#pragma mark View - Return on Keyboard works
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
