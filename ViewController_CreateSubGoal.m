//
//  ViewController_CreateSubGoal.m
//  thriveconnect
//
//  Created by Jessica Kosturko on 4/20/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

//#define _POSTURL @"http://tsdev.spielly.com/goals/1/goals.json"
//#define _PUTURL @"http://tsdev.spielly.com/goals/1.json"
#import "ViewController_CreateSubGoal.h"
#import "ViewController_SingleGoalView.h"

@interface ViewController_CreateSubGoal ()
- (void)configureView;
@end

@implementation ViewController_CreateSubGoal {
    NSArray *arrRequests;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
        NSLog(@"mydetailitem Segue%@", _detailItem);
}

- (void)setParentId:(id)newParentId
{
    myNewSubGoal = [[NSMutableDictionary alloc] init]; //pretty sure this shouldn't go here
    if (_parentID != newParentId) {
        _parentID = newParentId;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //    [self.parentViewController.tableView reloadData];
    NSLog(@"parent controller%@", self.parentViewController);

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
    pickerViewCategories = [[UIPickerView alloc] init];
    pickerViewCategories.showsSelectionIndicator = YES;
    pickerViewCategories.dataSource = self;
    pickerViewCategories.delegate = self;
//    [pickerViewCategories selectRow:1 inComponent:0 animated:YES];
    self.textFieldCategory.inputView = pickerViewCategories;
    
    
    if (self.detailItem) {
        myNewSubGoal = [[NSMutableDictionary alloc] init];
        
        //In Edit mode/ prepopulate categories
        _textFieldSubGoal.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"description"]];
        _textFieldTargetDate.text = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"target"]];
        _textFieldCategory.text = [NSString stringWithFormat:@"%@",[[self.detailItem objectForKey:@"category"] objectForKey:@"name"]];
        
        if (![[self.detailItem objectForKey:@"completion"] isKindOfClass:[NSNull class]] ) {
            [_boolGoalCompleted setOn:YES];
        }
    }
    
    //Make a function for this -also not sure if we want to call this everytime the view loads
    NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://tsdev.spielly.com/categories.json"]];
    arrRequests = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil];
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
    if (myNewSubGoal)
        [self updateGoal:[myNewSubGoal valueForKey:@"name"] category:[myNewSubGoal valueForKey:@"type"]];
    else
        [self addSubGoal:_textFieldSubGoal.text targetDate:_textFieldTargetDate.text];
}

#pragma mark - Model - Post Data to JSON
- (NSArray *)addSubGoal:(NSString *)goalName targetDate:(NSString *)targetDate {
    int categoryId = 1;
    NSString *private = @"true";
    NSString *postURL = @"http://tsdev.spielly.com/goals.json";

    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]user_id=%@&[goal]category_id=%d&[goal]parent_id=%@&[goal]target=%@&[goal]private=%@", goalName,[_userItem objectForKey:@"id"], categoryId, _parentID, targetDate, private];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:postURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
//    NSLog(@"add new subgoal%@,%@",post, postURL);
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
        NSLog(@"Detail item %@", _detailItem);
    NSString *goalDescription = [myNewSubGoal valueForKey:@"name"];
    NSString *category = [myNewSubGoal valueForKey:@"category"];
    NSString *targetDate = [myNewSubGoal valueForKey:@"date"];
    
//    NSString *completion =(_boolGoalCompleted.isOn)
    NSString *completion = [myNewSubGoal valueForKey:@"completion"];
    
    NSString *url = [NSString stringWithFormat: @"http://tsdev.spielly.com/goals/%@.json", [self.detailItem objectForKey:@"id"]];
    NSString *post = [NSString stringWithFormat:@"[goal]description=%@&[goal]category_id=%@&[goal]target=%@&[goal]completion=%@", goalDescription, category, targetDate, completion];
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

- (IBAction)switchGoalComplete:(UISwitch *)sender {
    if (sender.isOn)
        [myNewSubGoal setObject:[self getDatetoString:[NSDate date]] forKey:@"completion"];
    else
        [myNewSubGoal setObject:[NSNull class] forKey:@"completion"];
}

-(NSString *)getDatetoString:(NSDate *)myDate  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateString = [dateFormatter stringFromDate:myDate];
    return dateString;
}


//UIPickerView

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
            [pickerView selectRow:2 inComponent:0 animated:YES];
    return [[arrRequests objectAtIndex:row] objectForKey:@"name"];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.textFieldCategory.text = [[arrRequests objectAtIndex:row] objectForKey:@"name"];
}

@end
