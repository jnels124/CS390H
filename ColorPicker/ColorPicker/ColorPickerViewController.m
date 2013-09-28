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

@synthesize
redTextField, greenTextField, blueTextField,
redStepper,   greenStepper,   blueStepper,
redPicker,    greenPicker,    bluePicker,
display,
hundredsFlag,
firebase,
dictionaryOfCurrentColor,
dictionaryOfSavedColors,
possibleValuesForListPickerComponents,
valuesForComponent1ForListPicker,
valuesForComponent2ForListPicker,
valuesForComponent3ForListPicker,
stringBuilderForRedPicker,
stringBuilderForGreenPicker,
stringBuilderForBluePicker;

- (void)viewDidLoad {
    [ super viewDidLoad ];
    
    self.firebase = [ [ Firebase alloc ] initWithUrl:
                     @"https://colorpicker.firebaseio.com"];
    self.dictionaryOfSavedColors = [ [ NSMutableDictionary alloc ] init ];
    self.dictionaryOfCurrentColor = [ [ NSMutableDictionary alloc ] init ];
    
    self.brain.redValue = self.brain.greenValue = self.brain.blueValue = 0;
    
    
    
    
    // Load values for number pickers
    self.possibleValuesForListPickerComponents =  [ [ NSArray  alloc ] init ];
    self.valuesForComponent1ForListPicker      =  [ [ NSArray  alloc ] init ];
    self.valuesForComponent2ForListPicker      =  [ [ NSArray  alloc ] init ];
    self.valuesForComponent3ForListPicker      =  [ [ NSArray  alloc ] init ];
    
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
        [ valuesForComponent1ForListPicker arrayByAddingObject:
         [ NSNumber numberWithInt:i ] ];
    }
    
    for ( int i =0; i <=9; i++ ) {
        self.possibleValuesForListPickerComponents =
        [ self.possibleValuesForListPickerComponents arrayByAddingObject:
         [ NSNumber numberWithInt:i ] ];
        self.valuesForComponent2ForListPicker =
        [ valuesForComponent2ForListPicker arrayByAddingObject:
         [NSNumber numberWithInt:i ] ];
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
        //[ self.redPicker selectRow:2 inComponent:0 animated:TRUE] ;
    }
    
    else {
        [ ColorPickerViewController displayInvalidSenderError ];
    }
    
    [ self setDisplayBackgroundColor ];
}

- (void)setDisplayBackgroundColor {
    self.display.backgroundColor =  self.brain.getColor;
}

- (IBAction)savePressed:( UIButton *)sender {
    UIAlertView *requestColrName =
    [ [ UIAlertView alloc ] initWithTitle:
     @"Save"
                                  message:
     @"What would you like to"
     @"name the color?"
                                 delegate:
     self
                        cancelButtonTitle:
     @"Cancel"
                        otherButtonTitles:
     @"save", nil ];
    requestColrName.alertViewStyle = UIAlertViewStylePlainTextInput;
    [ requestColrName show ];
    
}

- (IBAction)recallPressed:( UIButton * )sender {
}

+ (void)displayInvalidSenderError {
    UIAlertView *alert = [ [ UIAlertView alloc ]
                          initWithTitle:@"Invalid Sender"
                          message:@"This method must be called with sender"
                          @" of type UIStepper | UITextField"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil ];
    [ alert show ];
}

#pragma mark - UITextField Methods
- ( BOOL ) textFieldShouldReturn:(UITextField *)textField {
    if ( textField == self.redTextField   ||
        textField == self.greenTextField  ||
        textField == self.blueTextField     ) {
        
        [ textField resignFirstResponder ]; //Hide keyboard
    }
    
    return NO;
}

#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
                                            (NSInteger)buttonIndex {
    [ self.dictionaryOfSavedColors setObject:
     [ [ NSArray alloc ] initWithObjects:
      [ NSString stringWithFormat:@"%d",
       self.brain.redValue   ],
      [ NSString stringWithFormat:@"%d",
       self.brain.greenValue ],
      [ NSString stringWithFormat:@"%d",
       self.brain.blueValue  ],
      nil
      ]                forKey:[ alertView textFieldAtIndex:0 ].text/*[ NSString stringWithFormat:@"%@",
                                       [requestColrName textFieldAtIndex:0 ].text ]*/
     ];
    
    [ [ firebase childByAppendingPath:ROUTE_TO_SAVED ]
     setValue:self.dictionaryOfSavedColors ];
    //NSLog(@"Inside the box %@ ", self.alertTextField.text );
}

#pragma mark - UIPickerView Methods
- ( NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView {
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

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [ NSString stringWithFormat:@"%d", ( row ) ];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if ( pickerView == self.redPicker ) {
        self.stringBuilderForRedPicker =
        [ self.stringBuilderForRedPicker stringByReplacingCharactersInRange:
         NSMakeRange( component, 1 )
                                                                 withString:
         [ NSString stringWithFormat:
          @"%d", row ] ];
        
        self.brain.redValue = [ self.stringBuilderForRedPicker intValue ];
        //NSLog(@"The value of the redvalue is ", stringBuilderForRedPicker ); ;
        printf( "The value of the redvalue is %d\n", brain.redValue );
        
        NSLog(@"The value for the string builder is %@\n", stringBuilderForRedPicker );
        
        self.redTextField.text = self.stringBuilderForRedPicker;
        
        [ self.redPicker reloadAllComponents ];
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
        
        [ self.greenPicker reloadAllComponents ];
    }
    
    if ( pickerView == self.bluePicker ) {
        self.stringBuilderForBluePicker =
        [ self.stringBuilderForBluePicker stringByReplacingCharactersInRange:
         NSMakeRange( component, 1 )
                                                                  withString:
         [ NSString stringWithFormat:
          @"%d", row ] ];
        self.brain.blueValue = [ self.stringBuilderForBluePicker intValue ];
        self.blueTextField.text = self.stringBuilderForBluePicker;
        
        [ self.bluePicker reloadAllComponents ];
    }
    
    [ self setDisplayBackgroundColor ];
    
    switch ( component ) {
        case TENS_COMPONENT:
            if ( row == 5 && self.hundredsFlag ) {
                self.valuesForComponent3ForListPicker = [ self.possibleValuesForListPickerComponents
                                                         subarrayWithRange:NSMakeRange( 0, 6 ) ];
            }
            else {
                self.valuesForComponent3ForListPicker = self.possibleValuesForListPickerComponents;
            }
            
            break;
            
            
        case HUNDREDS_COMPONENT:
            if( row == 2 ) {
                self.valuesForComponent2ForListPicker = [ self.possibleValuesForListPickerComponents
                                                         subarrayWithRange:NSMakeRange( 0, 6 ) ];
                self.hundredsFlag = TRUE;
            }
            
            else {
                self.valuesForComponent2ForListPicker = self.possibleValuesForListPickerComponents;
                self.hundredsFlag = FALSE;
            }
            
            break;
            
        default:
            break;
    }
    
    [ self.dictionaryOfCurrentColor setObject:[ NSString stringWithFormat:@"%d",
                                               self.brain.redValue ] forKey:@"Red" ];
    [ self.dictionaryOfCurrentColor setObject:[ NSString stringWithFormat:@"%d",
                                               self.brain.greenValue ] forKey:@"Green" ];
    [ self.dictionaryOfCurrentColor setObject:[ NSString stringWithFormat:@"%d",
                                               self.brain.blueValue ] forKey:@"Blue" ];
    [ firebase setValue:self.dictionaryOfCurrentColor ];
}


@end
