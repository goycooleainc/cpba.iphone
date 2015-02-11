//
//  ComplainsViewController.m
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "ComplainsViewController.h"
#include "RestMediator.h"

@interface ComplainsViewController ()
//// MutableArray
@property (nonatomic, retain) IBOutlet UITextField *email;
/// Button outlet
@property (nonatomic, retain) IBOutlet UITextView *textView;
/// Button outlet
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@end

@implementation ComplainsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_scrollView setContentOffset:CGPointMake(0, -_scrollView.contentInset.top) animated:YES];
    
    _scrollView.scrollEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}
-(void)dismissKeyboard {
    [_textView resignFirstResponder];
    [_email resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendComplain:(id)sender{
    
    NSString *email_string = _email.text;
    NSString *complain = [_textView text];

    complain = [complain stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *json = @"{\"id\":\"0\",\"email\":\"";
    json = [json stringByAppendingString:email_string];
    json = [json stringByAppendingString:@"\",\"content\":\""];
    json = [json stringByAppendingString:complain];
    json = [json stringByAppendingString:@"\",\"date\":\"2014-11-10 03:01:26\"}"];
    
    RestMediator *rest = [[RestMediator alloc] init];
    [rest postJson:json url:@"http://pandora.2get.mobi/Cpba/createComplain"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camino del Buen Ayre - Informa"
                                                        message:@"Hemos recivido su Queja y estaremos en contacto en un plazo de 24Hrs. para poder ayudar a resolver su problema."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];

    [self performSegueWithIdentifier:@"complainMain" sender:self];
    
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
