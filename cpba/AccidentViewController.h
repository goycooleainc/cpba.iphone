//
//  AccidentViewController.h
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "ViewController.h"

@interface AccidentViewController : ViewController
{
    /// picture choose controller
    UIViewController *choosePictureController;
}
//// MutableArray
@property (nonatomic, retain) IBOutlet NSMutableArray *securityCollection;
/// Button outlet
@property (nonatomic, retain) IBOutlet UIButton *buttonSend;
/// image of the camera
@property (nonatomic, retain) IBOutlet UIImageView *displayImage;
/// email from user
@property (nonatomic, retain) IBOutlet UITextField *email;
/// message from user
@property (nonatomic, retain) IBOutlet UITextView *message;

@property (nonatomic, retain) IBOutlet UIImage *userImage;

@end
