//
//  HRFormatterFactory.h
//  HTTPRiot
//
//  Created by Ognen Ivanovski on 10-12-27.
//  Copyright 2010 Netcetera Skopje. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRFormatterProtocol.h"
/**
 * A class in charge of registering formatters and returning them when necessary 
 */
@interface HRFormatterFactory : NSObject {

}

/**
 * Registers a new formatter for the provided format identifier 
 * @param formatter the formatter
 * @param format format code
 */
+ (void)registerFormatter:(id <HRFormatterProtocol>)formatter forFormat:(NSUInteger)format;

/**
 * Returns the formatter for the specified format 
 */
+ (id <HRFormatterProtocol>) formatterForFormat:(NSUInteger)format;

@end
