//
//  ViewController_CreateGoal.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/2/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//
#define _POSTURL @"http://ts.spielly.com/goals.json"
#define _USERID 1


#import "ViewController_CreateGoal.h"

@interface ViewController_CreateGoal ()

@end

@implementation ViewController_CreateGoal

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
    myNewGoal = [[NSMutableDictionary alloc] init];
    
    self.goalName.delegate = self;
    self.goalDate.delegate = self;
    self.goalType.delegate = self;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark View - Return on Keyboard works
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - View Get Saved Goal from view
- (IBAction)saveGoal {
    
    [myNewGoal setValue:_goalName.text forKey:@"name"];
    [myNewGoal setValue:_goalDate.text forKey:@"date"];
    [myNewGoal setValue:_goalType.text forKey:@"type"];
    [myNewGoal setValue:@"" forKey:@"image"];
    [myNewGoal setValue:[NSString stringWithFormat:@"%d",_goalPrivacy.state] forKey:@"privacy"];
    
    [self sendNewGoal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controller: Update Model with New Goal
- (void)sendNewGoal {
    [self addGoal:[myNewGoal valueForKey:@"name"] category:[myNewGoal valueForKey:@"type"]];
}

#pragma mark - Model - Post Data to JSON
- (void)addGoal:(NSString *)goalName category:(NSString *)categoryName  {
    
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%d&[goal]category=%@&[goal]target=%@", goalName,_USERID, categoryName, @"2011-09-22"];
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
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
}

@end
