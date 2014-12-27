//
//  BestRouteMasterViewController.m
//  BestRouteDetail
//
//  Created by Jesse Nelson on 10/31/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteMasterViewController.h"

#import "BestRouteDetailViewController.h"

@interface BestRouteMasterViewController ()
@property (readonly) BestRouteBrain *brain;
@end

@implementation BestRouteMasterViewController
@synthesize
itemsToDisplay,
numberOfRows,
delegate,
textFromSegmentSelection;

// Lazy instantiation of brain
- (BestRouteBrain *) brain {
    if ( !brain ) {
        brain = [ [ BestRouteBrain alloc ] init ];
    }
    return brain;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:) ];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.itemsToDisplay = [ [ NSMutableArray alloc ] init ];
    self.textFromSegmentSelection = [ [ NSString alloc ] init ];
    self.numberOfRows = 0;
    
    NSData *testWrite =
    [ NSData dataWithContentsOfFile:[ self.brain getFilePathByAppending:@"segments" ] ];
    
    if ( testWrite ) {
        self.brain.segments =
        [ NSKeyedUnarchiver unarchiveObjectWithData:testWrite ];
        //for (NSString *) key in [ self.brain.segments allKeys ];
        //self.savedDataTable.itemsToDisplay =
        //[ self.brain.segments allKeys ];
        if ( !self.brain.segments )
            NSLog( @"The data read into segments in viewDidLoad is null" );
        else
            NSLog(@"The segments object was reconstructed successfully");
        
    } else NSLog(@"testWrite is null in BestRouteViewController viewDidLoad");
    
    for ( NSString *key in [ self.brain.segments allKeys ] ) {
        NSLog(@"The key is %@", key );
        //NSDictionary *values = [ ]
        BestRouteSegment *test = [ self.brain.segments objectForKey:key ];
        if (!test.routesForSegment) NSLog(@"Entire dictionary of routes in null");
        //NSDictionary *values = [ test.routesForSegment objectForKey:key ];
        Route *test1 = [ test.routesForSegment objectForKey:key ];
        if (!test1) NSLog(@"the route is null");
        else NSLog(@"The key for the route is %@", test1.routeName );
        //BestRouteTrip *test1 = [ test.routesForSegment objectForKey:key ];
        //NSLog(@"The trip time associated with route %f", test1.tripTime );
    }
    self.itemsToDisplay =
    [ [ NSMutableArray alloc] initWithArray:[ self.brain.segments allValues ] ];
    
    [ self.tableView registerClass:[ UITableViewCell class ] forCellReuseIdentifier:@"SegmentCell" ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSLog(@"Inser New Object was called in master view");
    if (!self.itemsToDisplay) {
        self.itemsToDisplay = [[NSMutableArray alloc] init];
    }
    //[ self presentViewController:mapview animated:YES completion:nil ];
    [ self performSegueWithIdentifier:@"toMapView" sender:self ];
    /*if (!self.itemsToDisplay) {
        self.itemsToDisplay = [[NSMutableArray alloc] init];
    }
    [ self.itemsToDisplay insertObject:[ self.brain newSegment ] atIndex:0 ];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:0 ];
    [ self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic ]; */
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCell" forIndexPath:indexPath];

    BestRouteSegment *object = self.itemsToDisplay[ indexPath.row ];
    cell.textLabel.text = object.segmentName;//[object description];
    return cell;*/
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCell" forIndexPath:indexPath];
    
    BestRouteSegment *object = self.itemsToDisplay[indexPath.row];
    cell.textLabel.text = object.segmentName;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        [ self.itemsToDisplay removeObjectAtIndex:indexPath.row ];
        [ tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Prepare for segue called in master view");
    NSIndexPath *indexPath = [ self.tableView indexPathForSelectedRow ];
    if ([ [ segue identifier ] isEqualToString:@"toRoutes" ] ) {
        BestRouteSegment *object =
        self.itemsToDisplay[indexPath.row];
        NSMutableArray *values =
        [ [ NSMutableArray alloc ] initWithArray:
         [ object.routesForSegment allValues ] ];
        
        [ [ segue destinationViewController ]
         setObjects:values ];
        NSLog(@"Prepare for segue called in master view toRoutes");
       // [ [ segue destinationViewController ] setDetailItem:object.routesForSegment ];
        //[ [ segue destinationViewController ] setDetailItem:
         //[ object.routesForSegment allKeys ] ];
        //[ [ segue destinationViewController ] set];
    }
    
    if ( [ [ segue identifier ] isEqualToString:@"toMapView" ] ) {
        //BestRouteSegment *object =
        //[ self.brain.segments objectForKey:self.itemsToDisplay[indexPath.row] ];
        [ [ segue destinationViewController ] setBrain:self.brain ];
        NSLog(@"Perform segue called on way to mapView");
    }
    
    //if ( [ [ segue identifier ] isEqualToString:<#(NSString *)#>])
}

/*-(void) setItemsToDisplay:(NSMutableArray *)items {
    NSLog(@"Items to display in master view called");
    self.itemsToDisplay = items;
} */

@end
