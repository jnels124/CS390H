//
//  CollectionsMasterViewController.h
//  Collections
//
//  Created by Jesse Nelson on 11/15/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brain.h"
@interface CollectionsMasterViewController : UITableViewController
@property (strong, nonatomic) NSDictionary *theCollection;
@property (strong, nonatomic) Brain *brain;
@end
