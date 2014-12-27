//
//  BestRouteBrain.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
@protocol MyLocationDelegate <NSObject>
- (void)locationUpdate:(CLLocation *) location;

@optional
- (void)locationError:(NSError *) error;
@end

#import <Foundation/Foundation.h>
#import "BestRouteSegment.h"
@interface BestRouteBrain : NSObject < CLLocationManagerDelegate, NSCoding > {
    NSDictionary *segments;
    BestRouteSegment *currentSegment;
    Route *currentRoute;
    BestRouteTrip *currentTrip;
    NSArray *segmentKeys;
    CLLocationManager *locationManager;
}
/*Manages attributes that communicate with GPS*/
@property ( strong ) CLLocationManager *locationManager;

/* this will be allocated as soon as brain is allocated */
@property BestRouteSegment *currentSegment;

/* this will be nil until route becomes active */
@property Route *currentRoute;

/* this will be nil until trip becomes active*/
@property BestRouteTrip *currentTrip;

/*Saved segments*/
@property NSDictionary *segments;

/*Maintains ordered array of segment keys */
@property NSArray *segmentKeys;

/*Class delegate*/
@property
(nonatomic, unsafe_unretained)id<MyLocationDelegate> delegate;

// Adds a new segment to the dictionary and returns the new dictionary
- (NSDictionary *) addSegment:(BestRouteSegment *)newSegment
                withSegmentName:(NSString *)segmentName;

// Searchs the dictionary to determine if the segment
//   all ready exists
//
// Return NO if segment is not in dictionary else YES
- (BOOL) segmentExists:(BestRouteSegment *)segment;

/* Determines if the first coordinate is within the specified distance of the second coordinate */
- (BOOL) isCoordinate:(CLLocationCoordinate2D)firstCoordinate
       WithinDistance:(int)distance
         OfCoordinate:(CLLocationCoordinate2D)secondCoordinate;

/* Cleans up and stores data */
- (void) segmentEnded:(BestRouteSegment *) segment;

/* Returns system path to resources*/
- (NSString *) getFilePathByAppending:(NSString *)name;

/* Write data for persistence */
- (void) writeData;

/* Adds the key associated with */
- (NSArray *) addKey:(NSString *) key;

@end
