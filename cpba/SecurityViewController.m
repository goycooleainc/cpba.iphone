//
//  SecurityViewController.m
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "SecurityViewController.h"
#include "RestMediator.h"

@interface SecurityViewController ()

@end

@implementation SecurityViewController
/*
 *
 */
@synthesize picker, securityCollection, buttonSend;
/*
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    securityCollection =[[NSMutableArray alloc] init];
    /// pickerView
    picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    /// load data for the mobile device
    [self loadData];
}
/*
 *
 */
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
/*
 *
 */
-(void) loadData
{
    [securityCollection addObject:@"Accidente"];
    [securityCollection addObject:@"Animal Suelto"];
    [securityCollection addObject:@"Corte"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"Accidente" forKey:@"security_selection"];
    [prefs synchronize];
}
/*
 *
 */
- (IBAction) sendSecurityAlert:(id)sender
{
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    NSString *header = [preferences stringForKey:@"header"];
    NSString *geo = [preferences stringForKey:@"geo"];
    NSString *info = [preferences stringForKey:@"info"];
    NSString *message = [preferences stringForKey:@"security_selection"];

    NSString *json = @"{\"id\":\"0\",\"geoLocation\":\"";
    json = [json stringByAppendingString:geo];
    json = [json stringByAppendingString:@"\",\"alertType\":\""];
    json = [json stringByAppendingString:@"0"];
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
                                                        message:@"Gracias por reportar una violación de seguridad o otro problema relacionado con la inseguridad, en unos minutos verificaremos y estaremos tomando acción."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self performSegueWithIdentifier:@"securityMain" sender:self];

}
/*
 *
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
/*
 *
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"numberOfRowsInComponent: %d", [securityCollection count]);
    return [securityCollection count];
}
/*
 *
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [securityCollection objectAtIndex: row];
    NSLog(@"%@", [securityCollection objectAtIndex: row]);
    return [securityCollection objectAtIndex: row];
}
/*
 *
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:22];
    label.text = [securityCollection objectAtIndex: row];
    return label;
}
/*
 *
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this [%2d, %2d]: %@", row, component, [securityCollection objectAtIndex: row]);
    NSString *selection = (NSString *)[securityCollection objectAtIndex: row];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:selection forKey:@"security_selection"];
    [prefs synchronize];
    
    
    NSLog(@"count - %d", [securityCollection count]);
    pickerActiveIdx = row;
}

@end
