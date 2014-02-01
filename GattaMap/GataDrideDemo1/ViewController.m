//
//  ViewController.m
//  GataDrideDemo1
//
//  Created by PRAD!P on 23/07/13.
//  Copyright (c) 2013 Artoon020. All rights reserved.
//

#import "ViewController.h"
#import "DDAnnotation.h"
#define kKYMapViewWithZoomLevelDemoDefaultZoomLevel_ 16
@interface ViewController ()
{
    NSInteger _zoomLevel;
    int counted;
    int countedBaroda;
    UILabel *l2;
    UILabel *l3;
    double dob_radius;
}
@end

@implementation ViewController
@synthesize mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    l2=[[UILabel alloc] init];
    l3=[[UILabel alloc] init];
    [mapView setDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
     PinPointAnn = [[MKPointAnnotation alloc]init];
    PinPointAnnBaroda = [[MKPointAnnotation alloc]init];
    
    currentLocation = [[CLLocationManager alloc]init];
    currentLocation.desiredAccuracy = kCLLocationAccuracyBest;
    currentLocation.delegate = self;
    [currentLocation startUpdatingLocation];
    
    
    
    // Clear and Draw Buttton
    selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
    [selectButton setTitle:@"CLEAR" forState:UIControlStateNormal];
    selectButton.frame = CGRectMake(85, 965, 100, 30);
    [self.view addSubview:selectButton];
    
    drwButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [drwButton addTarget:self action:@selector(drawingButtonPressed) forControlEvents:UIControlEventTouchDown];
    [drwButton setTitle:@"Draw" forState:UIControlStateNormal];
    drwButton.frame = CGRectMake(20, 965, 50, 30);
    [self.view addSubview:drwButton];
    
    // New Draw Code
    array = [NSMutableArray array];
    
}
#pragma mark - Button Event
-(void)drawingButtonPressed
{
    
    imageView = [[UIImageView alloc]initWithFrame:mapView.frame];
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 50, 79, 133, 1.0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor redColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4);
  
    locationConvertToImage = [mapView convertCoordinate:testLocation toPointToView:imageView];
    
    
}
-(void)buttonPressed
{
    
    [imageView removeFromSuperview];
    //[mapView removeAnnotations:mapView.annotations];
    UIGraphicsEndImageContext();
}


#pragma mark - Touch Events -
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch= [touches anyObject];
    CGPoint location = [touch locationInView:imageView];
    pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, location.x, location.y);
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:imageView];
    CGPoint pastLocation = [touch previousLocationInView:imageView];

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pastLocation.x, pastLocation.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), location.x, location.y);

    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathEOFillStroke);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    CGPathAddLineToPoint(pathRef, NULL, location.x, location.y);
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    CGPathCloseSubpath(pathRef);
    if (CGPathContainsPoint(pathRef, NULL, locationConvertToImage, NO)) {
        NSLog(@"Point in Path");
        MKPointAnnotation *pointAnnotation = nil;
        pointAnnotation = [[MKPointAnnotation alloc]init];
        pointAnnotation.coordinate = testLocation;
        pointAnnotation.title = @"pin";
        //[mapView addAnnotation:pointAnnotation];
    }
    imageView.userInteractionEnabled = NO;
}


