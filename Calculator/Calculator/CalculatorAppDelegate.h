//
//  CalculatorAppDelegate.h
//  Calculator
//
//  Created by Jesse Nelson on 10/10/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"
@interface CalculatorAppDelegate : UIResponder <UIApplicationDelegate> {
    UIColor *selectedColor;
}

@property (strong, nonatomic) UIWindow *window;
@property UIColor *selectedColor;;
@end
