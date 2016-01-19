//
//  SubjectEntryFormVC.m
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import "SubjectEntryFormVC.h"
#import "AppDelegate.h"
#import "AverageCalculator.h"
#import <CoreData/CoreData.h>

@interface SubjectEntryFormVC ()
{
    NSArray* subjectArray;
     NSArray* dateArray;
    NSManagedObjectContext *managedObjectContext;
    UIActivityIndicatorView *activity;
    
}
@end

@implementation SubjectEntryFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:self.view.center];
    [activity setColor:[UIColor blackColor]];
    [self.view addSubview:activity];
    
    subjectArray = [[NSMutableArray alloc]init];
    subjectArray = @[@"English",@"Science",@"Maths",@"Tamil",@"History"];
    
    dateArray = [[NSArray alloc]initWithObjects:@"12-06-2015",@"13-06-2015", @"14-06-2015",@"15-06-2015",@"16-06-2015",nil];
    managedObjectContext = [self managedObjectContext];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
-(NSDate *)getDate
{
    unichar ch = [_dateTextField.text characterAtIndex:2];
    unichar ch2 = [_dateTextField.text characterAtIndex:5];
    int count = (int)_dateTextField.text.length;
    
    if ((ch == '/') && (ch2 == '/') && (count == 10))
    {
        //valid date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:_dateTextField.text];
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateFromString];
        [comps setDay:(comps.day + 1)];
        dateFromString = [[NSCalendar currentCalendar] dateFromComponents:comps];
        return dateFromString;
    }
    else
    { 
        //not a valid date
        return nil;
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save_btnClicked:(id)sender
{
    [activity startAnimating];
    if (![self getDate])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Enter Valid Date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    managedObjectContext = [self managedObjectContext];
    for (int i = 0; i < subjectArray.count; i++)
    {
        UITextField* textField = (UITextField *)[self.view viewWithTag:(i+1)];
        
        NSManagedObject *subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:managedObjectContext];
        [subject setValue:[subjectArray objectAtIndex:i] forKey:@"subjectName"];
        [subject setValue:[NSNumber numberWithInt:[textField.text intValue]] forKey:@"mark"];
        [subject setValue:[self getDate] forKey:@"date"];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    [activity stopAnimating];
   
    
}
-(BOOL)checkData
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Subject"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date == %@",[self getDate]];
    [fetchRequest setPredicate:predicate];
    NSError* error = nil;
    NSArray* array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array.count > 0)
    {
        
    }
    return YES;
}
-(BOOL)canSave
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSInferMappingModelAutomaticallyOption];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)];
    
    NSURL* storeURL = [[((AppDelegate *)[UIApplication sharedApplication].delegate) applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    NSError* error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}
- (IBAction)reset_btnClicked:(id)sender
{
    NSArray *stores = [[([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)] persistentStores];
    for(NSPersistentStore *store in stores)
    {
        NSError* error = nil;
        [[([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)] removePersistentStore:store error:&error];
        
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    BOOL canSave = [self canSave];
    if (canSave)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Done!!" message:@"Reset Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    }
    else
    {
        exit(0);
    }
}
- (IBAction)proceed_btnClicked:(id)sender
{
    AverageCalculator* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AverageCalculator"];
    [self.navigationController pushViewController:controller animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
