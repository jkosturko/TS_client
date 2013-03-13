//
//  ViewController_SingleGoalView.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

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
        
        NSLog(@"%@", [self.detailItem description]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource methods and related helpers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//[myGoals count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Cell_GoalDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:indexPath];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    cell.activityText.text = @"Can't Stop. Won't stop. I covered some serious distance";//[[myGoals objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.activityName.text = @"2.02 mi run";
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
