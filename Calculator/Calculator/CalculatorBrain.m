//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jesse Nelson on 5/21/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

@synthesize operand;
/*- (void)setOperand:(double)anoperand {
 operand = anoperand;
 } */ //use synthesize instead

-(void)performWaitingOperation {
    if ([@"+" isEqual:waitingOperation]) {
        operand = waitingOperand + operand;
    }
    
    else if ([@"-" isEqual:waitingOperation]) {
        operand = waitingOperand - operand;
    }
    
    else if ([@"*" isEqual:waitingOperation]) {
        operand = waitingOperand * operand;
    }
    
    else if ([@"/" isEqual:waitingOperation]) {
        if (operand) { // Make sure not dividing by 0!
            operand = waitingOperand / operand;
        }
    }
    
}

- (double)performOperation:(NSString *)operation {
    if ([operation isEqual:@"sqrt"] ) { //[] Means sending a message!
        operand = sqrt(operand);
    }
    
    else if ([operation isEqual:@"1/x"] ) {
        if ( operand ) { //Check for 0!
            operand = 1 / operand;
        }
    }
    
    else if ([operation isEqual:@"+/-"] ) { //[] Means sending a message!
        operand *= -1;
    }
    
    else if ([operation isEqual:@"cos"] ) { //[] Means sending a message!
        operand = cos(operand);
    }
    
    else if ([operation isEqual:@"sin"] ) { //[] Means sending a message!
        operand = sin(operand);
    }
    
    else {
        [self performWaitingOperation ];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    return operand;
}

@end
