//
//  TableViewController.h
//  ColorPicker
//
//  Created by Jesse Nelson on 9/29/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    int      numberOfRows;
    NSArray  *itemsToDisplay;
    NSString *textFromColorSelection;
}

@property int      numberOfRows;
@property NSArray  *itemsToDisplay;
@property NSString *textFromColorSelection;
@end
