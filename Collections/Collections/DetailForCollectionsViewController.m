//
//  DetailForCollectionsViewController.m
//  Collections
//
//  Created by Jesse Nelson on 12/5/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "DetailForCollectionsViewController.h"

@interface DetailForCollectionsViewController ()

@end

@implementation DetailForCollectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setBrain:(Brain *)brain {
    _brain = brain;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.userInteractionEnabled = YES;
    self.lpGesture.minimumPressDuration = .1;
    self.lpGesture.delegate = self;
    //self.pinchGesture.delegate = self;
    self.imageView.image = self.collectionItem.image;
    self.textView.text = [ self.collectionItem description];
    [ self.imageView addGestureRecognizer:self.lpGesture ];
    
    //[ self.textView addGestureRecognizer:self.lpGesture];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    if ( self.collectionItem.checkedOut ) {
        self.checkOutInButton.title = @"Check In";
    } else {
        self.checkOutInButton.title = @"Check Out";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCollectionItem:(CollectionItem *)collectionItem {
    _collectionItem = collectionItem;
}

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}*/

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"Supported interface orientations called in detail");
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    NSLog(@"Should autorotate called in detail");
    return NO;
}
- (IBAction)handleLongPress:(UIGestureRecognizer*)gestureRecognizer{
    NSLog(@"Gesture recognized");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkOutItem:(UIBarButtonItem *)sender {
    NSLog(@"Item Checked out");
    if( [sender.title isEqualToString:@"Check Out"]) {
        ABPeoplePickerNavigationController *contactPicker =
        [ [ ABPeoplePickerNavigationController alloc ] init];
        contactPicker.peoplePickerDelegate = self;
        [ self presentViewController:contactPicker animated:YES
                          completion:^(void) { NSLog(@"Finished presenting view controller");}];
    } else {
        NSLog(@"Checking item in");
        //self.checkOutInButton.title = @"Check Out";
        self.collectionItem.checkedOut = FALSE;
        self.checkOutInButton.title = @"Check Out";
        self.collectionItem.checkOutInfo = @"";
    }
    [ self.brain writeData ];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString *data = @"";
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSLog(@"The first name is %@", name);
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    NSLog(@"The number is %@",phone);
    CFRelease(phoneNumbers);
    self.collectionItem.checkedOut = TRUE;
    self.collectionItem.checkOutInfo = phone;
    self.textView.text = [ self.textView.text stringByAppendingString:@"\n\n"];
    self.textView.text =
    [ self.textView.text stringByAppendingString:phone];
    [ self.brain writeData ];
    [self dismissModalViewControllerAnimated:YES];
}

@end
