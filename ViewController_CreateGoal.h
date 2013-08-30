//
//  ViewController_CreateGoal.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/2/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_CreateGoal : UIViewController<UITextFieldDelegate> {
    NSMutableDictionary *myNewGoal;
}


- (IBAction)deleteGoal:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteGoalBtn;

- (IBAction)saveGoal;

- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *goalName;
@property (weak, nonatomic) IBOutlet UITextField *goalDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *goalDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *goalType;
@property (weak, nonatomic) IBOutlet UIButton *goalImage;
@property (weak, nonatomic) IBOutlet UISwitch *goalPrivacy;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id userItem;
@end
