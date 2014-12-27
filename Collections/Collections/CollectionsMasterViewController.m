//
//  CollectionsMasterViewController.m
//  Collections
//
//  Created by Jesse Nelson on 11/15/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CollectionsMasterViewController.h"
#import "CollectionsDetailViewController.h"
#import "CollectionsViewController.h"

@interface CollectionsMasterViewController () {
    NSMutableArray *_objects;
}

@end

@implementation CollectionsMasterViewController

- (void)setTheCollection:(NSDictionary *)theCollection {
    _theCollection = theCollection;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentScanner:)];*/
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void) viewWillAppear:(BOOL)animated {
    _objects =
    [[NSMutableArray alloc ] initWithArray:[ Brain quickSort:[self.theCollection allKeys ] ] ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBrain:(Brain *)brain {
    _brain = brain;
}
#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [ tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                     forIndexPath:indexPath ];
    CollectionItem *selectedItem =
    [ self.theCollection objectForKey:_objects[indexPath.row] ];
    //UIImageView *image = [[UIImageView alloc] initWithImage:selectedItem.image];
    //cell.accessoryView = image;
    // *object = _objects[indexPath.row];
    cell.textLabel.text = _objects[indexPath.row];//object.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _objects[indexPath.row];
    CollectionItem *tmpItem =
    [self.theCollection objectForKey:key];
    NSMutableDictionary *tempCollection =
    [ [ NSMutableDictionary alloc ] initWithDictionary:self.theCollection];
    NSLog(@"Temp dictionary count before deletetion is %d", tempCollection.count);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[tempCollection removeObjectForKey:key];
        self.theCollection =
        [ Brain removeItem:key FromCollection:self.theCollection ];
        
        tempCollection = [ [ NSMutableDictionary alloc] initWithDictionary:self.brain.allCollections];
        if (!self.theCollection.count) {
            [tempCollection removeObjectForKey:tmpItem.type];
        }
        else {
         [tempCollection setObject:self.theCollection forKey:tmpItem.type];
        }
        self.brain.allCollections =
        [ [ NSDictionary alloc ] initWithDictionary:tempCollection];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }/* else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    } */

    [self.brain writeData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [self.navigationController setNavigationBarHidden:YES];
        [self performSegueWithIdentifier:@"toCollectionView" sender:self];
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CollectionItem *selectedItem =
        [ self.theCollection objectForKey:_objects[indexPath.row]];
        
        [[segue destinationViewController] setDetailItem:selectedItem.description];
    }
    
    else if ( ([ [segue identifier] isEqualToString:@"toCollectionView"])) {
        [ [segue destinationViewController] setTheCollectionViewItems:self.theCollection ];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    return (YES);
}
@end
