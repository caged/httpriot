//---------------------------------------------------------------------------------------
//  $Id: OCMockRecorder.h 39 2009-04-09 05:31:28Z erik $
//  Copyright (c) 2004-2008 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface OCMockRecorder : NSProxy 
{
	id				signatureResolver;
	id				returnValue;
	BOOL			returnValueIsBoxed;
	BOOL			returnValueShouldBeThrown;
	NSInvocation	*recordedInvocation;
}

- (id)initWithSignatureResolver:(id)anObject;

- (id)andReturn:(id)anObject;
- (id)andReturnValue:(NSValue *)aValue;
- (id)andThrow:(NSException *)anException;

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation;
- (void)setUpReturnValue:(NSInvocation *)anInvocation;
- (void)releaseInvocation;

@end
