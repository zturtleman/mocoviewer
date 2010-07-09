/////////////////////////////////////////////////////////////////////////////
// AssetViewerAppDelegate.mm
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
//    * Neither the name of the <ORGANIZATION> nor the names of its contributors may be 
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


# import "AssetViewerAppDelegate.h"
#import "AVOpenGLModel.h"

@implementation AssetViewerAppDelegate

/////////////////////////////////////////////////////////////////////////////
// Synthesize block

@synthesize window;
@synthesize renderPanel;
@synthesize md3InfoPanel;
@synthesize animationPanel;
@synthesize tagInfoPanel;

static AssetViewerAppDelegate* s_instance = nil;

/////////////////////////////////////////////////////////////////////////////
+(AssetViewerAppDelegate*)sharedAssetViewerAppDelegate
{
	@synchronized(self)
	{
		return s_instance;
	}
}

/////////////////////////////////////////////////////////////////////////////
-(id) init
{
	self = [super init];
	if (self != nil)
	{
		s_instance = self;
		[mAnimationSlider setDoubleValue:0];
	}
	return self;
}


/////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application 
	//[animationWindow orderOut:nil];
	//[tagWindow orderOut:nil];
	//[generalWindow orderOut:nil];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetVertexCount: (int) vertCount
{
	[vertexCount setIntValue:vertCount];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetTriangleCount: (int) triCount
{
	[triangleCount setIntValue:triCount];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetDupeVertexCount: (int) dupeCount
{
	[dupeVertexCount setIntValue:dupeCount];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetDupeTriangleCount: (int) dupeCount
{
	[dupeTriangleCount setIntValue:dupeCount];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetName: (NSString*) name
{
	[renderName setStringValue:name];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetFlags: (int) flag
{
	[renderFlags setIntValue:flag];
}
/////////////////////////////////////////////////////////////////////////////
-(void) SetShaderCount: (int) count
{
	[renderShaders setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetFrameCount: (int) count
{
	[renderFrames setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
- (IBAction)RenderLightingSwitch:(id)sender
{
	AVOpenGLModel* model = [AVOpenGLModel sharedAVOpenGLModel];
	if(model)
	{
		if([renderLighting state] == NSOnState)
		{
			[model enableLighting];
		}
		else
		{
			[model disableLighting];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
- (IBAction)RenderWireFrameSwitch:(id)sender
{
	AVOpenGLModel* model = [AVOpenGLModel sharedAVOpenGLModel];
	if(model)
	{
		if([renderWireFrame state] == NSOnState)
		{
			[model enableWireFrame];
		}
		else
		{
			[model disableWireFrame];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
- (IBAction)RenderGeometrySwitch:(id)sender
{
	AVOpenGLModel* model = [AVOpenGLModel sharedAVOpenGLModel];
	if(model)
	{
		if([renderGeometry state] == NSOnState)
		{
			[model enableGeometry];
		}
		else
		{
			[model disableGeometry];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
- (IBAction)RenderNormalSwitch:(id)sender
{
	AVOpenGLModel* model = [AVOpenGLModel sharedAVOpenGLModel];
	if(model)
	{
		if([renderNormals state] == NSOnState)
		{
			[model enableNormals];
		}
		else
		{
			[model disableNormals];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoName: (NSString*) name
{
	[md3InfoName setStringValue:name]; 
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoVersion: (int) version
{
	[md3InfoVersion setIntValue:version];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoFlags: (int) flags
{
	[md3InfoFlags setIntValue:flags];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoNumFrames: (int) count
{
	[md3InfoNumFrames setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoNumTags: (int) count
{
	[md3InfoNumTags setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoNumSurfaces: (int) count
{
	[md3InfoNumSurfaces setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoNumSkins: (int) count
{
	[md3InfoNumSkins setIntValue:count];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetMd3InfoIden: (int) iden
{
	[md3InfoIden setIntValue:iden];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationCurrentFrame:(int) frame
{
	[mAnimationCurrentFrame setIntValue:(frame + 1)];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationFrameCount:(int) frame
{
	[mAnimationSlider setNumberOfTickMarks:frame];
	[mAnimationSlider setMaxValue:(frame - 1)];
	[mAnimationSlider setMinValue:0];
}


/////////////////////////////////////////////////////////////////////////////
-(IBAction)AnimationSliderChange:(id)sender
{
	int frameIdx = 	(int)[mAnimationSlider doubleValue];
	[self SetAnimationCurrentFrame:frameIdx];	
	[[AVOpenGLModel sharedAVOpenGLModel] loadFrame:frameIdx];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationName:(NSString*) frame
{
	[mAnimationName setStringValue:frame];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationMinBounds:(float) x minY:(float)y minZ:(float)z
{
	NSString* data = [NSString stringWithFormat:@"%f, %f, %f", x, y, z];	
	[mAnimationMinBounds setStringValue:data];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationMaxBounds:(float) x maxY:(float)y maxZ:(float)z
{
	NSString* data = [NSString stringWithFormat:@"%f, %f, %f", x, y, z];	
	[mAnimationMaxBounds setStringValue:data];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationOrigin:(float) x originY:(float)y originZ:(float)z
{
	NSString* data = [NSString stringWithFormat:@"%f, %f, %f", x, y, z];	
	[mAnimationOrigin setStringValue:data];
}

/////////////////////////////////////////////////////////////////////////////
-(void) SetAnimationRadius:(float)radius 
{
	[mAnimationRaidus setFloatValue:radius];
}

/////////////////////////////////////////////////////////////////////////////
-(void) ShowRenderPanel
{
	BOOL visible = ![renderPanel isVisible];
	[renderPanel setIsVisible:visible];
}

/////////////////////////////////////////////////////////////////////////////
-(void) ShowAnimationPanel
{
	BOOL visible = ![animationPanel isVisible];
	[animationPanel setIsVisible:visible];
}

/////////////////////////////////////////////////////////////////////////////
-(void) ShowTagPanel
{
	BOOL visible = ![tagInfoPanel isVisible];
	[tagInfoPanel setIsVisible:visible];
}

/////////////////////////////////////////////////////////////////////////////
-(void) ShowGeneralPanel
{
	BOOL visible = ![md3InfoPanel isVisible];
	[md3InfoPanel setIsVisible:visible];
}

@end
