//
//  ContactDetailsVC.h
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ContactDetailsVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name_textField;
@property (strong, nonatomic) IBOutlet UITextField *number_textField;
@property (strong, nonatomic) IBOutlet UITextField *relationship_textField;
@property (strong, nonatomic) NSManagedObject *contact;

- (IBAction)save_btnClicked:(id)sender;
- (IBAction)back_btnClicked:(id)sender;
@end
