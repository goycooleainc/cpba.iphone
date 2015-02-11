//
//  XmlParser.h
//  currencyscanner
//
//  Created by Hector Goycoolea on 16-09-14.
//  Copyright (c) 2014 Octopus inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlParser : NSObject<NSXMLParserDelegate>
{
    NSMutableDictionary *MainDictionary;
    NSMutableArray *dictArray;
    BOOL foundString;
}
@property(strong)NSString *stringValue;
- (NSDictionary *)objectWithData:(NSData *)data;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;
@end
