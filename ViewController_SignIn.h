//
//  ViewController_SignIn.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/3/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_SignIn : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) id detailItem;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)loginUser:(UIBarButtonItem *)sender;


@end
