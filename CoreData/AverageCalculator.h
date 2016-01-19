//
//  AverageCalculator.h
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AverageCalculator : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *averageLabel;
@property (strong, nonatomic) IBOutlet UITextField *fromDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *toDateTextField;
- (IBAction)save_btnClicked:(id)sender;
- (IBAction)reset_btnClicked:(id)sender;
@end
