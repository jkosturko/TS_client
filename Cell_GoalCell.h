//
//  Cell_GoalCell.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/2/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_GoalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goalTitle;
@property (weak, nonatomic) IBOutlet UILabel *goalDate;
@property (weak, nonatomic) IBOutlet UIImageView *goalImage;
@property (weak, nonatomic) IBOutlet UILabel *goalPoints;

@end
