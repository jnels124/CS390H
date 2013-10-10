//
//  ColorPickerSavedColorTableViewController.m
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/3/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerSavedColorTableViewController.h"

@interface ColorPickerSavedColorTableViewController ()

@end

@implementation ColorPickerSavedColorTableViewController
@synthesize
itemsToDisplay,
numberOfRows,
delegate,
textFromColorSelection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [ super viewDidLoad ];
    
    NSLog(@"In table view did load");
    
    //Register reusable cell from storyboard to be used later.
    /*[ self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell" ];*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) init {
    if ( self = [ super init ] ) {
        self.itemsToDisplay = [ [ NSArray alloc ] init ];
        self.textFromColorSelection = [ [ NSString alloc ] init ];
        self.numberOfRows = 0;
        
        [ self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell" ];
    }
    return self;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"Number of sections in table view was called");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"The number of rows in table view is %d", self.numberOfRows );
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =
    [ tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                     forIndexPath:indexPath ];
    if ( cell == nil ) {
        cell =
        [ [ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier ];
    }
    cell.textLabel.text =
    [ self.itemsToDisplay objectAtIndex:indexPath.row ];
    
    return cell;
}

#pragma mark - TableViewController delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    self.textFromColorSelection = [ [ NSString alloc ] init ];
    UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
    self.textFromColorSelection = cell.textLabel.text;
    
    [ delegate myColorPickTableControllerDidSelectColor:
     self.textFromColorSelection sender:self ]; // Tell main screen user
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */
@end
