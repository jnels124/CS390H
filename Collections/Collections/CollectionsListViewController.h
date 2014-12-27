//
//  CollectionsListViewController.h
//  Collections
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brain.h"
#import "CollectionsMasterViewController.h"

@interface CollectionsListViewController : UITableViewController {
    Brain *brain;
}
@property ZBarReaderViewController *reader;
@end
