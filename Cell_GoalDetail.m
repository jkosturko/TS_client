//
//  Cell_GoalDetail.m
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import "Cell_GoalDetail.h"
#import <QuartzCore/QuartzCore.h>

#define _GOALIDTAG 10

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

- (IBAction)buttonDeleteGoal:(UIButton *)sender {
    UILabel *labelWithGoalId = (UILabel *)[[sender superview] viewWithTag:_GOALIDTAG];
    [self deleteGoalonServer:labelWithGoalId.text];
}

//I will set the deleted flag on the server to true
//Really should update my dataObj and then send to the server
-(void)deleteGoalonServer:(NSString *)goalID {
    NSLog(@"Deleting Goal!, %@", goalID );
    //Reload current page with new table?
}

@end
