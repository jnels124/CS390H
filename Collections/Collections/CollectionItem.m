//
//  Collection.m
//  Collections
//
//  Created by Jesse Nelson on 11/23/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CollectionItem.h"

@implementation CollectionItem
@synthesize
title,
releaseDate,
itemDescription,
type,
category,
userRating,
image;

-(id)init {
    if (self = ( [super init ] )) {
        self.image = [ [ UIImage alloc ] init ];
        self.userRating = 0;
        self.checkedOut = FALSE;
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [ aCoder encodeObject:self.title forKey:@"title"];
    [ aCoder encodeObject:self.releaseDate forKey:@"releaseDate" ];
    [ aCoder encodeObject:self.itemDescription forKey:@"description" ];
    [ aCoder encodeObject:self.type forKey:@"type" ];
    [ aCoder encodeObject:self.category forKey:@"category" ];
    [ aCoder encodeDouble:self.userRating forKey:@"userRating" ];
    [ aCoder encodeObject:self.image forKey:@"image"];
    [ aCoder encodeBool:self.checkedOut forKey:@"checkedOut"];
    [aCoder encodeObject:self.checkOutInfo forKey:@"checkOutInfo"];
    NSLog(@"Encode with coder called");
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super init ] ) {
        self.title =
        [ aDecoder decodeObjectForKey:@"title"];
        self.releaseDate =
        [ aDecoder decodeObjectForKey:@"releaseDate"];
        self.itemDescription =
        [ aDecoder decodeObjectForKey:@"description"];
        self.type =
        [ aDecoder decodeObjectForKey:@"type" ];
        self.category =
        [ aDecoder decodeObjectForKey:@"category"];
        self.userRating =
        [ aDecoder decodeDoubleForKey:@"userRating"];
        self.image =
        [ aDecoder decodeObjectForKey:@"image" ];
        self.checkedOut =
        [ aDecoder decodeBoolForKey:@"checkedOut"];
        self.checkOutInfo =
        [ aDecoder decodeObjectForKey:@"checkOutInfo"];
    }
    return self;
}

-(NSString*)description {
    NSString *str = [ NSString stringWithFormat:@"Title: %@\n", self.title];
    str = [ str stringByAppendingString:[ NSString stringWithFormat:@"Description: %@", self.itemDescription] ];
    return str;
}
@end
