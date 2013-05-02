//
//  ViewController_CreateSubGoal.m
//  thriveconnect
//
//  Created by Jessica Kosturko on 4/20/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

//#define _POSTURL @"http://tsdev.spielly.com/goals.json"
#define _POSTURL @"http://ts.spielly.com/goals.json"
#define _USERID 1

#import "ViewController_CreateSubGoal.h"

@interface ViewController_CreateSubGoal ()

@end

@implementation ViewController_CreateSubGoal

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
    
    myNewSubGoal = [[NSMutableDictionary alloc] init];
    
    myDatePicker = [[UIDatePicker alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSave:(UIBarButtonItem *)sender {
    
    [myNewSubGoal setValue:_textFieldSubGoal.text forKey:@"name"];
    [myNewSubGoal setValue:_textFieldTargetDate.text forKey:@"date"];
    
    NSLog(@"%@", myNewSubGoal);

    [self updateModelwithNewGoal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controller: Update Model with New Goal
- (void)updateModelwithNewGoal {
//    if ([myNewSubGoal objectForKey:@"id"])
//        NSLog(@"%@",@"updating logic here");// [self updateGoal:[myNewSubGoal valueForKey:@"name"] category:[myNewSubGoal valueForKey:@"type"]];
//    else
        [self addSubGoal:[myNewSubGoal valueForKey:@"name"] targetDate:[myNewSubGoal valueForKey:@"date"]];
}

#pragma mark - Model - Post Data to JSON
- (void)addSubGoal:(NSString *)goalName targetDate:(NSString *)targetDate {
    int parentId =  1;
    int categoryId = 1;
//    NSString *targetDate = @"2013-06-05";
    
    //http://ts.spielly.com/goals.json?[goal]description=SubGoal1&[goal]category=cat1&[goal]parent_id=1&[goal]user_id=1
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%d&[goal]category=%d&[goal]parent_id=%d&[goal]target=%@", goalName,_USERID, categoryId, parentId, targetDate];
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
//        NSLog(@"Reply: %@", theReply);
}
- (IBAction)pushCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    _textFieldTargetDate.inputView = myDatePicker;
    
    [myDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)dateChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    
    _textFieldTargetDate.text = [self getPickerFormat:datePicker readable:YES];
}

- (NSString *)getPickerFormat:(UIDatePicker *)datePicker readable:(BOOL)isReadable {
    NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
    if (isReadable)
        [datePickerFormat setDateFormat:@"MMM dd, yyyy"];
    else
        [datePickerFormat setDateFormat:@"yyyy-mm-dd"];
   
    NSString *datePickerStringToSave = [datePickerFormat stringFromDate:datePicker.date];
    return datePickerStringToSave;
}

@end