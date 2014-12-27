//
//  Brain.h
//  Collections
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZBarSDK.h>
#import "CollectionItem.h"
#import "Movie.h"

#define CELL_IDENTIFIER @"Cell"
#define DATABASE_HOST @"http://eandata.com/feed/"
#define API_KEY @"?v=3&keycode=027F74ED52886617"
#define DATABASE_RETURN_TYPE @"&mode=json&find="
@interface Brain : NSObject <NSURLConnectionDataDelegate, ZBarReaderDelegate>
//- (NSString *)returnSearchURLForProduct:(NSString *)productCode;
//- (NSString *) getFilePathByAppending:(NSString *) name;
// Returns array of routes sorted by average time
- (void) writeData;
- (NSString *) getFilePathByAppending:(NSString *)name;
+ (NSArray *) quickSort:(NSArray *) unsortedArray;
+ (NSDictionary *) removeItem:(NSString *) key
               FromCollection:(NSDictionary *)collection;
@property CollectionItem *currentCollectionItem;
@property NSDictionary *allCollections;
@end