#pragma mark - Draw Circle -
-(void)addCircle:(CLLocationCoordinate2D)coordinate
{

    radius = 100; //70
    NSLog(@"Zoom Radius : %f",radius);
    mycircle = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
    [mycircle setTitle:@"background"];
    [mapView addOverlay:mycircle];
    
    //MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
    //[circleLine setTitle:@"line"];
    //[mapView addOverlay:circleLine];
     
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
   
    MKCircleView *circleView = [[MKCircleView alloc]initWithCircle:overlay];
    
    if([circleView.circle isEqual:mycircle])
    {
        circleView.fillColor = [UIColor blueColor];
        circleView.alpha = 0.25;
        circleView.strokeColor = [UIColor brownColor];
        circleView.lineWidth = 2.0;
        
    }
    return circleView;
    
    
    //MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    //return circleView;
    
    //MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    //return polygonView;
}
-(void)showAnnotation
{
    MKCoordinateRegion region;
    region.center = theCoordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.009; //0.005
    span.longitudeDelta = 0.009; //0.005
    region.span = span;
    [mapView setRegion:region animated:TRUE];
    
    // MKCircle Draw on Map
    [self addCircle:theCoordinate];
    
    theCoordinate2.latitude = 21.212437;
    theCoordinate2.longitude = 72.850221;
    DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate2 addressDictionary:nil];
    annotation.title = @"My Current Location";
    annotation.subtitle = @"Im here";
    [self.mapView addAnnotation:annotation];
    
    NSArray *mylt;
    NSArray *mylog;
    CLLocationCoordinate2D myStLocation;
    myStLocation.latitude = 0;
    myStLocation.longitude = 0;
    mylt = [[NSArray alloc]initWithObjects:
            @"21.211437",
            @"21.21466",
            @"21.219561",
            @"21.204638",
            @"21.209279",
            @"21.21324",
            @"21.21518",
            @"21.218181",
            @"21.249882",
            @"21.245762",
            @"21.251742",
            @"21.243502",
            @"21.241742",
            @"21.236102",
            @"21.238662",
            @"21.254902",
            nil];
    mylog = [[NSArray alloc]initWithObjects:
             @"72.850221",
             @"72.853024",
             @"72.851672",
             @"72.852852",
             @"72.850299",
             @"72.844269",
             @"72.843175",
             @"72.84517",
             @"72.867637",
             @"72.868001",
             @"72.878602",
             @"72.862873",
             @"72.875855",
             @"72.879674",
             @"72.882710",
             @"72.877405",
             nil];
    NSLog(@"My Latitude total count : %i",mylt.count);
    for (int i =0; i < mylt.count; i++) {
        myStLocation.latitude = [[mylt objectAtIndex:i] floatValue];
        myStLocation.longitude = [[mylog objectAtIndex:i] floatValue];
        annotation = [[DDAnnotation alloc] initWithCoordinate:myStLocation addressDictionary:nil];
        annotation.title = [NSString stringWithFormat:@"location %i",i];
        [self.mapView addAnnotation:annotation];
    }
    
    

}
-(void)showAnnotationBaroda
{
    MKCoordinateRegion region;
    region.center = theCoordinateBaroda;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.009; //0.005
    span.longitudeDelta = 0.009; //0.005
    region.span = span;
    [mapView setRegion:region animated:TRUE];
    
    // MKCircle Draw on Map
    [self addCircle:theCoordinateBaroda];
    
    theCoordinate3.latitude = 21.243282;
    theCoordinate3.longitude = 72.877958;
    DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate3 addressDictionary:nil];
    annotation.title = @"My Current Location part 2";
    annotation.subtitle = @"Im here";
    [self.mapView addAnnotation:annotation];
    
    NSArray *mylt;
    NSArray *mylog;
    CLLocationCoordinate2D myStLocation;
    myStLocation.latitude = 0;
    myStLocation.longitude = 0;
    mylt = [[NSArray alloc]initWithObjects:
            @"21.249882",
            @"21.245762",
            @"21.251742",
            @"21.243502",
            @"21.241742",
            @"21.236102",
            @"21.238662",
            @"21.254902",
            nil];
    mylog = [[NSArray alloc]initWithObjects:
             @"72.867637",
             @"72.868001",
             @"72.878602",
             @"72.862873",
             @"72.875855",
             @"72.879674",
             @"72.882710",
             @"72.877405",
             nil];
    NSLog(@"My Latitude total count : %i",mylt.count);
    for (int i =0; i < mylt.count; i++) {
        myStLocation.latitude = [[mylt objectAtIndex:i] floatValue];
        myStLocation.longitude = [[mylog objectAtIndex:i] floatValue];
        annotation = [[DDAnnotation alloc] initWithCoordinate:myStLocation addressDictionary:nil];
        annotation.title = [NSString stringWithFormat:@"location %i",i];
        [self.mapView addAnnotation:annotation];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"----------------> Received Memory Warning <----------------");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Event -
