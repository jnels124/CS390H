//
//  CollectionsViewController.m
//  Collections
//
//  Created by Jesse Nelson on 11/25/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CollectionsViewController.h"

@interface CollectionsViewController () {
    NSMutableArray *_objects;
}

@end

@implementation CollectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) { NSLog(@"Inside if ");
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    _objects =
    [ [ NSMutableArray alloc ] initWithArray:
     [ Brain quickSort:[self.theCollectionViewItems allKeys]]];
    NSLog(@"There are %d items when collection view loaded", _objects.count);
    self.collectionView.allowsMultipleSelection = FALSE;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {

}

-(void)setBrain:(Brain *)brain {
    _brain = brain;
}

- (void) setTheCollectionViewItems:(NSDictionary *)theCollectionViewItems {
    _theCollectionViewItems = theCollectionViewItems;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Orientation changed");
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
        //[self performSegueWithIdentifier:@"toCollectionView" sender:self];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL_IDENTIFIER forIndexPath:indexPath ];
    CollectionItem *selectedItem =
    [ self.theCollectionViewItems objectForKey:_objects[indexPath.row]];
    if (!selectedItem.image) NSLog(@"The image is null");
    [cell.collectionImageView setImage:selectedItem.image];
    NSLog(@"The delegate has been called");
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected item called");
    CollectionItem *selectedItem =
    [ self.theCollectionViewItems objectForKey:_objects[indexPath.row]];
    [ collectionView addSubview:self.reusableView];//[self.storyboard instantiateViewControllerWithIdentifier:@"Practice"]];
    NSLog(@"End of selected item");
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objects.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toCollectionDetail"]) {
        NSIndexPath *indexPath =
        [ self.collectionView indexPathsForSelectedItems ][0];
        CollectionItem *selectedItem =
        [ self.theCollectionViewItems objectForKey:_objects[indexPath.row]];
        [[segue destinationViewController] setCollectionItem:selectedItem ];
        [[segue destinationViewController] setBrain:self.brain];
    }
}
@end
