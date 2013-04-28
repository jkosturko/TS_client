//
//  ViewController_CreateSubGoal.h
//  thriveconnect
//
//  Created by Jessica Kosturko on 4/20/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_CreateSubGoal : UIViewController<UITextFieldDelegate> {
        NSMutableDictionary *myNewSubGoal;
        UIDatePicker *myDatePicker;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldTargetDate;

- (IBAction)pushSave:(UIBarButtonItem *)sender;
- (IBAction)pushCancel:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITextField *textFieldSubGoal;

@end
