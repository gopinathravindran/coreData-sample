//
//  ContactDetailsVC.m
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import "ContactDetailsVC.h"


@interface ContactDetailsVC ()

@end

@implementation ContactDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.contact) {
        [self.name_textField setText:[self.contact valueForKey:@"name"]];
        [self.number_textField setText:[self.contact valueForKey:@"number"]];
        [self.relationship_textField setText:[self.contact valueForKey:@"relationship"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save_btnClicked:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.contact) {
        // Update existing contact
        [self.contact setValue:self.name_textField.text forKey:@"name"];
        [self.contact setValue:self.number_textField.text forKey:@"number"];
        [self.contact setValue:self.relationship_textField.text forKey:@"relationship"];
        
    } else {
    // Create a new managed object
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    [newContact setValue:self.name_textField.text forKey:@"name"];
    [newContact setValue:self.number_textField.text forKey:@"number"];
    [newContact setValue:self.relationship_textField.text forKey:@"relationship"];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back_btnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
