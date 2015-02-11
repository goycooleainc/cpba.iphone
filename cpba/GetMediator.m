//
//  PostMediator.m
//  currencyscanner
//
//  Created by Hector Goycoolea on 9/9/14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import "GetMediator.h"

@implementation GetMediator

-(NSString *) getData: (NSString *) data url:(NSString *) url{
    
    //NSString *get = [url stringByAppendingString:@"?"];
    //get = [get stringByAppendingString:data];
    // Create the REST call string.
    //NSString *restCallString = [NSString stringWithFormat:get];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *rate = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
    return rate;
}
@end
