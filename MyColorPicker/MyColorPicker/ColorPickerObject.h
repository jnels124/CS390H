//
//  ColorPickerObject.h
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPickerObject : NSObject {
    IBOutlet UITextField  *colorTextField;
    IBOutlet UIStepper    *colorStepper;
    IBOutlet UIPickerView *colorPicker;
             int          colorIntegerValue;
             NSArray      *valuesForComponent1InColorPicker;
             NSArray      *valuesForComponent2InColorPicker;
             NSArray      *valuesForComponent3InColorPicker;
             NSString     *stringBuilder;
             Boolean      hundredsFlag;
}

@property IBOutlet UITextField  *colorTextField;
@property IBOutlet UIStepper    *colorStepper;
@property IBOutlet UIPickerView *colorPicker;
@property          int          colorIntegerValue;
@property          NSArray      *valuesForComponent1InColorPicker;
@property          NSArray      *valuesForComponent2InColorPicker;
@property          NSArray      *valuesForComponent3InColorPicker;
@property          NSString     *stringBuilder;
@property          Boolean      hundredsFlag;

-(id)init;

@end
