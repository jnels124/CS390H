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
@interface BestRouteAnnotation : NSObject <MKAnnotation, NSCoding> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
}
/*Location of annotation*/
@property ( nonatomic, assign )CLLocationCoordinate2D coordinate;

/*Annotation title*/
@property ( nonatomic, copy ) NSString *title;

/*Annotation sub-title*/
@property ( nonatomic, copy ) NSString *subTitle;

- (id) initWithLocation:(CLLocationCoordinate2D)coord;

- (id) initWithLocation:(CLLocationCoordinate2D)coord
                  Title:(NSString *) title SubTitle:(NSString *) subTitle;
@end
