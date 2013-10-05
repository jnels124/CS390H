//
//  ColorPickerSavedColorTableViewController.h
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/3/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColorPickerSavedColorTableViewController;
@protocol myColorPickTableControllerDelegate
-(void)myColorPickTableControllerDidSelectColor:(NSString *)selectedColor sender:(ColorPickerSavedColorTableViewController *)sender;
@end

@interface ColorPickerSavedColorTableViewController : UITableViewController {
    int      numberOfRows;
    NSArray  *itemsToDisplay;
    NSString *textFromColorSelection;
}



@property int      numberOfRows;
@property NSArray  *itemsToDisplay;
@property NSString *textFromColorSelection;
@property
(nonatomic, unsafe_unretained)id<myColorPickTableControllerDelegate> delegate;

-(id)init;
@end
