//
//  ViewController_SignIn.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/3/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#define _GETURL @"http://ts.spielly.com/users/login.json"
#define _SEGUETOPROFILE @"signInToMain"
#import "ViewController_SignIn.h"

@interface ViewController_SignIn ()

@end

@implementation ViewController_SignIn

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
    
//    NSLog(@"%@", dataArray);
    
    return dataArray;
}

//- (IBAction)submitUser:(UIB *)sender {
//    NSArray *user = [self signInUser:_userEmail.text password:_userPassword.text];
//    if ([user valueForKey:@"id"])
//        [self performSegueWithIdentifier:_SEGUETOPROFILE sender:self];
//}

- (IBAction)submitUser:(UIBarButtonItem *)sender {
    NSArray *user = [self signInUser:_userEmail.text password:_userPassword.text];
    if ([user valueForKey:@"id"])
//            [self dismissViewControllerAnimated:YES completion:nil];
       [self performSegueWithIdentifier:_SEGUETOPROFILE sender:self];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark View - Return on Keyboard works
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
