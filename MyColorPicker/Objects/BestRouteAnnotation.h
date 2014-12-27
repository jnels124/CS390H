//
//  BestRouteAnnotation.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/18/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
@interface BestRouteAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
}

@property ( nonatomic, assign )CLLocationCoordinate2D coordinate;
@property ( nonatomic, copy ) NSString *title;
@property ( nonatomic, copy ) NSString *subTitle;

- (id) initWithLocation:(CLLocationCoordinate2D)coord;
@end
