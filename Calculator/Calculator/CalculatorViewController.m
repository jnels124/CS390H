//
//  ViewController.m
//  Calculator
//
//  Created by Jesse Nelson on 5/21/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CalculatorViewController.h"

//@interface CalculatorViewController ()

//@end
@interface CalculatorViewController () // Added this to work with properties . connector
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *) brain {
    if ( !brain ) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    //NSString *digit = [[sender titleLabel] text];
    NSString *digit = sender.titleLabel.text;
    if (userIsInTheMiddleOfTypingANumber) {
        //[display setText:[[display text] stringByAppendingString:digit]];
        display.text = [display.text stringByAppendingString:digit];
    }
    else {
        //[display setText:digit];
        display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (userIsInTheMiddleOfTypingANumber) {
        //[[self brain] setOperand:[[display text] doubleValue]];
        self.brain.operand = [display.text doubleValue]; // with dot notation
        userIsInTheMiddleOfTypingANumber = NO;
    }
    //find out what operation was pressed
    //NSString *operation = [[sender titleLabel ] text ];
    NSString *operation = sender.titleLabel.text;
    //double result = [[self brain] performOperation:operation ];
    [self.brain performOperation:operation];
    // use getter created by using @property instead
    //[display setText:[NSString stringWithFormat:@"%g", result]];
    display.text = [NSString stringWithFormat:@"%g", self.brain.operand];
}

- (IBAction)colorChangePressed:(UIButton *)sender {
    UIApplication *test = [ UIApplication sharedApplication ];
    
    BOOL found =
    [ test openURL:[ NSURL URLWithString:@"colorPicker://" ] ];
    
    if (found) NSLog( @"Resource was found" );
    
    else NSLog(@"unable to locate resource" );
    
}

/*
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 } */

@end
