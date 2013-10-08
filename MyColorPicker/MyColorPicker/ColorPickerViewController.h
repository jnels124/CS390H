//
//  ColorPickerViewController.h
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerBrain.h"
#import "ColorPickerSavedColorTableViewController.h"

@interface ColorPickerViewController : UIViewController
< UITextFieldDelegate, UIPickerViewDelegate,
  myColorPickTableControllerDelegate > {
    IBOutlet UITextView       *display;
    IBOutlet ColorPickerBrain *brain;
    ColorPickerSavedColorTableViewController *savedColorView;
}

@property IBOutlet UITextView *display;
@property ColorPickerSavedColorTableViewController *savedColorView;

- (IBAction)redChanged:( id )sender;
- (IBAction)greenChanged:(id)sender;
- (IBAction)blueChanged:(id)sender;
- (IBAction)savePressed:(id)sender;
- (IBAction)RecallPressed:(id)sender;
- (void)setDisplayBackgroundColor;

@end