//
//  ViewController.h
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>{

    /// user Image
}
#pragma mark - CLLocationManager
@property (nonatomic, retain) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UILabel *grado;
@property (nonatomic, retain) IBOutlet UITextField *pin;

@property (nonatomic, retain) IBOutlet UILabel *laEstadoTransito;
@property (nonatomic, retain) IBOutlet UIImageView *imageLight;
@property (nonatomic, retain) IBOutlet UIImageView *imageCars;

@end

