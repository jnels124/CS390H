//
//  ViewController.h
//  ColorPicker
//
//  Created by Jesse Nelson on 9/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerBrain.h"

#define HUNDREDS_COMPONENT 0
#define TENS_COMPONENT     1
#define ONES_COMPONENT     2

@interface ColorPickerViewController : UIViewController
< UIPickerViewDataSource, UIPickerViewDelegate > {
    ColorPickerBrain      *brain;
    IBOutlet UITextField  *redTextField;
    IBOutlet UITextField  *greenTextField;
    IBOutlet UITextField  *blueTextField;
    IBOutlet UIStepper    *redStepper;
    IBOutlet UIStepper    *greenStepper;
    IBOutlet UIStepper    *blueStepper;
    IBOutlet UITextView   *display;
    IBOutlet UIPickerView *redPicker;
    IBOutlet UIPickerView *greenPicker;
    IBOutlet UIPickerView *bluePicker;
    __weak IBOutlet UIButton *test;
    
             NSArray      *valuesForComponent1ForListPicker;
             NSArray      *valuesForComponent2ForListPicker;
             NSArray      *valuesForComponent3ForListPicker;
             NSArray      *possibleValuesForListPickerComponents;
    
             NSString     *stringBuilderForRedPicker;
             NSString     *stringBuilderForGreenPicker;
             NSString     *stringBuilderForBluePicker;
             Boolean      hundredsFlag;
}

@property IBOutlet UITextField  *redTextField;
@property IBOutlet UITextField  *greenTextField;
@property IBOutlet UITextField  *blueTextField;
@property IBOutlet UIStepper    *redStepper;
@property IBOutlet UIStepper    *greenStepper;
@property IBOutlet UIStepper    *blueStepper;
@property IBOutlet UITextView   *display;
@property IBOutlet UIPickerView *redPicker;
@property IBOutlet UIPickerView *greenPicker;
@property IBOutlet UIPickerView *bluePicker;

@property          NSArray      *possibleValuesForListPickerComponents;
@property          NSArray      *valuesForComponent1ForListPicker;
@property          NSArray      *valuesForComponent2ForListPicker;
@property          NSArray      *valuesForComponent3ForListPicker;
@property          NSString     *stringBuilderForRedPicker;
@property          NSString     *stringBuilderForGreenPicker;
@property          NSString     *stringBuilderForBluePicker;
@property          Boolean      hundredsFlag;

- (IBAction)redChanged:( id )sender;
- (IBAction)greenChanged:( id )sender;
- (IBAction)blueChanged:( id )sender;

- (void)setDisplayBackgroundColor;

+ ( void )displayInvalidSenderError;

@end
