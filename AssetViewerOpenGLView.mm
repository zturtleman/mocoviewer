/////////////////////////////////////////////////////////////////////////////
// AssetViewerOpenGLView.mm
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
#import "AssetViewerOpenGLView.h"
#include <OpenGL/gl.h>
#include <OpenGl/glu.h>

#define USE_DISPLAY_LIST 0

/////////////////////////////////////////////////////////////////////////////
// AssetViewerOpenGLView
@implementation AssetViewerOpenGLView



/////////////////////////////////////////////////////////////////////////////
static CVReturn DisplayLinkCallback(	CVDisplayLinkRef displayLink, 
										const CVTimeStamp* now,
										const CVTimeStamp* outputTime,
										CVOptionFlags flagsIn, CVOptionFlags* flagsOut,
										void* displayLinkContext)
{
    CVReturn result = [(AssetViewerOpenGLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

/////////////////////////////////////////////////////////////////////////////
-(void) idle:(NSTimer*)timer
{
	[self drawRect:[self bounds]];
}

/////////////////////////////////////////////////////////////////////////////
-(void) prepareOpenGL
{
	// Synchronize buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
#if USE_DISPLAY_LIST
	CGDirectDisplayID displayId = CGMainDisplayID();
	CVDisplayLinkCreateWithCGDisplay(displayId, &displayLink);
	CVDisplayLinkSetOutputCallback(displayLink, &DisplayLinkCallback, self);
	CGLContextObj cgContext = (CGLContextObj)[[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = (CGLPixelFormatObj)[[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cgContext, cglPixelFormat);

    // Activate the display link
    CVDisplayLinkStart(displayLink);
#else
	mTimer = [NSTimer timerWithTimeInterval:(0.0) target:self selector:@selector(idle:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:mTimer forMode:NSDefaultRunLoopMode];
#endif
	model = [[AVOpenGLModel alloc] init];
}

/////////////////////////////////////////////////////////////////////////////
- (void)reshape
{
	[[self openGLContext] makeCurrentContext];
	NSRect bounds = [self bounds];
	
	glViewport(0, 0, NSWidth(bounds), NSHeight(bounds));
	[model setupPerspective:NSWidth(bounds)/NSHeight(bounds)];
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	[NSOpenGLContext clearCurrentContext];
}

/////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(NSRect)rect
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	
	[model draw];
	
	[[self openGLContext] flushBuffer];
}

/////////////////////////////////////////////////////////////////////////////
- (CVReturn)getFrameForTime:(const CVTimeStamp*) outputTime
{
	[self drawRect:[self bounds]];
    return kCVReturnSuccess;
}

/////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
	[super dealloc];
	[model release];
}

/////////////////////////////////////////////////////////////////////////////
- (void)mouseDown:(NSEvent *)theEvent
{	
	mLocation = [theEvent locationInWindow];
}

/////////////////////////////////////////////////////////////////////////////
- (void)mouseUp:(NSEvent *)theEvent
{
	
}

/////////////////////////////////////////////////////////////////////////////
- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint location = [theEvent locationInWindow];
	
	if(theEvent.modifierFlags & NSControlKeyMask)
	{
		[model zoomCameraDelta: (mLocation.x - location.x) DeltaY:(mLocation.y - location.y)];
	}
	else
	{
		[model rotateObjectDelta:(location.x - mLocation.x) AngleY:(mLocation.y - location.y)];
	}	
	mLocation = location;
}

@end
