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

#import "ViewController_SingleGoalView.h"
#import "Cell_GoalDetail.h"

@interface ViewController_SingleGoalView ()
- (void)configureView;
@end

@implementation ViewController_SingleGoalView


#pragma mark - Managing the detail item

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
    Cell_GoalDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:indexPath];
    
    NSLog(@"tablevie %@", tableView);
    
    // Here we use the new provided setImageWithURL: method to load the web image
    cell.activityText.text = [[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.activityName.text = [[mySubGoals objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
}


#pragma mark - Get Data from JSON
- (NSArray *)getSubGoals {
    NSString *myURL = [[NSString stringWithFormat:@"%@?", _GETURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (IBAction)didSwipeGoalTable:(id)sender {
    NSLog(@"%@", @"swipe1");
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipelocation = [sender locationInView:self.tableViewSubGoals];
        NSIndexPath *swipedIndexPath = [self.tableViewSubGoals indexPathForRowAtPoint:swipelocation];
        //UITableViewCell *swipedCell = [self.tableViewSubGoals cellForRowAtIndexPath:swipedIndexPath];
        
        Cell_GoalDetail *swipedCell = [sender dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:swipedIndexPath];
        
//        NSLog(@"%@", sender.view.subviews);
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:swipedCell.activityName.text range:(NSRange){0,[attributeString length]}];

   
        //swipedCell.viewContainer [NSString stringWithFormat:@"%@", attributeString];
        
//                    NSLog(@"test %@",[swipedCell.viewContainer viewWithTag:_TAGGOALTITLE]);
        //NSLog(@"%@", swipedCell.viewContainer );
        
//        Cell_GoalDetail *cell = [self.tableViewSubGoals dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:0];
        
        

        
    }
}

- (IBAction)didSwipe:(id)sender {
}
@end
