//
//  ColorPickerBrain.m
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerBrain.h"

@implementation ColorPickerBrain

@synthesize
red,
green,
blue,
dictionaryOfSavedColors,
dictionaryOfCurrentColor,
possibleValuesForListPickerComponents,
firebase;

- (void)makeNewColorObjectFromIBSender:( id )sender
                 ForCurrentColorObject:(ColorPickerObject *) color {
    //ColorPickerObject *changedColor = [ [ ColorPickerObject alloc ] init ];
    if ( [ sender isKindOfClass:[ UIStepper class ] ] ) {
        color.colorTextField.text = [ NSString stringWithFormat:@"%d",
                                     [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue ] ];
        color.colorIntegerValue =
        [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue ];
    }
    else if ( [ sender isKindOfClass:[ UITextField class ] ] ) {
        color.colorStepper.value =
        [ [ (UITextField *)sender text ] doubleValue ];
        color.colorIntegerValue =
        [ [ (UITextField *)sender text ] intValue ];
    }
    else { // This shouldn't happen!!!
        //[ ColorPickerViewController displayInvalidSenderError ];
    }
}

- ( UIColor * )getColor {
    return [ UIColor colorWithRed:self.red.colorIntegerValue   / 255.0
                            green:self.green.colorIntegerValue / 255.0
                             blue:self.blue.colorIntegerValue  / 255.0
                            alpha:100 ];
}

#pragma mark - UIPickerView Data Source Methods
- ( NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    ColorPickerObject *selectedColor =
    [ self determineColorOfSelectedPicker:pickerView ];
    
    if ( component == HUNDREDS_COMPONENT ) {
        return [ selectedColor.valuesForComponent1InColorPicker count ];
    }
    
    if ( component == TENS_COMPONENT ) {
        return [ selectedColor.valuesForComponent2InColorPicker count ];
    }
    
    if ( component == ONES_COMPONENT ) {
        return [ selectedColor.valuesForComponent3InColorPicker count ];
    }
    
    return  -1;
}

- (ColorPickerObject *)determineColorOfSelectedPicker:
(UIPickerView *)selectedPicker {
    if ( selectedPicker == self.red.colorPicker ) {
        return self.red;
    }
    
    if ( selectedPicker == self.green.colorPicker ) {
        return self.green;
    }
    
    if ( selectedPicker == self.blue.colorPicker ) {
        return self.blue;
    }
    return nil;
}

- (id) init {
    if ( self = [ super init ] ) {
        self.possibleValuesForListPickerComponents =
        [ [ NSArray alloc ] init ];
        
        for ( int i =0; i <=9; i++ ) {
            self.possibleValuesForListPickerComponents =
            [ self.possibleValuesForListPickerComponents arrayByAddingObject:
             [ NSNumber numberWithInt:i ] ];
        }
        
        self.dictionaryOfCurrentColor =
        [ [ NSMutableDictionary alloc ] init ];

        // Set up firebase
        self.firebase = [ [ Firebase alloc ] initWithUrl:
                         @"https://colorpicker.firebaseio.com"];
        [ [ self.firebase childByAppendingPath:ROUTE_TO_SAVED ]
         observeEventType:FEventTypeValue withBlock:
         ^(FDataSnapshot *snapshot) {
             if ( snapshot.value == [ NSNull null ] ) {
                 self.dictionaryOfSavedColors  =
                 [ [ NSMutableDictionary alloc ] init ];
             }
             else {
                 self.dictionaryOfSavedColors = snapshot.value;
                 NSLog(@"There are %d values in the dictionary ",
                       self.dictionaryOfSavedColors.count );
             }
             
             NSArray *keys  = [ self.dictionaryOfSavedColors allKeys ];
             NSLog(@"There are %d keys ", keys.count );
         } ];
    }
    return self;
}
@end
