//
//  ColorPickerViewController.m
//  MyColorPicker
//
//  Created by Jesse Nelson on 10/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "ColorPickerViewController.h"

@interface ColorPickerViewController () {
    
}
@property (readonly) ColorPickerBrain *brain;
@end

@implementation ColorPickerViewController
@synthesize
savedColorView,
display;

// Lazy instantiation of brain
- ( ColorPickerBrain * ) brain {
    if ( !brain ) {
        brain = [ [ ColorPickerBrain alloc ] init ];
    }
    return brain;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[ self.brain initializeFirebase ]; ... Being done in init
    
    self.savedColorView =
    [ [ ColorPickerSavedColorTableViewController alloc ] init ];
    self.savedColorView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redChanged:(id)sender {
    [ self.brain makeNewColorObjectFromIBSender:sender
                          ForCurrentColorObject:self.brain.red ];
    [ self setDisplayBackgroundColor ];
}

- (IBAction)greenChanged:(id)sender {
    [ self.brain makeNewColorObjectFromIBSender:sender
                          ForCurrentColorObject:self.brain.green ];
    [ self setDisplayBackgroundColor ];
}

- (IBAction)blueChanged:(id)sender {
    [ self.brain makeNewColorObjectFromIBSender:sender
                          ForCurrentColorObject:self.brain.blue ];
    [ self setDisplayBackgroundColor ];
}

- (IBAction)RecallPressed:(id)sender {
    self.savedColorView.numberOfRows   =
    self.brain.dictionaryOfSavedColors.count;
    self.savedColorView.itemsToDisplay =
    [ self.brain.dictionaryOfSavedColors allKeys ];
    [ self.view addSubview:self.savedColorView.view ];
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

- (void)setDisplayBackgroundColor {
    self.display.backgroundColor =  self.brain.getColor;
}

#pragma mark - UITextField Delegate Methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ( textField == self.brain.red.colorTextField   ||
        textField == self.brain.green.colorTextField  ||
        textField == self.brain.blue.colorTextField     ) {
        [ textField resignFirstResponder ]; //Hide keyboard
    }
    return NO;
}

#pragma mark - UIPickerView Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [ NSString stringWithFormat:@"%d", ( row ) ];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    ColorPickerObject *selectedColor =
    [ self.brain determineColorOfSelectedPicker:pickerView ];
    
    selectedColor.stringBuilder =
    [ selectedColor.stringBuilder stringByReplacingCharactersInRange:
     NSMakeRange( component, 1 )
                                                          withString:
     [ NSString stringWithFormat:@"%d", row ] ];
    
    selectedColor.colorIntegerValue =
    [ selectedColor.stringBuilder intValue ];
    
    switch ( component ) {
        case TENS_COMPONENT:
            if ( row == 5 && selectedColor.hundredsFlag ) {
                selectedColor.valuesForComponent3InColorPicker =
                [ self.brain.possibleValuesForListPickerComponents
                 subarrayWithRange:NSMakeRange( 0, 6 ) ];
            }
            else {
                selectedColor.valuesForComponent3InColorPicker =
                self.brain.possibleValuesForListPickerComponents;
            }
            break;
        case HUNDREDS_COMPONENT:
            if( row == 2 ) {
                selectedColor.valuesForComponent2InColorPicker =
                [ self.brain.possibleValuesForListPickerComponents
                 subarrayWithRange:NSMakeRange( 0, 6 ) ];
                
                selectedColor.hundredsFlag = TRUE;
            }
            else {
                selectedColor.valuesForComponent2InColorPicker =
                self.brain.possibleValuesForListPickerComponents;
                
                selectedColor.hundredsFlag = FALSE;
            }
            break;
        default:
            break;
    }
    [ self.brain.dictionaryOfCurrentColor setObject:
     [ NSString stringWithFormat:@"%d",
      self.brain.red.colorIntegerValue ]
                                             forKey:@"Red" ];
    [ self.brain.dictionaryOfCurrentColor setObject:
     [ NSString stringWithFormat:@"%d",
      self.brain.green.colorIntegerValue ]
                                             forKey:@"Green" ];
    [ self.brain.dictionaryOfCurrentColor setObject:
     [ NSString stringWithFormat:@"%d",
      self.brain.blue.colorIntegerValue ]
                                             forKey:@"Blue" ];
    
    [ [ self.brain.firebase childByAppendingPath:@"/currentcolor" ]
     setValue:self.brain.dictionaryOfCurrentColor ];
    
    selectedColor.colorTextField.text =
    selectedColor.stringBuilder;
    selectedColor.colorStepper.value =
    [ selectedColor.stringBuilder doubleValue ];
    
    [ selectedColor.colorPicker reloadAllComponents ];
    [ self setDisplayBackgroundColor ];
}

#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) {
        [ self.brain.dictionaryOfSavedColors setObject:
         [ [ NSArray alloc ] initWithObjects:
          [ NSString stringWithFormat:@"%d",
           self.brain.red.colorIntegerValue   ],
          [ NSString stringWithFormat:@"%d",
           self.brain.green.colorIntegerValue ],
          [ NSString stringWithFormat:@"%d",
           self.brain.blue.colorIntegerValue  ],
          nil
          ]                            forKey:
         [ alertView textFieldAtIndex:0 ].text
         ];
        
        [ [ self.brain.firebase childByAppendingPath:ROUTE_TO_SAVED ]
         setValue:self.brain.dictionaryOfSavedColors ];
        
        self.savedColorView.numberOfRows =
        self.brain.dictionaryOfSavedColors.count;
        
        self.savedColorView.itemsToDisplay =
        [ self.brain.dictionaryOfSavedColors allKeys ];
    }
}

#pragma mark - ColorPickerSavedColorTableViewController delegate method
- (void)myColorPickTableControllerDidSelectColor:
(NSString *)selectedColor
                                          sender:
(ColorPickerSavedColorTableViewController *)sender            {
    NSString *pathToColor =
    [ [ ROUTE_TO_SAVED stringByAppendingString:@"/" ] stringByAppendingString:selectedColor ];
    NSLog(@"The path to the color is %@", pathToColor );
    [ [ self.brain.firebase  childByAppendingPath:pathToColor ]
     observeEventType:FEventTypeValue withBlock:
     ^(FDataSnapshot *snapshot) {
         if ( snapshot.value == [ NSNull null ] ) {
             NSLog(@"The snap shot is null" );
         }
         else {
             self.brain.red.colorIntegerValue =
             [ [ snapshot.value objectAtIndex:0 ] intValue ];
             self.brain.green.colorIntegerValue =
             [ [ snapshot.value objectAtIndex:1 ] intValue ];
             self.brain.blue.colorIntegerValue =
             [ [ snapshot.value objectAtIndex:2 ] intValue ];
             
             // Set background to selected color
             [ self setDisplayBackgroundColor ];
         }
     } ];
    [ sender.view removeFromSuperview ];
    sender = nil; // Just for good measure
}
@end
