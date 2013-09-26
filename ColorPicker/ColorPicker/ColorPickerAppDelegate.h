//
//  ColorPickerAppDelegate.h
//  ColorPicker
//
//  Created by Jesse Nelson on 9/21/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerViewController;

@interface ColorPickerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ColorPickerViewController *viewController;

@end
