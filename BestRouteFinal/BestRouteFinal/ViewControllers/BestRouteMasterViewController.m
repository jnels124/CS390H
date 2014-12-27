//
//  BestRouteMasterViewController.m
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteMasterViewController.h"

#import "BestRouteDetailViewController.h"

@interface BestRouteMasterViewController () {
    //NSMutableArray *_itemsToDisplay;
}

@property (readonly) BestRouteBrain *brain;
@end

@implementation BestRouteMasterViewController

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
    [ super viewDidLoad ];
    
    // Set up navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Read in persistent data
    NSData *segments =
    [ NSData dataWithContentsOfFile:[ self.brain getFilePathByAppending:@"segments" ] ];
    
    NSData *segmentKeys =
    [ NSData dataWithContentsOfFile:[ self.brain getFilePathByAppending:@"segmentKeys" ] ];
    if ( segments ) {
        self.brain.segments =
        [ NSKeyedUnarchiver unarchiveObjectWithData:segments ];
        self.brain.segmentKeys =
        [ NSKeyedUnarchiver unarchiveObjectWithData:segmentKeys ];
        
        if ( !self.brain.segments )
            NSLog( @"The data read into segments in viewDidLoad is null" );
        else
            NSLog(@"The segments object was reconstructed successfully");
        
    } else NSLog(@"testWrite is null in BestRouteViewController viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

// Gets segment info from user and stores segment in dictionary
- (void)insertNewObject:(id)sender {
    UIAlertView *segmentNotification =
    [ [ UIAlertView alloc ] initWithTitle:@"New segment"
                                  message:@"Name your segment."
                                 delegate:self
                        cancelButtonTitle:@"Cancel"//@"Browse Data"
                        otherButtonTitles:@"Save", nil ];
    segmentNotification.alertViewStyle = UIAlertViewStylePlainTextInput;
    segmentNotification.delegate = self;
    [ segmentNotification show ];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.brain.segmentKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    BestRouteSegment *object =
    [ self.brain.segments objectForKey:self.brain.segmentKeys[indexPath.row] ];
    cell.textLabel.text = object.segmentName;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BestRouteSegment *itemToRemove =
        [ self.brain.segments objectForKey:self.brain.segmentKeys[ indexPath.row ] ];
        NSMutableDictionary *newSegments =
        [ [ NSMutableDictionary alloc ] initWithDictionary:self.brain.segments ];
        [ newSegments removeObjectForKey:itemToRemove.segmentName ];
        self.brain.segments =
        [ [ NSDictionary alloc ] initWithDictionary:newSegments ];
        
        NSMutableArray *newKeys =
        [ [ NSMutableArray alloc ] initWithArray:self.brain.segmentKeys ];
        [ newKeys removeObjectAtIndex:indexPath.row ];
        self.brain.segmentKeys =
        [ [ NSArray alloc ] initWithArray:newKeys ];
        
        [ tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade ];
        
        [ self.brain writeData ];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the  class, insert it into the array, and add a new row to the table view.
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
#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) {
        BestRouteSegment *newSegment =
        [ [ BestRouteSegment alloc ] init ];
        newSegment.segmentName =
        [ alertView textFieldAtIndex:0 ].text;
        
        self.brain.segments =
        [ self.brain addSegment:newSegment
                withSegmentName:newSegment.segmentName ];
        self.brain.currentSegment = newSegment;
        self.brain.segmentKeys = [ self.brain addKey:newSegment.segmentName ];
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:self.brain.segmentKeys.count-1 inSection:0 ];
        
        [ self.tableView insertRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic ];
        
        [ self performSegueWithIdentifier:@"toMapView" sender:self ];
    }
}

// Called by the system when segue is triggered
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( ![ [ segue identifier ] isEqualToString:@"toMapView" ] ) {
        NSIndexPath *indexPath = [ self.tableView indexPathForSelectedRow ];
        // Set segment to item selected from table
        BestRouteSegment *object =
        [ self.brain.segments objectForKey:self.brain.segmentKeys[ indexPath.row ] ];
        self.brain.currentSegment = object;
    }
    // Passs the brain to the next view controller
    [ [ segue destinationViewController ] setBrain:self.brain ];
}

@end
