//
//  InformationViewController.m
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)makeCall:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"tel://08008887442"];
    [[UIApplication sharedApplication] openURL:URL];
}
-(IBAction)makeCall103:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"tel://103"];
    [[UIApplication sharedApplication] openURL:URL];
}
-(IBAction)makeCall911:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"tel://911"];
    [[UIApplication sharedApplication] openURL:URL];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
