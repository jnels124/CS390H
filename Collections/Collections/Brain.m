//
//  Brain.m
//  Collections
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "Brain.h"
@interface Brain () {
    NSMutableArray *array;
    NSMutableData *webData;
    NSURLConnection *connection;
    BOOL badData;
}

@end

@implementation Brain

-(Brain *) init {
    if (self = [ super init ] ) {
        /*self.currentCollection =
        [ [ CollectionItem alloc ] init];*/
        self.allCollections =
        [ [ NSDictionary alloc ] init ];
        badData = FALSE;
    }
    return self;
}

#pragma NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    [webData setLength:0 ];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [ webData appendData:data ];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *allDataDictionary =
    [ NSJSONSerialization JSONObjectWithData:webData options:0 error:nil ];
    self.allCollections =
    [ self processProduct:[ allDataDictionary objectForKey:@"product"] ];
    [ self writeData ];
}

- (NSDictionary *) dictionary:(NSDictionary *) dictionary
              WithAddedObject:(CollectionItem *) itemToAdd
                       ForKey:(NSString *) key{
    NSMutableDictionary *tmp =
    [ [ NSMutableDictionary alloc ] initWithDictionary:dictionary ];
    [ tmp setObject:itemToAdd forKey:key ];
    
    return tmp;
}

- (NSDictionary *) collectionExists:(NSString *) key {
    if ( 1==1) return nil;
    return nil;
}

- (NSDictionary *) processProduct:(NSDictionary *) product {
    NSDictionary *attributes =
    [ product objectForKey:@"attributes"];
    NSString *collectionTypeKey =
    [ attributes valueForKey:@"category_text"];
    NSString *collectionItemKey =
    [ attributes valueForKey:@"product"];
    CollectionItem *newCollectionItem =
    [ self determineCollectionItemType:
     [ attributes objectForKey:collectionTypeKey ]];
    newCollectionItem.title =
    collectionItemKey;
    newCollectionItem.type =
    collectionTypeKey;
    newCollectionItem.itemDescription =
    [ attributes objectForKey:@"long_desc"];
    [ self extractImageFor:newCollectionItem AtURL:[product objectForKey:@"image"] ];
    return [ self add:newCollectionItem ToCollection:self.allCollections ];
}

- (NSDictionary *) add:(CollectionItem *) newCollectionItem
          ToCollection:(NSDictionary *) collection {
    NSMutableDictionary *tempCollection =
    [[ NSMutableDictionary alloc ] initWithDictionary:collection ];
    NSDictionary *collectionItems;
    if ( !(collectionItems = [ collection objectForKey:newCollectionItem.type ] ) ) {
        collectionItems = [ [ NSMutableDictionary alloc ] init];
    }
    collectionItems =
    [ self dictionary:collectionItems WithAddedObject:newCollectionItem ForKey:newCollectionItem.title ];
    [ tempCollection setObject:collectionItems forKey:newCollectionItem.type];
    
    return tempCollection;
}

- (void) writeData {
    NSLog(@"Data written");
    NSData *data =
    [ NSKeyedArchiver archivedDataWithRootObject:self.allCollections ];
    [ data writeToFile:[ self getFilePathByAppending:@"allCollections" ] atomically:TRUE ];
}

- (void) extractImageFor:(CollectionItem *)item AtURL:(NSString *) urlString {
    if (!urlString) return;
    NSURL *imageURL = [NSURL URLWithString:urlString ];
    NSLog(@"The image url is %@", urlString);
    // Make URL request in background on separate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            item.image = [UIImage imageWithData:imageData];
            NSLog(@"Image saved");
            [self writeData];
        });
    });
}

- (NSString *) getFilePathByAppending:(NSString *) name {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES );
    NSString *documentsDirectory = [ paths objectAtIndex:0 ];
    NSString *filePath =
    [ documentsDirectory stringByAppendingPathComponent:name ];
    
    return filePath;
}

#pragma Delegates

#pragma ZBarDelegate
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info {
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;  // Pull only first item for now
    for(symbol in results)
        break;
    
    NSString *scannedNumber = symbol.data;
    NSString *productData =
    [ self returnSearchURLForProduct:scannedNumber ];
    
    NSURL *url = [ NSURL URLWithString:productData ];
    NSURLRequest *request =
    [ NSURLRequest requestWithURL:url ];
    connection =
    [ NSURLConnection connectionWithRequest:request delegate:self ];
    if ( connection ) {
        webData = [ [ NSMutableData alloc ] init];
    }
    [reader dismissModalViewControllerAnimated: YES];
}

#pragma Static Methods
// Returns array of routes sorted by average time
+ (NSArray *) quickSort:(NSArray *) unsortedArray {
    if ( unsortedArray.count <= 1 ) return unsortedArray;
# warning Choose the pivot in a better way
    NSString *pivotObject =
    [ unsortedArray objectAtIndex:unsortedArray.count / 2 ];
    
    NSMutableArray *left = [ [ NSMutableArray alloc ] init ];
    NSMutableArray *right = [ [ NSMutableArray alloc ] init ];
    for (NSString* value in unsortedArray) {
        if ([ value compare:pivotObject] == NSOrderedAscending) {
            [ left addObject:value ];
        } else if ( [value compare:pivotObject] == NSOrderedDescending ){
            [right addObject:value];
        }
    }
    NSMutableArray* sortedArray =
    [ [ NSMutableArray alloc ] initWithCapacity:unsortedArray.count ];
    [ sortedArray addObjectsFromArray:[ self quickSort:left ] ];
    [ sortedArray addObject:pivotObject ];
    [ sortedArray addObjectsFromArray:[ self quickSort:right ] ];
    
    return [ sortedArray copy ];
}

+ (NSDictionary *) removeItem:(NSString *) key
               FromCollection:(NSDictionary *)collection {
    NSMutableDictionary *tmpCollection =
    [ [ NSMutableDictionary alloc ] initWithDictionary:collection ];
    [ tmpCollection removeObjectForKey:key ];
    return [ [ NSDictionary alloc ] initWithDictionary:tmpCollection ];
}

#pragma Private methods
- (CollectionItem *) determineCollectionItemType:(NSString*) desc {
    //if ( [ desc isEqualToString:@"Movie" ] )
    //return [ [ Movie alloc] init];
    
    return [ [ CollectionItem alloc ] init ];
}

- (NSString *)returnSearchURLForProduct:(NSString *)productCode {
    NSString *theURL = DATABASE_HOST;
    theURL =
    [ theURL stringByAppendingString:API_KEY ];
    theURL =
    [ theURL stringByAppendingString:DATABASE_RETURN_TYPE ];
    theURL =
    [ theURL stringByAppendingString:productCode ];
    
    return theURL;
}

#pragma Dictionary Functions
@end
