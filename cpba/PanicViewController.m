//
//  PanicViewController.m
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "PanicViewController.h"
#include "RestMediator.h"

@interface PanicViewController ()

@end

@implementation PanicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)sendPanic:(id)sender{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *header = [preferences objectForKey:@"header"];
    NSString *geo = [preferences objectForKey:@"geo"];
    NSString *info = [preferences objectForKey:@"info"];
    
    NSString *message = @"EMERGENCIA DE PANICO Y SEGURIDAD";
    
    NSString *json = @"{\"id\":\"0\",\"geoLocation\":\"";
    json = [json stringByAppendingString:geo];
    json = [json stringByAppendingString:@"\",\"alertType\":\""];
    json = [json stringByAppendingString:@"2"];
    json = [json stringByAppendingString:@"\",\"message\":\""];
    json = [json stringByAppendingString:message];
    json = [json stringByAppendingString:@"\",\"alertState\":\""];
    json = [json stringByAppendingString:@"0"];
    json = [json stringByAppendingString:@"\",\"userInfo\":\""];
    json = [json stringByAppendingString:info];
    json = [json stringByAppendingString:@"\",\"parentLocale\":\""];
    json = [json stringByAppendingString:header];
    json = [json stringByAppendingString:@"\",\"date\":\"2014-11-10 03:01:26\"}"];
    
    RestMediator *rest = [[RestMediator alloc] init];
    [rest postJson:json url:@"http://pandora.2get.mobi/Cpba/createAlert"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camino del Buen Ayre - Informa"
                                                      message:@"Mantenga la Calma, recivimos el mensaje, favor de quedarse donde esta y si cambia de posición apriete el boton de nuevo."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [alertView show];
    
    
}
@end
