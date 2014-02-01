//
//  ViewController.h
//  GataDrideDemo1
//
//  Created by PRAD!P on 23/07/13.
//  Copyright (c) 2013 Artoon020. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKCircle.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "MKMapView+ZoomLevel.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    // Location View
    IBOutlet MKMapView *mapView;
    CLLocationCoordinate2D theCoordinate;
    CLLocationCoordinate2D theCoordinate2;
    CLLocationCoordinate2D theCoordinate3;
    CLLocationCoordinate2D theCoordinateBaroda;
    CLLocationManager *currentLocation;
    
    // Draw Line in Map
    MKPolyline* _routeLine;
    MKPolylineView* _routeLineView;
    double radius;
    //MKCircleView *mycicleView;
    MKCircle *mycircle;
    
    NSMutableArray *routeLatitude;
    UIImageView *drawImage;
    CGPoint lastPoint;
    CGPoint storedLocation1;
    CGPoint storedLocation2;
    int pointLocker;
    
    UIButton *selectButton;
    UIButton *drwButton;
    
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    
    MKPinAnnotationView *PinView;
    MKPointAnnotation *PinPointAnn;
    MKPointAnnotation *PinPointAnnBaroda;
    
    
    // new Draw by Chines Style
    UIImageView *imageView;
    NSMutableArray *array;
    CGMutablePathRef pathRef;
    CLLocationCoordinate2D testLocation;
    CGPoint locationConvertToImage;
    
}
@property (nonatomic,retain)MKMapView *mapView;
-(void)showAnnotation;
@end
