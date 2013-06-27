//
//  Cell_GoalDetail.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import "Cell_GoalDetail.h"
#import <QuartzCore/QuartzCore.h>

@implementation Cell_GoalDetail

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    [self setViewContainerDesign];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setViewContainerDesign {
    _viewContainer.layer.borderColor=[UIColor darkGrayColor].CGColor;
    _viewContainer.layer.borderWidth = 1.0f;
    _viewContainer.layer.cornerRadius = 3;
}
- (IBAction)pressedButtonRemoveSubGoal:(UIButton *)sender {
}
- (IBAction)pressRemoveRowButton:(UIButton *)sender {
}
@end
