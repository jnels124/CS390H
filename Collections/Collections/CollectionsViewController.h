//
//  CollectionsViewController.h
//  Collections
//
//  Created by Jesse Nelson on 11/25/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brain.h"
#import "CollectionCell.h"
#import "DetailForCollectionsViewController.h"
#define COLLECTION_CELL_IDENTIFIER @"collectionCell"
@interface CollectionsViewController : UICollectionViewController
<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet reusableView *reusableView;
@property (strong, nonatomic) NSDictionary *theCollectionViewItems;
@property DetailForCollectionsViewController *detailController;
@property (strong, nonatomic) Brain *brain;
//@property (weak, nonatomic) IBOutlet reusableView *reusableView;
@end
