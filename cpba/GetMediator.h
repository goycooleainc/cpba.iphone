//
//  PostMediator.h
//  currencyscanner
//
//  Created by Hector Goycoolea on 9/9/14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMediator : NSObject{
    /// response data to be processed
    NSMutableData *responseData;
}
#pragma mark - error Object
@property (nonatomic, retain) NSError *error;
#pragma mark - method posts
-(NSString *) getData: (NSString *) data url:(NSString *) url;
@end
