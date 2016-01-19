//
//  SubjectEntryFormVC.h
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectEntryFormVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *englishTextField;
@property (strong, nonatomic) IBOutlet UITextField *scienceTextField;
@property (strong, nonatomic) IBOutlet UITextField *mathsTextField;
@property (strong, nonatomic) IBOutlet UITextField *tamilTextField;
@property (strong, nonatomic) IBOutlet UITextField *historyTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

- (IBAction)save_btnClicked:(id)sender;
- (IBAction)proceed_btnClicked:(id)sender;
- (IBAction)reset_btnClicked:(id)sender;

@end
