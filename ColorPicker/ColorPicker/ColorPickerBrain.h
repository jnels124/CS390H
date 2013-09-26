//
//  ColorPickerBrain.h
//  ColorPicker
//
//  Created by Jesse Nelson on 9/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPickerBrain : NSObject {
    int redValue,
        greenValue,
        blueValue;
}

@property int redValue;
@property int greenValue;
@property int blueValue;

- ( UIColor * )getColor;
@end
