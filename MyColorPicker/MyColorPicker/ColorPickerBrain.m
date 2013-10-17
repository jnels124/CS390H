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
    
    NSString *textValueFromSender =
    [ [ NSString alloc ] init ];
    
    if ( [ sender isKindOfClass:[ UIStepper class ] ] ) {
        textValueFromSender =
        [ NSString stringWithFormat:@"%d",
         [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue ] ];
    }
    else if ( [ sender isKindOfClass:[ UITextField class ] ] ) {
        textValueFromSender = ((UITextField *)sender).text;
    }
    
    // (Self note)
    // Consider moving this loop to resetColor method to ensure
    //  calling from outside of this method is handled correctly
    //  from different callers.
    while ( textValueFromSender.length < 3 ) {
        textValueFromSender =
        [ @"0" stringByAppendingString:textValueFromSender ];
    }
    
    [ self resetColor:color withNewValue:textValueFromSender ];
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

- (void)handlePickerView:(UIPickerView *)pickerView
         withSelectedRow:(NSInteger)row
           FromComponent:(NSInteger)component {
    
    ColorPickerObject *selectedColor =
    [ self determineColorOfSelectedPicker:pickerView ];
    
    selectedColor.stringBuilder =
    [ selectedColor.stringBuilder stringByReplacingCharactersInRange:
     NSMakeRange( component, 1 )
                                                          withString:
     [ NSString stringWithFormat:@"%d", row ] ];
    
    selectedColor.colorIntegerValue =
    [ selectedColor.stringBuilder intValue ];
    
    switch ( component ) {
        case TENS_COMPONENT:
            if ( row == 5 && selectedColor.hundredsFlag ) {
                selectedColor.valuesForComponent3InColorPicker =
                [ self.possibleValuesForListPickerComponents
                 subarrayWithRange:NSMakeRange( 0, 6 ) ];
            }
            else {
                selectedColor.valuesForComponent3InColorPicker =
                self.possibleValuesForListPickerComponents;
            }
            break;
        case HUNDREDS_COMPONENT:
            if( row == 2 ) {
                selectedColor.valuesForComponent2InColorPicker =
                [ self.possibleValuesForListPickerComponents
                 subarrayWithRange:NSMakeRange( 0, 6 ) ];
                
                selectedColor.hundredsFlag = TRUE;
            }
            else {
                selectedColor.valuesForComponent2InColorPicker =
                self.possibleValuesForListPickerComponents;
                
                selectedColor.hundredsFlag = FALSE;
            }
            break;
        default:
            break;
    }
    
    [ self resetColor:selectedColor withNewValue:selectedColor.stringBuilder ];
    [ selectedColor.colorPicker reloadAllComponents ];
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
        
        // reset firebase live data
        self.dictionaryOfCurrentColor =
        [ [ NSMutableDictionary alloc ] init ];
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
             }
         } ];
    }
    return self;
}

- (void)setColorComponentsToSelectedColor:(NSArray *)selectedColor {
    [ self resetColor:self.red withNewValue:[ selectedColor objectAtIndex:0 ] ];
    [ self resetColor:self.green withNewValue:[ selectedColor objectAtIndex:1 ] ];
    [ self resetColor:self.blue withNewValue:[ selectedColor objectAtIndex:2 ] ];
}

- (void) resetColor:(ColorPickerObject *)color withNewValue:(NSString*)newValue {
    color.colorStepper.value  =
    color.colorIntegerValue   = [ newValue intValue ];
    color.stringBuilder       =
    color.colorTextField.text = newValue;
    [ self setPickerViewComponents:color.colorPicker
                         WithValue:newValue ];
    // Set firebase live data
    [ self.dictionaryOfCurrentColor setObject:self.red.stringBuilder
                                       forKey:@"Red" ];
    [ self.dictionaryOfCurrentColor setObject:self.green.stringBuilder
                                       forKey:@"Green" ];
    [ self.dictionaryOfCurrentColor setObject:self.blue.stringBuilder
                                       forKey:@"Blue" ];
    
    [ [ self.firebase childByAppendingPath:@"/currentcolor" ]
     setValue:self.dictionaryOfCurrentColor ];
}

- (void) setPickerViewComponents:(UIPickerView *)selectedColor
                       WithValue:(NSString *) colorValue {
    for ( int i = 0; i <= 2; i++ ) {
        [ selectedColor selectRow:
         [ [ NSString stringWithFormat:@"%c",
            [ colorValue characterAtIndex:i ] ] intValue]
                      inComponent:i animated:YES ];
    }
}

@end
