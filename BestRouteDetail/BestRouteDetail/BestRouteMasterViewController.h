//
//  BestRouteMasterViewController.h
//  BestRouteDetail
//
//  Created by Jesse Nelson on 10/31/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BestRouteBrain.h"
//#import "BestRouteTableViewController.h"
#import "BestRouteAnnotation.h"
#import "BestRouteMapViewController.h"
#import "RouteViewController.h"

@class BestRouteTableViewController;
@protocol myBestRouteTableControllerDelegate
- (void) myBestRouteTableControllerDidSelectSegment:
(NSString *)selectedSegment
                                             sender:
(BestRouteTableViewController * )sender;
@end
@interface BestRouteMasterViewController : UITableViewController
< myBestRouteTableControllerDelegate >  {
    int      numberOfRows;
    //NSMutableArray  *itemsToDisplay;
    BestRouteBrain *brain;   // Read only property created in implementation
    NSString *textFromSegmentSelection;
}



@property int      numberOfRows;
@property NSMutableArray *itemsToDisplay;
@property NSString *textFromSegmentSelection;
@property
(nonatomic, unsafe_unretained)
id<myBestRouteTableControllerDelegate> delegate;

-(id)init;
@end
