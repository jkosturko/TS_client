//
//  ViewController_CreateSubGoal.m
//  thriveconnect
//
//  Created by Jessica Kosturko on 4/20/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

//#define _POSTURL @"http://tsdev.spielly.com/goals.json"
#define _POSTURL @"http://ts.spielly.com/goals/1/goals.json"
#define _PUTURL @"http://ts.spielly.com/goals/1.json"
#import "ViewController_CreateSubGoal.h"
#import "ViewController_SingleGoalView.h"

@interface ViewController_CreateSubGoal ()
- (void)configureView;
@end

NSString *parentId;

@implementation ViewController_CreateSubGoal

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setParentId:(id)newParentId
{
    myNewSubGoal = [[NSMutableDictionary alloc] init];
    if (parentId != newParentId) {
        parentId = newParentId;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    

    
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
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    myDatePicker = [[UIDatePicker alloc]init];
    
    if (self.detailItem) {
        myNewSubGoal = [[NSMutableDictionary alloc] init];
        NSLog(@"%@self.detailItem", self.detailItem);
        
        //In Edit mode/ prepopulate categories
        _textFieldSubGoal.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"description"]];
        _textFieldTargetDate.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"target"]];
        _textFieldCategory.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"category"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSave:(UIBarButtonItem *)sender {
    [myNewSubGoal setObject:_textFieldSubGoal.text forKey:@"name"];
    [myNewSubGoal setObject:_textFieldTargetDate.text forKey:@"date"];
    [myNewSubGoal setObject:_textFieldCategory.text forKey:@"category"];

    [self updateModelwithNewGoal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Controller: Update Model with New Goal
- (void)updateModelwithNewGoal {
    if (myNewSubGoal) {
        NSLog(@"%@, %@",@"updating logic here", myNewSubGoal);
        [self updateGoal:[myNewSubGoal valueForKey:@"name"] category:[myNewSubGoal valueForKey:@"type"]];
    }
    else
        [self addSubGoal:_textFieldSubGoal.text targetDate:_textFieldTargetDate.text];
}

#pragma mark - Model - Post Data to JSON
- (NSArray *)addSubGoal:(NSString *)goalName targetDate:(NSString *)targetDate {
    int categoryId = 1;
    
    //http://ts.spielly.com/goals.json?[goal]description=SubGoal1&[goal]category=cat1&[goal]parent_id=1&[goal]user_id=1
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%@&[goal]category=%d&[goal]parent_id=%@&[goal]target=%@", goalName,[_userItem objectForKey:@"id"], categoryId, parentId, targetDate];
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
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
    NSLog(@"%@,%@",post, _POSTURL);
    return dataArray;
    
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

#pragma mark - Model - HTTP PUT: Update Goal
- (void)updateGoal:(NSString *)goalName category:(NSString *)categoryName  {
    NSLog(@"Got to update/modify %@", goalName);
    
    NSString *goalDescription = [myNewSubGoal valueForKey:@"name"];
    NSString *category = [myNewSubGoal valueForKey:@"category"];
    NSString *targetDate = [myNewSubGoal valueForKey:@"date"];
    
    NSString *url = [NSString stringWithFormat: @"http://ts.spielly.com/goals/%@.json", [self.detailItem objectForKey:@"id"]];
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]category=%@&[goal]target=%@", goalDescription, category, targetDate];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
     NSLog(@"Reply: %@", theReply);
         NSLog(@"url: %@, post; %@", url, post);
    
    //Reset My new Goal
    myNewSubGoal = [[NSMutableDictionary alloc] init];
}

@end
