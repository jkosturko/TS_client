//
//  ViewController_SingleGoalView.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//


#define _GETURL @"http://ts.spielly.com/goals/1/goals.json"
//#define _GETURL @"http://tsdev.spielly.com/goals/1/goals.json"
#define _TAGGOALTITLE 10
#define _PUTURL @"http://ts.spielly.com/"

#import "ViewController_SingleGoalView.h"
#import "Cell_GoalDetail.h"

@interface ViewController_SingleGoalView () {
    NSString *goalId;
}
- (void)configureView;

@end

@implementation ViewController_SingleGoalView


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        [self setGoalID: _detailItem];
        NSLog(@"%@", goalId);

        
        // Update the view.
        [self configureView];
    }
}

-(void)setGoalID:dataObj {
    goalId = [NSString stringWithFormat:@"%@", [dataObj objectForKey:@"id"]];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"description"];
        self.goalDate.text = [self.detailItem valueForKey:@"target"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    mySubGoals = [self getSubGoals];
    
 //   NSLog(@"%@",mySubGoals);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource methods and related helpers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mySubGoals count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", [[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"completion"]);
    Cell_GoalDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:indexPath];
    

    //Strikethrough title if complete
    if ([[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"completion"] != [NSNull null]) {
        cell.mySubGoalTitle.attributedText =  [self updateStrikeThrough:[[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"description"] add:YES];
    }
    else {
        cell.mySubGoalTitle.text = [[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"description"];
    }
    // Here we use the new provided setImageWithURL: method to load the web image
    cell.activityName.text = [[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.labelGoalId.text = [NSString stringWithFormat:@"%@",[[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"id"] ];
    
    
    //Likely delete this..I was just trying to get a button to be clickable on the table cell
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 20)];
//    [button addTarget:self action:@selector(pressedRemoveButton) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:button];
//    button.backgroundColor = [UIColor yellowColor];
//    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editGoal"]) {
//        if (self.detailItem)
//            NSLog(@"%@", [self.detailItem objectForKey:@"id"] );
////        NSIndexPath *indexPath = [self.goalTableView indexPathForSelectedRow];
//        NSDate *object = myGoals[indexPath.row];
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    
    if ([[segue identifier] isEqualToString:@"newSubGoal"]) {
//        NSIndexPath *indexPath = [self.goalTableView indexPathForSelectedRow];
//        NSDate *object = myGoals[indexPath.row];
        [[segue destinationViewController] setDetailItem:goalId];
    }
}


#pragma mark - Get Data from JSON
- (NSArray *)getSubGoals {
    NSString *myURL = [[NSString stringWithFormat:@"http://ts.spielly.com/goals/%@/goals.json?", goalId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonFeed = [NSData dataWithContentsOfURL:[NSURL URLWithString:myURL]];
    
    NSArray *dataArray = nil;
    if (jsonFeed) {
        dataArray = [NSJSONSerialization JSONObjectWithData:jsonFeed options:kNilOptions error:nil];
    }
    
    return [self mapDataModel:dataArray];
}

//Using different property names incase data model changes : mapping
- (NSArray *)mapDataModel:(NSArray *)dataJsonArrayFromAPI {
    
    //Remove once data is reversed
    NSArray* reversedArray = [[dataJsonArrayFromAPI reverseObjectEnumerator] allObjects];
    NSArray *goalsArray = [[NSArray alloc] initWithArray:reversedArray];

    /*TODO Map Data*/
    return goalsArray;

}

- (IBAction)didSwipeGoalTable:(UISwipeGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [sender locationInView:self.tableViewSubGoals];
        NSIndexPath *swipedIndexPath = [self.tableViewSubGoals indexPathForRowAtPoint:swipeLocation];
        Cell_GoalDetail *swipedCell = [self.tableViewSubGoals cellForRowAtIndexPath:swipedIndexPath];
        
        if (sender.direction == 1){
            swipedCell.mySubGoalTitle.attributedText = [self updateStrikeThrough:swipedCell.mySubGoalTitle.text add:YES];
            [self updateCompleteGoalStatus:swipedCell.labelGoalId.text completed:YES];
            
        }
        else {
            swipedCell.mySubGoalTitle.attributedText = [self updateStrikeThrough:swipedCell.mySubGoalTitle.text add:NO];
            [self updateCompleteGoalStatus:swipedCell.labelGoalId.text completed:NO];
        }
    
    //This isn't the right time to call this I will likely test if swipe is slow and then delete, if swipe is fast, do code above
        NSLog(@"%@", @"ShowRemoveButton");
    [self showRemoveRowButton:swipedCell];
    }


}

//When user swipes (completes task) -strikethrough
-(NSMutableAttributedString *)updateStrikeThrough: (NSString *)text add:(Boolean)addStrikeThrough {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];    
    if (addStrikeThrough) {
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:[NSNumber numberWithInt:2]
                            range:(NSRange){0,[attributeString length]}];
    }
    else {
        [attributeString removeAttribute:NSStrikethroughStyleAttributeName
                                   range:(NSRange){0,[attributeString length]}];
    }
    
    return attributeString;
}

-(void)updateCompleteGoalStatus:(NSString *)goalId completed:(Boolean)completed {
    //I think a lot of these lines can be cleaned...maybe ask Carlos
    NSString *putURL = [NSString stringWithFormat:@"%@goals/%@.json", _PUTURL, goalId];
    NSString *currentDate = [self formatDate:[self getCurrentDate] backend:YES];
    NSString *completionDate = (completed)? currentDate: nil;
    NSString *post = [NSString stringWithFormat:@"[goal]completion=%@", completionDate];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:putURL]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
//        NSLog(@"Reply: %@", theReply);

    
}

-(NSDate *)getCurrentDate {
    return [NSDate date];
}

-(NSString *)formatDate:(NSDate *)date backend:(Boolean)backend {
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];

    if (backend) {
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else {
        [DateFormatter setDateFormat:@"MM dd, yyyy"];
    }
    
    return [DateFormatter stringFromDate:date];
}

-(void)showRemoveRowButton:(Cell_GoalDetail *)swipedCell {
    NSLog(@"I'm deleting you!");
    
    [self deleteGoal];

//    swipedCell.buttonRemoveTableRow.hidden = NO;
//    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideButton:) userInfo:swipedCell.buttonRemoveTableRow repeats:NO];

}

-(void)hideButton:(NSTimer *)timer {
    UIButton *button = timer.userInfo;
    button.hidden = YES;
}

-(IBAction)pressedRemoveButton {
    NSLog(@"Hey you found me!");
}
- (void)deleteGoal {
    
//    //I think a lot of these lines can be cleaned...maybe ask Carlos
//    NSString *putURL = [NSString stringWithFormat:@"%@goals/%@.json", _PUTURL, goalId];
//    NSString *currentDate = [self formatDate:[self getCurrentDate] backend:YES];
//    NSString *completionDate = (completed)? currentDate: nil;
//    NSString *post = [NSString stringWithFormat:@"[goal]completion=%@", completionDate];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:putURL]];
//    [request setHTTPMethod:@"PUT"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLResponse *response;
//    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
//    //        NSLog(@"Reply: %@", theReply);

    
}


@end
