//
//  Cell_GoalDetail.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_GoalDetail : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UILabel *labelGoalId;

- (IBAction)buttonDeleteGoal:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *mySubGoalTitle;
@property (strong, nonatomic) IBOutlet UITextView *activityText;
@property (strong, nonatomic) IBOutlet UITextView *activityName;
@property (weak, nonatomic) IBOutlet UIImageView *GoalBorderImage;
@end
