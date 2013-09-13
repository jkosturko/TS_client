//
//  ViewController_CreateSubGoal.h
//  thriveconnect
//
//  Created by Jessica Kosturko on 4/20/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_CreateSubGoal : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
        NSMutableDictionary *myNewSubGoal;
        UIDatePicker *myDatePicker;
        UIPickerView *pickerViewCategories;
}

- (IBAction)switchGoalComplete:(UISwitch *)sender;

@property (strong, nonatomic) IBOutlet UISwitch *boolGoalCompleted;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id userItem;
@property (strong, nonatomic) id parentID;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTargetDate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCategory;

- (IBAction)pushSave:(UIBarButtonItem *)sender;
- (IBAction)pushCancel:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITextField *textFieldSubGoal;

@end
