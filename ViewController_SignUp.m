//
//  ViewController_SignUp.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/1/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#define _POSTURL @"http://tsdev.spielly.com/users.json"
#define _SEGUETOPROFILE @"newUserSuccess"
#define _MAINCONTROLLER @"SCViewController"
#import "ViewController_SignUp.h"
#import "SCViewController.h"
#import "constants.h"

@interface ViewController_SignUp () {
    NSMutableDictionary *userLoginInfo;
}
@end

@implementation ViewController_SignUp


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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.userFirst.delegate = self;
    self.userLast.delegate = self;
    self.userEmail.delegate = self;
    self.userPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Model - Post Data to JSON
- (NSDictionary *)addUser:(NSString *)userName lastName:(NSString *)lastName firstName:(NSString *)firstName password:(NSString *)password private:(BOOL)private  {
    NSString *post = [NSString stringWithFormat:@"[user]username=%@&[user]last_name=%@&[user]first_name=%@&[user]password=%@&[user]private=%c", userName,lastName, firstName, password, private];
    
   NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:_POSTURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
   
   // NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    userLoginInfo = [[NSMutableDictionary alloc] initWithDictionary:json];
    [self handleUserLoginFeedback:json];
    
//    NSLog(@"%@ testjson", json);

    return json;
    
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


- (void)checkUIforSubmitErrors {
    //check for blank fields
}

//- (IBAction)submitNewUser {
//    [self checkUIforSubmitErrors];
//    
//    //Submit New User to Database
//    NSDictionary *reply = [self addUser:_userEmail.text lastName:_userLast.text firstName:_userLast.text password:_userPassword.text];
//  
//    if ([reply valueForKey:@"id"] ) {
//        [self performSegueWithIdentifier:@"newUserSuccess" sender:self];
//    }
//    else {
//        //Report Database Errors
//        //NSLog(@"%@", [[reply valueForKey:@"username"] objectAtIndex:0]);
//        NSLog(@"%@", reply);
//    }
//}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitNewUser:(UIBarButtonItem *)sender {
    
    [self checkUIforSubmitErrors];
    
    //Submit New User to Database
    NSDictionary *reply = [self addUser:_userEmail.text lastName:_userLast.text firstName:_userFirst.text password:_userPassword.text private:YES];
    
    if ([reply valueForKey:@"id"] ) {
        [self performSegueWithIdentifier:_SEGUETOPROFILE sender:self];
    }
    else {
        //Report Database Errors
        //NSLog(@"%@", [[reply valueForKey:@"username"] objectAtIndex:0]);
    }
}

#pragma mark View - Return on Keyboard works
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
