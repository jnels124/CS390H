//
//  BestRouteTableViewController.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BestRouteTableViewController;
@protocol myBestRouteTableControllerDelegate
- (void) myBestRouteTableControllerDidSelectSegment:
(NSString *)selectedSegment
                                             sender:
(BestRouteTableViewController * )sender;
@end
@interface BestRouteTableViewController : UITableViewController {
    int      numberOfRows;
    NSArray  *itemsToDisplay;
    NSString *textFromSegmentSelection;
}



@property int      numberOfRows;
@property NSArray  *itemsToDisplay;
@property NSString *textFromSegmentSelection;
@property
(nonatomic, unsafe_unretained)
id<myBestRouteTableControllerDelegate> delegate;

-(id)init;
@end

