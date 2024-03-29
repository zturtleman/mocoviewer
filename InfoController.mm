/////////////////////////////////////////////////////////////////////////////
// InfoController.mm
//
// Copyright (c) 2010, NGMOCO:)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice, 
//		this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, 
//		this list of conditions and the following disclaimer in the documentation 
//		and/or other materials provided with the distribution.
//    * Neither the name of the NGMOCO:) nor the names of its contributors may be 
//		used to endorse or promote products derived from this software without
//		specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Imports
#import "InfoController.h"


/////////////////////////////////////////////////////////////////////////////
@implementation InfoController

static InfoController* sSharedInfoController = nil;

@synthesize GeneralInfo =  mGeneralInfo;

/////////////////////////////////////////////////////////////////////////////
+(InfoController*) SharedInfoController
{
	@synchronized([InfoController class])
	{
		if (!sSharedInfoController)
		{
			[[self alloc] init];
		}

		return sSharedInfoController;
	}
 
	return nil;
}

/////////////////////////////////////////////////////////////////////////////
+(id)alloc
{
	@synchronized([InfoController class])
	{
		NSAssert(sSharedInfoController == nil, @"Attempted to allocate a second instance of a singleton.");
		sSharedInfoController = [super alloc];
		return sSharedInfoController;
	}
 
	return nil;
}
 
/////////////////////////////////////////////////////////////////////////////
-(id)init
{
	self = [super init];
	if (self != nil)
	{
		// initialize stuff here
		[mGeneralInfo setString:@"No File Loaded"];
		sSharedInfoController = self;
	}
	return self;
}


/////////////////////////////////////////////////////////////////////////////
-(void) AppendGeneralInfo: (const char*) data
{
	//NSString* currentData = [NSString stringWithFormat:@"%@%@",[mGeneralInfo stringValue],[NSString stringWithUTF8String:data]];
	//[mGeneralInfo setString:currentData];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetGeneralInfo: (const char*) data
{
	[mGeneralInfo setString:[NSString stringWithUTF8String:data]];
}

/////////////////////////////////////////////////////////////////////////////
-(void) ClearGeneralInfo
{
	[mGeneralInfo setString:@""];
}


@end

