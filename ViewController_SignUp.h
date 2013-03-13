//
//  ViewController_SignUp.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/1/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_SignUp : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *userFirst;
@property (weak, nonatomic) IBOutlet UITextField *userLast;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
//- (IBAction)submitNewUser;

- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)submitNewUser:(UIBarButtonItem *)sender;

@end
