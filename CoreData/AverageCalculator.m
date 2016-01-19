//
//  AverageCalculator.m
//  CoreData
//
//  Created by Orbgen on 28/11/15.
//  Copyright (c) 2015 Orbgen Technologies pvt. ltd. All rights reserved.
//

#import "AverageCalculator.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AverageCalculator ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray* dateArray;
    NSMutableArray* cellSelected;
    UIPickerView* pickerView;
    NSArray* subjectArray;
    NSManagedObjectContext *managedObjectContext;
    int tagValue;
   
}
@end

@implementation AverageCalculator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellSelected = [[NSMutableArray alloc]init];
    subjectArray = @[@"English",@"Science",@"Maths",@"Tamil",@"History"];
    managedObjectContext = [self managedObjectContext];
    [self createPickerView];
}
-(void)createPickerView
{
    pickerView = [[UIPickerView alloc]init];
    pickerView.center = self.view.center;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView setTintColor:[UIColor lightGrayColor]];
    
    _fromDateTextField.inputView = pickerView;
    _toDateTextField.inputView = pickerView;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    
    [pickerToolbar setItems:@[cancelBtn, flexSpace, doneBtn] animated:YES];
    [pickerToolbar setTintColor:[UIColor whiteColor]];
    _fromDateTextField.inputAccessoryView = pickerToolbar;
    _toDateTextField.inputAccessoryView = pickerToolbar;
}

- (void)doneButtonPressed :(id)sender
{
    NSInteger row = [pickerView selectedRowInComponent:0];
    UITextField *textField = (UITextField *)[self.view viewWithTag:tagValue];
    textField.text = [dateArray objectAtIndex:row];
    [textField resignFirstResponder];
}
- (void)cancelButtonPressed :(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:tagValue];
    [textField resignFirstResponder];
}
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dateArray.count;
}
- (void)pickerView:(UIPickerView *)pickerViewW didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = [dateArray objectAtIndex:row];
    
    return returnStr;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pickerView setHidden:NO];
    tagValue = (int)textField.tag;
    if (textField.tag == 1)
    {
        dateArray = [[NSMutableArray alloc]initWithObjects:@"12-06-2015",@"13-06-2015", @"14-06-2015",@"15-06-2015",nil];
    }
    else
    {
        dateArray = [[NSMutableArray alloc]initWithObjects:@"13-06-2015", @"14-06-2015",@"15-06-2015",@"16-06-2015",nil];
    }
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:YES];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return subjectArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell Initialisation here
    static NSString* identifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = [subjectArray objectAtIndex:indexPath.row];
    
    if ([cellSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
    //self.selectedIndexPath = indexPath;
    
    //the below code will allow multiple selection
    if ([cellSelected containsObject:indexPath])
    {
        [cellSelected removeObject:indexPath];
    }
    else
    {
        [cellSelected addObject:indexPath];
    }
    [tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save_btnClicked:(id)sender
{
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
 
    NSMutableArray * selectedSubjectsPredicate = [[NSMutableArray alloc]init];

    // Create Predicate
    NSPredicate *predicate1 =  [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self getDate:_fromDateTextField], [self getDate:_toDateTextField]];
    
    [selectedSubjectsPredicate addObject:predicate1];
    
     NSMutableString* predicateString = [[NSMutableString alloc]initWithString:@"("];
    for (NSIndexPath *indexPath in cellSelected )
    {
        NSString* subjectName = [subjectArray objectAtIndex:indexPath.row];
        [predicateString appendString:[NSString stringWithFormat:@"subjectName == \"%@\"",subjectName]];
        if ([indexPath isEqual:[cellSelected lastObject]]) {
            [predicateString appendString:@")"];
        }
        else
        {
            [predicateString appendString:@" OR "];
        }
    }
    
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:predicateString];
    [selectedSubjectsPredicate addObject:predicate];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:selectedSubjectsPredicate];
    [fetchRequest setPredicate:compoundPredicate];
    
//     Add Sort Descriptor
//    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortDescriptor1]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    int mark = 0;
    if (!fetchError) {
        for (NSManagedObject *managedObject in result)
        {
            NSNumber* number = [managedObject valueForKey:@"mark"];
            mark += [number intValue];
            NSLog(@"name - %@, mark - %@ ,date -%@",[managedObject valueForKey:@"subjectName"],[managedObject valueForKey:@"mark"],[managedObject valueForKey:@"date"]);
            
        }
        int average = mark / result.count;
        _averageLabel.text = [NSString stringWithFormat:@"%i",average];
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
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
    return YES;
    
}
- (IBAction)reset_btnClicked:(id)sender
{
    NSArray *stores = [[([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)] persistentStores];
    
    for(NSPersistentStore *store in stores)
    {
        [[([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)] removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    stores = [[([UIApplication sharedApplication].delegate) performSelector:@selector(persistentStoreCoordinator)] persistentStores];
    BOOL canSave = [self canSave];
    if (canSave)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        exit(0);
    }
}
-(NSDate *)getDate : (UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:textField.text];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateFromString];
    [comps setDay:(comps.day + 1)];
    dateFromString = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSLog(@"date - %@",dateFromString);
    return dateFromString;
    
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
