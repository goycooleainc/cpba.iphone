//
//  RestMediator.m
//  libTwoget
//
//  Created by Hector Goycoolea on 8/20/14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import "RestMediator.h"

@implementation RestMediator

-(void) postJson: (NSString *) json url:(NSString *) url{
        // Create the REST call string.
        NSString *restCallString = [NSString stringWithFormat:url];
        //// response data
        responseData = [[NSMutableData data] retain];
        // Create the URL to make the rest call.
        NSURL *restURL = [NSURL URLWithString:restCallString];
        /// if the request is success we get the json
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        NSLog(@"jsonRequest is %@", json);
        //// data for the json length
        NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
        /// now we send the data
        [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        /// this is the real request
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/*
 *
 */
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
/*
 *
 */
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
/*
 *
 */
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    /// we close the connection
    [connection release];
    /// we create the enconding and the response data
    NSString *data = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease];
    /// output from the REST server
    NSLog(@"%@", data);
    /// we get the data
    data = [data stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    /// we now parse the encoding
    NSData *dataJSON = [data dataUsingEncoding:NSUTF8StringEncoding];
    /// error for the json objects
    _error = nil;
    /// now we get an array of the all json file
    _jsonObjects = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingMutableContainers error:&_error];
    /// release the data
    [responseData release];
}
@end
