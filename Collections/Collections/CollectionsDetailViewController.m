//
//  CollectionsDetailViewController.m
//  Collections
//
//  Created by Jesse Nelson on 11/15/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CollectionsDetailViewController.h"

@interface CollectionsDetailViewController ()
- (void)configureView;
@end

@implementation CollectionsDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.textView.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
