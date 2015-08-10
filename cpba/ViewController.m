   //
  //  ViewController.m
 //  cpba
//
 //  Created by Hector Goycoolea on 11/9/14.
  //  Copyright (c) 2014 Goycoolea inc. All rights reserved.
   //

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#include "RestMediator.h"
#include "AccidentViewController.h"
#include "GetMediator.h"

@interface ViewController (){
    NSMutableArray * array;
}
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;



@end

@implementation ViewController  

@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadTraffic)
                                                 name:@"reloadTraffic"
                                               object:nil];

    
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(updateMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMethod:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    
}

- (void)updateMethod:(NSTimer *)theTimer {
    // Your code goes here
    [self loadTraffic];
}

-(void) loadTraffic
{
    NSLog(@"Comienzo Checkeo del Trafico");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://cpba.goycooleainc.enterprises/Cpba/traffic/read"] ];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response //1
                          options:kNilOptions
                          error:&error];
    
    NSNumber *color = [json objectForKey:@"color"]; //2
    
    
    _laEstadoTransito.text =[json objectForKey:@"message"];
    
    if([[color stringValue] isEqualToString:@"1"]){
        [_imageCars setImage:[UIImage imageNamed:@"red.png"]];
        [_imageLight setImage:[UIImage imageNamed:@"ic_red_light.png"]];
        
    }
    
    if([[color stringValue]  isEqualToString:@"2"]){
         [_imageCars setImage:[UIImage imageNamed:@"yellow.png"]];
        [_imageLight setImage:[UIImage imageNamed:@"ic_yellow_light.png"]];
    }
    
    if([[color stringValue]  isEqualToString:@"3"]){
         [_imageCars setImage:[UIImage imageNamed:@"green.png"]];
        [_imageLight setImage:[UIImage imageNamed:@"ic_green_light.png"]];
    }
    
    [_activity stopAnimating];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *parent_color = [preferences objectForKey:@"color"];
    
    if (parent_color!=color) {
        
        NSLog(@"cambio de color: %@", color);
        
        [preferences setObject:color forKey:@"color"];
        [preferences synchronize];
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
        localNotification.alertBody = [json objectForKey:@"message"];
        localNotification.alertAction = @"Estado del Trafico Cambio";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // Request to reload table view data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTraffic" object:self];

    }
}

-(IBAction)makeCall:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"tel://08008887442"];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) detectLocation
{
    _pin.hidden = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    locationManager.delegate = self;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=8.0){
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    
    /// first we get the location Manager location
    CLLocation *ulocation = locationManager.location;
    /// we now get the coordinates
    CLLocationCoordinate2D userCoordinate = ulocation.coordinate;
    /// we now get users speed
    NSString *speed = [NSString stringWithFormat:@"%f", [ulocation speed]];
    /// x coordinate
    NSString *lat = [[NSString alloc]initWithFormat:@"%f", userCoordinate.latitude];
    /// y coordinate
    NSString *lon = [[NSString alloc ]initWithFormat:@"%f", userCoordinate.longitude ];
    /// altitude
    NSString *alt = [NSString stringWithFormat:@"%f", [ulocation altitude]];
    
    NSLog(@"Geocode : %@ %@ %@ %@", lat, lon, alt, speed);
    
    NSString *geo = [lat stringByAppendingString:@","];
    geo = [geo stringByAppendingString:lon];
    geo = [geo stringByAppendingString:@","];
    geo = [geo stringByAppendingString:alt];
    geo = [geo stringByAppendingString:@","];
    geo = [geo stringByAppendingString:@"speed"];

    NSString *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
    NSLog(@"numero %@", num);
    
    /// device reader
    UIDevice *device = [UIDevice currentDevice];
    /// this is the unique identifier for the reader
    NSUUID *uid = [device identifierForVendor];
    NSString *description  = [uid UUIDString];
    float batery_level = [device batteryLevel];
    NSString *device_name = [device name];
    NSString *model = [device model];
    /// send the uid to the provisioning profile
    
    NSString *info = [description stringByAppendingString:@","];
    info = [info stringByAppendingString:[[NSNumber numberWithFloat:batery_level] stringValue]];
    info = [info stringByAppendingString:@","];
    info = [info stringByAppendingString:device_name];
    info = [info stringByAppendingString:@","];
    info = [info stringByAppendingString:model];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:@"GPS BLOCKED" forKey:@"country_code"];
    [preferences setObject:@"GPS BLOCKED" forKey:@"header"];
    [preferences setObject:geo forKey:@"geo"];
    [preferences setObject:info forKey:@"info"];
    [preferences synchronize];

    [geocoder reverseGeocodeLocation:locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       NSString *aux_string = placemark.country;
                       aux_string = [aux_string stringByAppendingString:@"-"];
                       aux_string = [aux_string stringByAppendingString:placemark.administrativeArea];
                       
                       _location.text = [aux_string uppercaseString];
                       
                       NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
                       [preferences setObject:placemark.ISOcountryCode forKey:@"country_code"];
                       [preferences setObject:[aux_string uppercaseString] forKey:@"header"];
                       [preferences setObject:geo forKey:@"geo"];
                       [preferences setObject:info forKey:@"info"];
                       [preferences synchronize];
                   }];
    
}
-(void)detectConnection
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        NSLog(@"Device is connected to the internet");
    else{
        NSLog(@"Device is not connected to the internet");
        [self performSegueWithIdentifier:@"mainOopsJump" sender:self];
    }
}

/*
 *
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if([locationManager.delegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        [self locationUpdate:newLocation];
    }
}
/*
 *
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if([locationManager.delegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        //[self locationError:error];
    }
}

/*
 *
 */
- (void)locationUpdate:(CLLocation *)location {
    // we set the errro to manager
    self.locationManager.distanceFilter = 50.0f;
    /// we set the acuracy
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    /// we delegate them to self
    self.locationManager.delegate = self;
    /// first we get the location Manager location
    CLLocation *ulocation = [locationManager location];
    /// we now get the coordinates
    CLLocationCoordinate2D userCoordinate = ulocation.coordinate;
    /// we now get users speed
    NSString *speed = [NSString stringWithFormat:@"%f", [location speed]];
    /// x coordinate
    NSString *lat = [[NSString alloc]initWithFormat:@"%f", userCoordinate.latitude];
    /// y coordinate
    NSString *lon = [[NSString alloc ]initWithFormat:@"%f", userCoordinate.longitude ];
    /// altitude
    NSString *alt = [NSString stringWithFormat:@"%f", [location altitude]];
    
    NSLog(@"Geocode : %@ %@ %@ %@", lat, lon, alt, speed);
}

#pragma mark - View lifecycle

@end
