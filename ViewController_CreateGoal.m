//
//  ViewController_CreateGoal.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/2/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//
//#define _POSTURL @"http://tsdev.spielly.com/goals.json"
#define _POSTURL @"http://ts.spielly.com/goals.json"
#define _PUTURL @"http://ts.spielly.com/goals/1.json"


#import "ViewController_CreateGoal.h"

@interface ViewController_CreateGoal ()

@end

@implementation ViewController_CreateGoal

- (void)setUserItem:(id)userItem
{
    if (_userItem != userItem) {
        _userItem = userItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {

//        self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"description"];
//        self.goalDate.text = [self.detailItem valueForKey:@"target"];
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
    if (self.detailItem) {
        myNewGoal = [[NSMutableDictionary alloc] initWithDictionary:self.detailItem];
        
        //if you pressed edit then
        self.goalName.text = [self.detailItem objectForKey:@"description"];
        self.goalDate.text= [self.detailItem objectForKey:@"target"];
        self.goalType.text = @"fake category";
        
        _deleteGoalBtn.hidden = NO;
        
    }
    else
        myNewGoal = [[NSMutableDictionary alloc] init];

    
    // Don't remember what this was for
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
- (IBAction)deleteGoal:(UIButton *)sender {

  NSString *url = @"http://ts.spielly.com/goals/2.json";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    
//    [request setURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"DELETE"];
//    NSLog(@"%@",[NSURLConnection connectionWithRequest:request delegate:self] ) ;
//    
   // NSString *post = [NSString stringWithFormat:@"%@", @"/goals/2.json"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
   // NSLog(@"Reply: %@", theReply);
    
}

- (IBAction)saveGoal {
    
    [myNewGoal setValue:_goalName.text forKey:@"name"];
    [myNewGoal setValue:_goalDate.text forKey:@"date"];
    [myNewGoal setValue:_goalType.text forKey:@"type"];
    [myNewGoal setValue:@"" forKey:@"image"];
    [myNewGoal setValue:[NSString stringWithFormat:@"%d",_goalPrivacy.state] forKey:@"privacy"];
    
    [self updateModelwithNewGoal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controller: Update Model with New Goal
- (void)updateModelwithNewGoal {
    if ([myNewGoal objectForKey:@"id"])
        [self updateGoal:[myNewGoal valueForKey:@"name"] category:[myNewGoal valueForKey:@"type"]];
    else
        [self addGoal:[myNewGoal valueForKey:@"name"] category:[myNewGoal valueForKey:@"type"]];
}

#pragma mark - Model - Post Data to JSON
- (void)addGoal:(NSString *)goalName category:(NSString *)categoryName  {
    
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%@&[goal]category=%d&[goal]private=%@&[goal]target=%@", goalName,[_userItem objectForKey:@"id"], 1, @"false", @"2014-09-22"];
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
    // NSLog(@"Reply: %@", theReply);
}


#pragma mark - Model - HTTP PUT: Update Goal
- (void)updateGoal:(NSString *)goalName category:(NSString *)categoryName  {
    NSLog(@"Got to update/modify %@", goalName);
    
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%@&[goal]category=%@&[goal]target=%@", goalName,[_userItem objectForKey:@"id"], categoryName, @"2011-09-22"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:_PUTURL]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    // NSLog(@"Reply: %@", theReply);
}

@end
