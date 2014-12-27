//
//  DetailForCollectionsViewController.h
//  Collections
//
//  Created by Jesse Nelson on 12/5/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CollectionItem.h"
#import "Brain.h"
@interface DetailForCollectionsViewController : UIViewController <UIGestureRecognizerDelegate, ABPeoplePickerNavigationControllerDelegate >
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpGesture;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(strong, nonatomic) CollectionItem *collectionItem;
- (IBAction)handleLongPress:(UIGestureRecognizer*)gestureRecognizer;
- (IBAction)checkOutItem:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkOutInButton;
@property (strong, nonatomic) Brain *brain;

@end
