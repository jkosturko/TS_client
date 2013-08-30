//
//  ViewController_SingleGoalView.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_SingleGoalView : UIViewController{
    NSMutableArray *mySubGoals;
}

- (IBAction)editPressed:(UIBarButtonItem *)sender;
- (IBAction)removeGoal:(UIButton *)sender;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id userItem;

- (IBAction)didSwipeGoalTable:(UISwipeGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSubGoals;
@property (weak, nonatomic) IBOutlet UILabel *goalDate;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
