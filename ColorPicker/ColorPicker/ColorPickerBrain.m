//
//  ColorPickerBrain.m
//  ColorPicker
//
//  Created by Jesse Nelson on 9/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerBrain.h"

@implementation ColorPickerBrain
@synthesize redValue, greenValue, blueValue;
- ( UIColor * )getColor {
    return [ UIColor colorWithRed:self.redValue   / 255.0
                            green:self.greenValue / 255.0
                             blue:self.blueValue  / 255.0
                            alpha:100 ];
}
@end
