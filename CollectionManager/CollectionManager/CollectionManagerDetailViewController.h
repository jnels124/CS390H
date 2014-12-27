//
//  CollectionManagerDetailViewController.h
//  CollectionManager
//
//  Created by Jesse Nelson on 11/8/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionManagerDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
