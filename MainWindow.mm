/////////////////////////////////////////////////////////////////////////////
// MainWindow.mm
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
#import "MainWindow.h"
#import "AVOpenGLModel.h"
#include "MDLReaderPolicy.h"

@implementation MainWindow

/////////////////////////////////////////////////////////////////////////////
-(id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	if(!(self = [super initWithContentRect:contentRect 
						    styleMask:aStyle 
							backing:bufferingType defer:flag]))
	{
		return self;
	}
	[self registerForDraggedTypes: [NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
	return self;
}

/////////////////////////////////////////////////////////////////////////////
- (NSDragOperation)draggingEntered:(id )sender
{
	if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) 
	{ 
		return NSDragOperationGeneric; 
	} 
	
	return NSDragOperationNone; 
}

/////////////////////////////////////////////////////////////////////////////
- (BOOL)prepareForDragOperation:(id )sender 
{ 
	return YES; 
}

/////////////////////////////////////////////////////////////////////////////
- (BOOL)performDragOperation:(id )sender
{
    NSPasteboard* pasteBoard = [sender draggingPasteboard];
    NSArray* fileNames = [NSArray arrayWithObjects:NSFilenamesPboardType, nil]; 
    NSString* type = [pasteBoard availableTypeFromArray:fileNames]; 
	if ([type isEqualToString:NSFilenamesPboardType])
    {
		NSArray* fileNames = [pasteBoard propertyListForType:@"NSFilenamesPboardType"];
        NSString* fileName = [fileNames objectAtIndex:0];
        
        const char* cFileName = [fileName cStringUsingEncoding:NSASCIIStringEncoding];
        ng::ReaderMDL reader;
        Md3Object* obj = reader.ReadFile(cFileName);
        if(nil != [AVOpenGLModel sharedAVOpenGLModel])
        {
            [[AVOpenGLModel sharedAVOpenGLModel] setObj:obj];
            return TRUE;
        }
    }
    return NO; 	
}

@end
