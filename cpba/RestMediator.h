//
//  RestMediator.h
//  libTwoget
//
//  Created by Hector Goycoolea on 8/20/14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestMediator : NSObject{
    /// response data to be processed
    NSMutableData *responseData;
}
#pragma mark - id jsonObjects
@property (nonatomic, retain) id jsonObjects;
#pragma mark - error Object
@property (nonatomic, retain) NSError *error;

-(void) postJson: (NSString *) json url:(NSString *) url;
@end
