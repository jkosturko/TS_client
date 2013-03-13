//
//  Cell_GoalDetail.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_GoalDetail : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UITextView *activityText;
@property (weak, nonatomic) IBOutlet UITextView *activityName;
@property (weak, nonatomic) IBOutlet UIImageView *GoalBorderImage;
@end
