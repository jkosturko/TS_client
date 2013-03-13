//
//  ViewController_SingleGoalView.h
//  thriveconnect
//
//  Created by Kosturko, Jessica on 3/11/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_SingleGoalView : UIViewController

@property (strong, nonatomic) id detailItem;


@property (weak, nonatomic) IBOutlet UILabel *goalDate;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
