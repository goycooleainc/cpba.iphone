//
//  AccidentViewController.m
//  cpba
//
//  Created by Hector Goycoolea on 11/9/14.
//  Copyright (c) 2014 Goycoolea inc. All rights reserved.
//

#import "AccidentViewController.h"
#include "RestMediator.h"
#include "ASIFormDataRequest.h"

@interface AccidentViewController ()
@property (nonatomic, retain) IBOutlet UITextField *email_user;
@property (nonatomic, retain) IBOutlet UITextView *comment_user;
@end

@implementation AccidentViewController
/*
 *
 */
@synthesize buttonSend;
/*
 *
 */

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}
-(void)dismissKeyboard {
    [_email_user resignFirstResponder];
    [_comment_user resignFirstResponder];
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
/*
 *
 */
- (IBAction) sendButton:(id)sender
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 480), NO, 0.0);
    [self.userImage drawInRect:CGRectMake(0, 0, 640.0, 480.0)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    [self postImage:UUID image:newImage];
    
    //NSData *data1 = UIImagePNGRepresentation(newImage);
    //NSString *byteArray1  = [data1 base64Encoding];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *header = [preferences objectForKey:@"header"];
    NSString *geo = [preferences objectForKey:@"geo"];
    NSString *infor = [preferences objectForKey:@"info"];
    NSString *message = @"Reporte de Imagen desde ";
    message = [message  stringByAppendingString:header];
    message = [message stringByAppendingString:@" data : "];
    message = [message stringByAppendingString:infor];
    message = [message stringByAppendingString:@" mail : "];
    message = [message stringByAppendingString:[_email_user text]];
    message = [message stringByAppendingString:@" comentario : "];
    message = [message stringByAppendingString:[_comment_user text]];
    
    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *json = @"{\"id\":\"0\",\"parentImage\":\"";
    json = [json stringByAppendingString:UUID];
    json = [json stringByAppendingString:@"\",\"geoLocation\":\""];
    json = [json stringByAppendingString:geo];
    json = [json stringByAppendingString:@"\",\"message\":\""];
    json = [json stringByAppendingString:message];
    json = [json stringByAppendingString:@"\",\"date\":\"2014-11-10 03:01:26\"}"];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        RestMediator *rest = [[RestMediator alloc] init];
        [rest postJson:json url:@"http://pandora.2get.mobi/Cpba/createImageReport"];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            
        });
    });
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camino del Buen Ayre - Informa"
                                                        message:@"Imagen Recivida y Reportada, Muchisimas Gracias por su Colaboración."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self performSegueWithIdentifier:@"accidentMain" sender:self];

}

-(void) postImage: (NSString *) image_name image:(UIImage *) image
{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://pandora.2get.mobi/Cpba/upload"]];
     NSData *imageDataForSignature = UIImagePNGRepresentation(image);
     [request setData: imageDataForSignature withFileName: image_name andContentType:@"image/png" forKey:@"file"];
    [request setPostValue:image_name forKey:@"name"];
    [request startAsynchronous];
    /// this is response from the server
    NSString *response = [[request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"Response Payment: %@", response);
}

/// Action to Get the Photo
-(IBAction) getPhoto:(id) sender {
    /// we begin the animation context
    [UIView beginAnimations:nil context:NULL];
    /// we set the anumation duration
    [UIView setAnimationDuration:1];
    /// we now set the transition for the mainview controller
    [UIView setAnimationTransition:([choosePictureController.view superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:self.view cache:YES];
    /// seteamos el frame para que sea dentro del 0,0 sino lo toma sobre los 40
    choosePictureController.view.frame = CGRectMake(0, 0, 320, 460);
    //choosePicture.view.alpha = 0.87;
    /// ahora agregamos la vista al conotrolador
    [self.view addSubview:choosePictureController.view];
    /// we now commit the animation that we manually created
    [UIView commitAnimations];
}
/// Get Photo frlom the Camera
-(IBAction) getPhotoFromCamera:(id) sender {
    /// this is hte Picker for the picture pointing a location for the controller
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    /// we delegate it to it self
    picker.delegate = self;
    /// now we place the button for the choose picture on
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    /// we now present the modal view, the dispacher is on the modal
    //[self presentModalViewController:picker animated:YES];
    
    [self presentViewController:picker animated:YES completion:^{}];
}
/// this is the Method for the Photo Library
-(IBAction) getPhotoFromLibrary:(id) sender {
    /// this is hte Picker for the picture pointing a location for the controller
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    /// we delegate it to it self
    picker.delegate = self;
    /// now we place the button for the choose picture on
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    /// we now present the modal view, the dispacher is on the modal
    [self presentModalViewController:picker animated:YES];
}
/// Image Picker Controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /// from superview
    [choosePictureController.view removeFromSuperview];
    /// bool to picture
    //GotPicture = true;
    /// this sets the image on the parent controller and gets the object on the image controller image
    //UIImage *imageAuxiliar = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _userImage =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    /// to put the action user view
    //userActionView.purchaseImage = imageAuxiliar;
    [_displayImage setImage:_userImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    /*
     if(_userImage!=nil || _userImage!= NULL){
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     AccidentViewController *vc = (AccidentViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"AccidentViewController"];
     vc.cameraImage = _userImage;
     /// picker pointer to dismiss the modal of the camera roll
     [picker dismissViewControllerAnimated:YES completion:nil];
     
     [self presentViewController:vc animated:YES completion:^{}];
     }*/
    //[picker dismissModalViewControllerAnimated:YES];
}
- (IBAction) BackFromPicture :(id) sender
{
    /// we begin the animation context
    [UIView beginAnimations:nil context:NULL];
    /// we set the anumation duration
    [UIView setAnimationDuration:1];
    /// we now set the transition for the mainview controller
    [UIView setAnimationTransition:([choosePictureController.view superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
    /// remove from the super vew
    [choosePictureController.view removeFromSuperview];
    /// we now commit the animation that we manually created
    [UIView commitAnimations];
}

@end
