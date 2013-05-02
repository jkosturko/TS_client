//
//  ViewController_SingleGoalView.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_SingleGoalView : UIViewController{
    NSArray *mySubGoals;
}
@property (strong, nonatomic) id detailItem;

- (IBAction)didSwipeGoalTable:(UISwipeGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableViewSubGoals;
@property (weak, nonatomic) IBOutlet UILabel *goalDate;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
