//
//  ColorPickerObject.m
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerObject.h"

@implementation ColorPickerObject

@synthesize
colorPicker,
colorStepper,
colorTextField,
colorIntegerValue,
//possibleValuesForListPickerComponents,
valuesForComponent1InColorPicker,
valuesForComponent2InColorPicker,
valuesForComponent3InColorPicker,
stringBuilder,
hundredsFlag;

- (id) init {
    if ( self = [ super init ] ) {
        //self.possibleValuesForListPickerComponents = [ [ NSArray alloc ] init ];
        self.valuesForComponent1InColorPicker      = [ [ NSArray alloc ] init ];
        self.valuesForComponent2InColorPicker      = [ [ NSArray alloc ] init ];
        self.valuesForComponent3InColorPicker      = [ [ NSArray alloc ] init ];
        
        for ( int i =0; i <=2; i++ ) {
            self.valuesForComponent1InColorPicker =
            [ self.valuesForComponent1InColorPicker arrayByAddingObject:
             [ NSNumber numberWithInt:i ] ];
        }
        
        for ( int i =0; i <=9; i++ ) {
            self.valuesForComponent2InColorPicker =
            [ self.valuesForComponent2InColorPicker arrayByAddingObject:
             [ NSNumber numberWithInt:i ] ];
            
            self.valuesForComponent3InColorPicker =
            [ self.valuesForComponent3InColorPicker arrayByAddingObject:
             [ NSNumber numberWithInt:i ] ];
        }
        self.colorIntegerValue   = 0;
        self.stringBuilder       = @"000";
    }
    return self;
}
@end