-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [currentLocation stopUpdatingLocation];
    //NSLog(@"Location Array %@",locations);
    CLLocation *newLocation = [locations objectAtIndex:0];
    NSLog(@"lati==%f, longi==%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    theCoordinate.latitude = newLocation.coordinate.latitude;
    theCoordinate.longitude = newLocation.coordinate.longitude;
    
    
    //Baroda
    theCoordinateBaroda.latitude =  21.242862; //21.236782;
    theCoordinateBaroda.longitude = 72.883022; //72.867959;
    
    [self showAnnotation];
    [self showAnnotationBaroda];
    //[currentLocation pausesLocationUpdatesAutomatically];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [currentLocation stopUpdatingLocation];
}

#pragma mark - MKAnnotation -
-(MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *AnnotationIdentifier = @"AnnotationIdentifier";

    PinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!PinView) {
        PinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        PinView.canShowCallout = YES;
        //PinView.animatesDrop = YES;
    }
    else
        PinView.annotation = annotation;
    
    if(PinView.annotation == PinPointAnn)
    {
        l2.frame=CGRectMake(22, 20, 20, 20);
        l2.text=[NSString stringWithFormat:@"%i",counted];
        l2.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:(15)];
        l2.textColor = [UIColor whiteColor];
        l2.backgroundColor = [UIColor clearColor];
        //PinView.leftCalloutAccessoryView = leftCAV;
        
        PinView.image = [UIImage imageNamed:@"gg.png"];
        [PinView addSubview:l2];
        PinView.canShowCallout = YES;
    }
    if(PinView.annotation == PinPointAnnBaroda)
    {
        l3.frame=CGRectMake(22, 20, 20, 20);
        l3.text=[NSString stringWithFormat:@"%i",counted];
        l3.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:(15)];
        l3.textColor = [UIColor whiteColor];
        l3.backgroundColor = [UIColor clearColor];
        //PinView.leftCalloutAccessoryView = leftCAV;
        
        PinView.image = [UIImage imageNamed:@"gg2.png"];
        [PinView addSubview:l3];
        PinView.canShowCallout = YES;
    }
    return PinView;
    

}

#pragma mark - Zooming -

