//
//  XmlReader.h
//  currencyscanner
//
//  Created by Hector Goycoolea on 9/9/14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLReader : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError **errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
