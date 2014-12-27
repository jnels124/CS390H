//
//  CollectionItemItem.h
//  CollectionItems
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionItem : NSObject <NSCoding>{
    @protected
    NSString *title;
    NSString *releaseDate;
    NSString *itemDescription;
    NSString *type;
    NSString *category;
    NSString *checkOutInfo;
    double   userRating;
    UIImage  *image;
}

@property NSString *title;
@property NSString *releaseDate;
@property NSString *itemDescription;
@property NSString *type;
@property NSString *category;
@property double   userRating;
@property UIImage  *image;
@property BOOL     checkedOut;
@property NSString *checkOutInfo;
@end

