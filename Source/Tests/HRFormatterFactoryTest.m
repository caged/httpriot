//
//  HRFormatterFactoryTest.m
//  HTTPRiot
//
//  Created by Ognen Ivanovski on 10-12-27.
//  Copyright 2010 Netcetera Skopje. All rights reserved.
//

#import "HTTPRiotTestHelper.h"
#import "HRFormatterFactory.h"

@interface HRFormatterFactoryTest : GHTestCase { } @end

@interface HRFormatterFactory(TestHelpers)
+ (void)resetRegistry;
@end


@interface MockCustomFormatter : NSObject <HRFormatterProtocol> {} @end


@implementation HRFormatterFactoryTest

- (void)setUp
{
    [HRFormatterFactory resetRegistry];
}

- (void)testShouldReturnDefaultFormatters
{
    id json = [HRFormatterFactory formatterForFormat:HRDataFormatJSON];
    id xml =  [HRFormatterFactory formatterForFormat:HRDataFormatXML];
    
    GHAssertNotNil(json, @"JSON formatter is present");
    GHAssertNotNil(xml, @"XML formatter is present");
}


- (void)testShouldRaiseWhenFormatIsNotRecognized
{
    GHAssertThrows([HRFormatterFactory formatterForFormat:66556],
                   @"Throws when format is not recognized");
}


- (void)testShouldReturnCustomFormatter
{
    MockCustomFormatter *formatter =  [[MockCustomFormatter alloc] init];
    
    [HRFormatterFactory registerFormatter:formatter forFormat:100];
    
    GHAssertEquals(formatter,
                   [HRFormatterFactory formatterForFormat:100],
                   @"Returns the same registered formatter");
}

@end



@implementation MockCustomFormatter


- (NSString *)extension {
    return @"custom";
}

- (NSString *)mimeType {
    return @"custommime";
}

- (id)decode:(NSData *)data error:(NSError **)error {
    return nil;
}

- (NSString *)encode:(id)object error:(NSError **)error {
    return nil;
}

@end
