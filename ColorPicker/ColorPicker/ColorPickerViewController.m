//
//  ViewController.m
//  ColorPicker
//
//  Created by Jesse Nelson on 9/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerViewController.h"

@interface ColorPickerViewController ()
@property (readonly) ColorPickerBrain *brain;
@end

@implementation ColorPickerViewController

@synthesize redTextField, greenTextField, blueTextField,
            redStepper,   greenStepper,   blueStepper,
            redPicker,    greenPicker,    bluePicker,
            display,
            valuesForComponent1ForListPicker,
            valuesForComponent2ForListPicker,
            valuesForComponent3ForListPicker,
            stringBuilderForRedPicker, stringBuilderForGreenPicker, stringBuilderForBluePicker;

- (void)viewDidLoad {
    [ super viewDidLoad ];
    
    // Load values for number pickers
    self.valuesForComponent1ForListPicker =  [ [ NSArray  alloc ] init ];
    self.valuesForComponent2ForListPicker =  [ [ NSArray  alloc ] init ];
    self.valuesForComponent3ForListPicker =  [ [ NSArray  alloc ] init ];
    
    // Initialze strings for textField
    self.redTextField.text           =
    self.greenTextField.text         =
    self.blueTextField.text          =
    
    // Initialze strings for picker string builders
    self.stringBuilderForRedPicker   =
    self.stringBuilderForGreenPicker =
    self.stringBuilderForBluePicker  = @"000";
    
    for ( int i =0; i <=2; i++ ) {
        self.valuesForComponent1ForListPicker =
                [ valuesForComponent1ForListPicker arrayByAddingObject:[ NSNumber numberWithInt:i ] ];
    }
    
    for ( int i =0; i <=9; i++ ) {
        self.valuesForComponent2ForListPicker =
                [ valuesForComponent2ForListPicker arrayByAddingObject:[NSNumber numberWithInt:i ] ];
        self.valuesForComponent3ForListPicker =
                [ valuesForComponent3ForListPicker arrayByAddingObject:[NSNumber numberWithInt:i ] ];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

// Lazy instantiation of brain
- ( ColorPickerBrain * ) brain {
    if ( !brain ) {
        brain = [ [ ColorPickerBrain alloc ] init ];
    }
    return brain;
}

- (IBAction)redChanged:( id )sender {
    if ( [ sender isKindOfClass:[ UIStepper class ] ] ) {
        self.redTextField.text = [ NSString stringWithFormat:@"%d",
                                  [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue ] ];
        self.brain.redValue = [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue ];
    }
    else if ( [ sender isKindOfClass:[ UITextField class ] ] ) {
        self.redStepper.value = [ [ (UITextField *)sender text ] doubleValue ];
        self.brain.redValue = [ [ (UITextField *)sender text ] intValue ];
    }
    else { // This shouldn't happen!!!
        [ ColorPickerViewController displayInvalidSenderError ];
    }
    
    [ self setDisplayBackgroundColor ];
}

- (IBAction)greenChanged:( id )sender {
    if ( [ sender isKindOfClass:[ UIStepper class ] ] ) {
        self.greenTextField.text = [ NSString stringWithFormat:@"%d",
                                    [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value ] ] intValue] ];
        self.brain.greenValue = [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value] ] intValue ];
    }
    
    else if ( [ sender isKindOfClass:[ UITextField class ] ] ) {
        self.greenStepper.value = [ [ (UITextField *)sender text ] doubleValue ];
        self.brain.greenValue = [ [ (UITextField *)sender text ] intValue ];
    }
    
    else {
        [ ColorPickerViewController displayInvalidSenderError ];
    }
    
    [ self setDisplayBackgroundColor ];
}

- (IBAction)blueChanged:( id )sender {
    if ( [ sender isKindOfClass:[ UIStepper class ] ] ) {
        self.blueTextField.text = [ NSString stringWithFormat:@"%d",
                                   [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value] ] intValue] ];
        self.brain.blueValue = [ [ NSNumber numberWithDouble:[ (UIStepper *) sender value] ] intValue ];
    }
    
    else if ( [ sender isKindOfClass:[ UITextField class ] ] ) {
        self.blueStepper.value = [ [ (UITextField *)sender text ] doubleValue ];
        self.brain.blueValue = [ [ (UITextField *)sender text ] intValue ];
        [self.redPicker selectRow:2 inComponent:0 animated:TRUE];
    }
    
    else {
        [ ColorPickerViewController displayInvalidSenderError ];
    }
    
    [ self setDisplayBackgroundColor ];
}

