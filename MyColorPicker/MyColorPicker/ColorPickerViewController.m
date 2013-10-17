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
    NSLog(@"View did load in main controller was called");
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

- (IBAction)savePressed:(id)sender {
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

- (IBAction)RecallPressed:(id)sender {
    [ self setUpItemsForTableView ];
    NSLog(@"There are %d items in recall pressed", self.savedColorView.itemsToDisplay.count );
    [ self.view addSubview:self.savedColorView.view ];
}

- (IBAction)finishedPickingColor:(UIButton*)sender {
    NSMutableArray *colors =
    [ [ NSMutableArray alloc ] init ];
    [ colors addObject:self.brain.red.stringBuilder ];
    [ colors addObject:self.brain.green.stringBuilder ];
    [ colors addObject:self.brain.blue.stringBuilder ];
    
    //NSLog(@"There are %d values in colors", colors.count );
    NSMutableString *query = [NSMutableString string];
    for (id val in colors) {
        NSLog(@"Inside for loop of finished picking color" );
        if (query.length) {
            [ query appendString:@"&" ];
            NSLog(@"Inside if of for loop of finished picking color" );
        }
        
        [ query appendFormat:@"v=%@", val ];
    }
    //NSLog(@"The query var is %@", query );
    
    NSString *urlStr =
    [@"myCalculator://colors?" stringByAppendingString:query];
    NSURL *url =
    [ NSURL URLWithString:urlStr ];
    
    UIApplication *test =
    [ UIApplication sharedApplication ];
    
    //BOOL found =
    [ test openURL:url ];
    
    /*NSLog(@"the query in colorpicker is %@", [ url query ] );
    if (found) NSLog( @"Resource was found" );
    
    else NSLog(@"unable to locate resource" );*/
}

- (void)setDisplayBackgroundColor {
    self.display.backgroundColor =  self.brain.getColor;
}

-(void) setUpItemsForTableView {
    self.savedColorView.numberOfRows =
    self.brain.dictionaryOfSavedColors.count;
    
    self.savedColorView.itemsToDisplay =
    [ self.brain.dictionaryOfSavedColors allKeys ];
    
    [ self.savedColorView.tableView reloadData ];
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
    
    [ self.brain handlePickerView:pickerView
                  withSelectedRow:row
                    FromComponent:component ];
    
    [ self setDisplayBackgroundColor ];
}

#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) {
        [ self.brain.dictionaryOfSavedColors setObject:
         [ [ NSArray alloc ] initWithObjects:
          self.brain.red.stringBuilder   ,
          self.brain.green.stringBuilder ,
          self.brain.blue.stringBuilder  ,
          nil
          ]                            forKey:
         [ alertView textFieldAtIndex:0 ].text
         ];
        
        [ [ self.brain.firebase childByAppendingPath:ROUTE_TO_SAVED ]
         setValue:self.brain.dictionaryOfSavedColors ];
        
        [ self setUpItemsForTableView ];
    }
    NSLog(@"There are %d items in alert view delegate pressed", self.savedColorView.itemsToDisplay.count );
}

#pragma mark - ColorPickerSavedColorTableViewController delegate method
- (void)myColorPickTableControllerDidSelectColor:
(NSString *)selectedColor
                                          sender:
(ColorPickerSavedColorTableViewController *)sender            {
    NSString *pathToColor =
    [ [ ROUTE_TO_SAVED stringByAppendingString:@"/" ] stringByAppendingString:selectedColor ];
    //NSLog(@"The path to the color is %@", pathToColor );
    [ [ self.brain.firebase  childByAppendingPath:pathToColor ]
     observeEventType:FEventTypeValue withBlock:
     ^(FDataSnapshot *snapshot) {
         if ( snapshot.value == [ NSNull null ] ) {
             NSLog(@"The snap shot is null" );
         }
         else {
             // Set background to selected color
             
             [ self.brain setColorComponentsToSelectedColor:snapshot.value ];
             [ self setDisplayBackgroundColor ];
         }
     } ];
    [ sender.view removeFromSuperview ];
    sender = nil; // Just for good measure
}

@end
