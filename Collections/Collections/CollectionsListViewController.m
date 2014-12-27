//
//  CollectionsListViewController.m
//  Collections
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CollectionsListViewController.h"

@interface CollectionsListViewController () {
    NSMutableArray *_objects;
}

@property (readonly) Brain *brain;
@end

@implementation CollectionsListViewController
@synthesize reader;
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self.brain;
    reader.supportedOrientationsMask =
    ZBarOrientationMaskAll;
    ZBarImageScanner *scanner =
    reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // disable rarely used I2/5 to improve performance
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    NSData *collections =
    [ NSData dataWithContentsOfFile:[ self.brain getFilePathByAppending:@"allCollections" ] ];
    self.brain.allCollections =
    [ NSKeyedUnarchiver unarchiveObjectWithData:collections ];
    NSLog(@"The count in view did load is %d", self.brain.allCollections.count);
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentScanner:)];
    self.navigationItem.rightBarButtonItem = addButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    if( !_objects ) {
        _objects = [ [ NSMutableArray alloc ] init ];
    }
    _objects =
    [ [ NSMutableArray alloc ] initWithArray:[ Brain quickSort:[self.brain.allCollections allKeys]]];
    NSLog(@"There are %d collection types in list view controller", _objects.count);
    [ self.tableView reloadData ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Brain *) brain {
    if ( !brain ) {
        brain = [ [ Brain alloc ] init ];
    }
    return brain;
}

- (void) presentScanner:(id)sender {
    // present and release the controller
    [self presentModalViewController:self.reader
                            animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _objects[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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


#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *selectedCollection =
    [ self.brain.allCollections valueForKey:_objects[indexPath.row]];
    
    [[segue destinationViewController] setTheCollection:selectedCollection];
    [[segue destinationViewController] setBrain:self.brain]; 
}

@end