- (void)setDisplayBackgroundColor {
    self.display.backgroundColor =  self.brain.getColor;
}

+ (void)displayInvalidSenderError {
    UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle:@"Invalid Sender"
                                                       message:@"This method must be called with sender"
                                                                @" of type UIStepper | UITextField"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil ];
    [ alert show ];
}

#pragma mark - UIPickerView Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ( component == HUNDREDS_COMPONENT ) {
        return [ self.valuesForComponent1ForListPicker count ];
    }
    
    if ( component == TENS_COMPONENT ) {
        return [ self.valuesForComponent2ForListPicker count ];
    }
    
    if ( component == ONES_COMPONENT ) {
        return [ self.valuesForComponent3ForListPicker count ];
    }
    
    return  -1; 
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
                                    (NSInteger)row forComponent:(NSInteger)component {
    /*if ( component == HUNDREDS_COMPONENT ) {
        return [ NSString stringWithFormat:@"%@",  [ valuesForComponent1ForListPicker objectAtIndex:row ] ];
    }
    
    if ( component == TENS_COMPONENT ) {
        return [ NSString stringWithFormat:@"%@",  [ valuesForComponent1ForListPicker objectAtIndex:row ] ];
    }
    
    if ( component == ONES_COMPONENT ) {
        return [ NSString stringWithFormat:@"%@",  [ valuesForComponent1ForListPicker objectAtIndex:row ] ];
    }
    return @""; */
    return [ NSString stringWithFormat:@"%d", ( row ) ];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
                                               inComponent:(NSInteger)component {
    if ( pickerView == self.redPicker ) {
        
        self.stringBuilderForRedPicker =
        [ self.stringBuilderForRedPicker stringByReplacingCharactersInRange:
                                            NSMakeRange( component, 1 )
                                                                 withString:
                                                [ NSString stringWithFormat:
                                                    @"%d", row ]                    ];
        
         self.brain.redValue = [ self.stringBuilderForRedPicker intValue ];
        //NSLog(@"The value of the redvalue is ", stringBuilderForRedPicker ); ;
        printf( "The value of the redvalue is %d\n", brain.redValue );
        
        NSLog(@"The value for the string builder is %@\n", stringBuilderForRedPicker );
        /*switch ( component ) {
            case ONES_COMPONENT:
                
                
                break;
            case TENS_COMPONENT:
                break;
            case HUNDREDS_COMPONENT:
                
                break;
            default:
                break;
        }*/
        self.redTextField.text = self.stringBuilderForRedPicker;
        [ self setDisplayBackgroundColor ];
    }
    
    if ( pickerView == self.greenPicker ) {
        self.stringBuilderForGreenPicker =
        [ self.stringBuilderForGreenPicker stringByReplacingCharactersInRange:
                                                NSMakeRange( component, 1 )
                                                                 withString:
                                                [ NSString stringWithFormat:@"%d", row ] ];
        
        printf( "The value of the green value is %d\n", brain.redValue );
        
        NSLog(@"The value for the string builder is %@", stringBuilderForGreenPicker );
        
        self.brain.greenValue = [ self.stringBuilderForGreenPicker intValue ];
        printf( "The value of the green value is %d\n", brain.redValue );
        
        NSLog(@"The value for the string builder is %@", stringBuilderForGreenPicker );
        self.greenTextField.text = self.stringBuilderForGreenPicker;
        [ self setDisplayBackgroundColor ];
        
    }
    
    if ( pickerView == self.bluePicker ) {
        self.stringBuilderForBluePicker =
        [ self.stringBuilderForBluePicker stringByReplacingCharactersInRange:
                                    NSMakeRange( component, 1 )
                                                                   withString:
                                    [ NSString stringWithFormat:@"%d", row ] ];
        self.brain.blueValue = [ self.stringBuilderForBluePicker intValue ];
        self.blueTextField.text = self.stringBuilderForBluePicker;
        [ self setDisplayBackgroundColor ];
        
    }
}


@end
