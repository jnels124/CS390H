//
//  ColorPickerBrain.h
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorPickerObject.h"
#import <Firebase/Firebase.h>

#define HUNDREDS_COMPONENT 0
#define TENS_COMPONENT     1
#define ONES_COMPONENT     2
#define ROUTE_TO_SAVED      @"/saved"

@interface ColorPickerBrain : NSObject < UIPickerViewDataSource > {
    IBOutlet ColorPickerObject   *red;
    IBOutlet ColorPickerObject   *green;
    IBOutlet ColorPickerObject   *blue;
             NSMutableDictionary *dictionaryOfCurrentColor;
             NSMutableDictionary *dictionaryOfSavedColors;
             Firebase            *firebase;
             NSArray             *possibleValuesForListPickerComponents;
}

@property IBOutlet ColorPickerObject   *red;
@property IBOutlet ColorPickerObject   *green;
@property IBOutlet ColorPickerObject   *blue;
@property          NSMutableDictionary *dictionaryOfCurrentColor;
@property          NSMutableDictionary *dictionaryOfSavedColors;
@property          Firebase            *firebase;
@property          NSArray             *possibleValuesForListPickerComponents;

- (void)makeNewColorObjectFromIBSender:(id)sender
                 ForCurrentColorObject:(ColorPickerObject *)color;
- (ColorPickerObject *)determineColorOfSelectedPicker:(UIPickerView *)selectedPicker;
- (void)handlePickerView:(UIPickerView *)pickerView
         withSelectedRow:(NSInteger)row
           FromComponent:(NSInteger)component;

- (void) resetColor:(ColorPickerObject *)color withNewValue:(NSString*)newValue ;
- (void)setColorComponentsToSelectedColor:(NSArray *)selectedColor;
- ( UIColor * )getColor;
- (id)init;

@end