-(void)mapView:(MKMapView *)mapView2 regionDidChangeAnimated:(BOOL)animated
{
        
    NSLog(@"Zoom Level.......%i",_zoomLevel);

    [self checkPinRadius:theCoordinate];
    [self checkPinRadiusBaroda:theCoordinateBaroda];

}
-(void)checkPinRadius:(CLLocationCoordinate2D )coordi
{
    NSArray *annotations = [mapView annotations];
    DDAnnotation *annotation = nil;
    int flag;
    counted = 0;
    
    _zoomLevel = [self.mapView zoomLevel];
    dob_radius = _zoomLevel * 100;
    
    
    MKCircle *tempCircle = [MKCircle circleWithCenterCoordinate:theCoordinate radius:dob_radius];
    [mapView addOverlay:tempCircle];
    MKCircleView *circleView = (MKCircleView *)[mapView viewForOverlay:tempCircle];
    for (int i=0; i<[annotations count]; i++)
    {
        //NSLog(@"Total Annotaion : %i",[annotations count]);
        // Check Circle Validation
        id<MKAnnotation> currentAnnotation = [annotations objectAtIndex:i];
        CLLocationCoordinate2D mapCoordinate = [currentAnnotation coordinate];
        MKMapPoint mapPoint = MKMapPointForCoordinate(mapCoordinate);
        CGPoint circleViewPoint = [circleView pointForMapPoint:mapPoint];
        BOOL mapCoordinateIsInCircle = CGPathContainsPoint(circleView.path, NULL, circleViewPoint, NO);
        
        annotation = (DDAnnotation *)[annotations objectAtIndex:i];
        
        //[MKCircle circleWithCenterCoordinate:coordinate radius:radius]
        if (mapView.region.span.latitudeDelta > .020 && mapCoordinateIsInCircle)//  && [MKCircle circleWithCenterCoordinate:theCoordinate radius:100])
        {
            flag = 1;
            //NSLog(@"Counter Value in if..........: %i",counted);
            if (![[mapView viewForAnnotation:annotation] isEqual:[mapView viewForAnnotation:PinPointAnn]])
            {
                ++counted;
                //[mapView removeAnnotation:[annotations objectAtIndex:i]];
                [[mapView viewForAnnotation:annotation] setHidden:YES];
            }
            
            NSLog(@"Annotaion hide : %i",i);
            /*
            if () {
                
                [[mapView viewForAnnotation:annotation] setHidden:YES];
            }
             */
            
        }
        else {
            flag = 0;
            [[mapView viewForAnnotation:annotation] setHidden:NO];
        }
    }
    if (flag == 1) {
        PinPointAnn.coordinate = theCoordinate;
        [mapView addAnnotation:PinPointAnn];
        l2.text = @"";
        NSLog(@"Counted............%i",counted);
        l2.text = [NSString stringWithFormat:@"%i",counted];
    }
    else
    {
        if (PinPointAnn != nil) {
            if (PinView.annotation == PinPointAnn) {
                [mapView removeAnnotation:PinPointAnn];
                NSLog(@"Remove PinPoint Annotaion");
            }
        }
    }
    
}
-(void)checkPinRadiusBaroda:(CLLocationCoordinate2D )coordi
{
    NSArray *annotations = [mapView annotations];
    DDAnnotation *annotation = nil;
    int flag;
    counted = 0;
    countedBaroda = 0;
    
    _zoomLevel = [self.mapView zoomLevel];
    dob_radius = _zoomLevel * 100;
    
    
    MKCircle *tempCircle = [MKCircle circleWithCenterCoordinate:theCoordinateBaroda radius:dob_radius];
    [mapView addOverlay:tempCircle];
    MKCircleView *circleView = (MKCircleView *)[mapView viewForOverlay:tempCircle];
    for (int i=0; i<[annotations count]; i++)
    {
        //NSLog(@"Total Annotaion : %i",[annotations count]);
        // Check Circle Validation
        id<MKAnnotation> currentAnnotation = [annotations objectAtIndex:i];
        CLLocationCoordinate2D mapCoordinate = [currentAnnotation coordinate];
        MKMapPoint mapPoint = MKMapPointForCoordinate(mapCoordinate);
        CGPoint circleViewPoint = [circleView pointForMapPoint:mapPoint];
        BOOL mapCoordinateIsInCircle = CGPathContainsPoint(circleView.path, NULL, circleViewPoint, NO);
        
        
        annotation = (DDAnnotation *)[annotations objectAtIndex:i];
        
        //[MKCircle circleWithCenterCoordinate:coordinate radius:radius]
        if (mapView.region.span.latitudeDelta > .020 && mapCoordinateIsInCircle)//  && [MKCircle circleWithCenterCoordinate:theCoordinate radius:100])
        {
            flag = 1;
            //NSLog(@"Counter Value in if..........: %i",counted);
            if (![[mapView viewForAnnotation:annotation] isEqual:[mapView viewForAnnotation:PinPointAnnBaroda]])
            {
                ++countedBaroda;
                //[mapView removeAnnotation:[annotations objectAtIndex:i]];
                [[mapView viewForAnnotation:annotation] setHidden:YES];
            }
            /*
             if () {
             
             [[mapView viewForAnnotation:annotation] setHidden:YES];
             }
             */
            
        }
        else {
            flag = 0;
            [[mapView viewForAnnotation:annotation] setHidden:NO];
        }
    }
    if (flag == 1) {
        
        PinPointAnnBaroda.coordinate = theCoordinateBaroda;
        [mapView addAnnotation:PinPointAnnBaroda];
        l3.text = @"";
        NSLog(@"CountedBaroda............%i",countedBaroda);
        l3.text = [NSString stringWithFormat:@"%i",countedBaroda];
        
    }
    else
    {
        if (PinPointAnnBaroda != nil) {
            if (PinView.annotation == PinPointAnnBaroda) {
                NSLog(@"Remove PinPointBaroda Annotaion");
                [mapView removeAnnotation:PinPointAnnBaroda];
            }
        }
    }
    
}
@end
