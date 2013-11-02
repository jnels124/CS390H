//
//  BestRouteDetailViewController.h
//  BestRouteDetail
//
//  Created by Jesse Nelson on 10/31/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestRouteDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
