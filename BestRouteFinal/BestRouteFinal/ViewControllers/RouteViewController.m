//
//  RouteViewController.m
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController () {

}

@end

@implementation RouteViewController
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton =
    [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                     target:self
                                                     action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) insertNewObject:(id)sender {
    UIAlertView *routeAlert =
    [ [ UIAlertView alloc ] initWithTitle:@"New route"
                                  message:@"Name your route."
                                 delegate:self
                        cancelButtonTitle:@"Cancel"//@"Browse Data"
                        otherButtonTitles:@"Save", nil ];
    routeAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    routeAlert.delegate = self;
    
    [ routeAlert show ];
}


- (void) setBrain:(BestRouteBrain *)brain {
    _brain = brain;
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.brain.currentSegment.routeKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Route *object =
    [ self.brain.currentSegment.routesForSegment objectForKey:self.brain.currentSegment.routeKeys[indexPath.row] ];
    
    NSString *cellText =
    [ object.routeName stringByAppendingString:
     [ NSString stringWithFormat:@" (%f min) ", object.avgRouteTime ] ];
    
    cell.textLabel.text = cellText;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [ self.tableView reloadData ];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Route *objectToRemove =
        [ self.brain.currentSegment.routesForSegment valueForKey:self.brain.currentSegment.routeKeys[ indexPath.row ] ];
        
        NSMutableDictionary *newRoutes =
        [ [ NSMutableDictionary alloc ]
         initWithDictionary:self.brain.currentSegment.routesForSegment ];
        [ newRoutes removeObjectForKey:objectToRemove.routeName ];
        self.brain.currentSegment.routesForSegment =
        [ [ NSDictionary alloc ] initWithDictionary:newRoutes ];
        
        NSMutableArray *newRouteKeys =
        [ [ NSMutableArray alloc ] initWithArray:self.brain.currentSegment.routeKeys];
        [ newRouteKeys removeObjectAtIndex:indexPath.row ];
        self.brain.currentSegment.routeKeys =
        [ [ NSArray alloc ] initWithArray:newRouteKeys ];
        [ tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [ self.brain writeData ];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) getRoutesByAverage {
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
        NSIndexPath *indexPath =
        [ NSIndexPath indexPathForRow:self.brain.currentSegment.routeKeys.count
                            inSection:0 ];
        Route *newRoute =
        [ [ Route alloc ]initWithRouteName:[ alertView textFieldAtIndex:0 ].text ];
        self.brain.currentSegment.routesForSegment =
        [ self.brain.currentSegment addRoute:newRoute withRouteName:newRoute.routeName ];
        self.brain.currentRoute = newRoute;
        self.brain.currentSegment.routeKeys =
        [ self.brain.currentSegment addKey:newRoute.routeName ];
        
        [ self.tableView insertRowsAtIndexPaths:@[indexPath]
                               withRowAnimation:UITableViewRowAnimationAutomatic ];
        [ self.brain writeData ];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [ [ segue identifier ] isEqualToString:@"toTripsView" ] ) {
        
        NSIndexPath *indexPath =
        [ self.tableView indexPathForSelectedRow ];
        Route *object =
        [ self.brain.currentSegment.routesForSegment valueForKey:self.brain.currentSegment.routeKeys[ indexPath.row ] ];
        self.brain.currentRoute = object;
        [ [ segue destinationViewController ] setBrain:self.brain ];
    }
}

@end
