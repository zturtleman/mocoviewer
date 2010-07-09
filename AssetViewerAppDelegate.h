/////////////////////////////////////////////////////////////////////////////
//  AssetViewerAppDelegate.h
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

/////////////////////////////////////////////////////////////////////////////
// Imports
#import <Cocoa/Cocoa.h>

/////////////////////////////////////////////////////////////////////////////
@interface AssetViewerAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow* window;
	
	// Render panel UI	
	NSPanel* renderPanel;
	IBOutlet NSTextField* vertexCount;
	IBOutlet NSTextField* dupeVertexCount;
	IBOutlet NSTextField* triangleCount;
	IBOutlet NSTextField* dupeTriangleCount;
	IBOutlet NSTextField* renderName;
	
	IBOutlet NSTextField* renderFlags;
	IBOutlet NSTextField* renderShaders;
	IBOutlet NSTextField* renderFrames;

	IBOutlet NSButton* renderLighting;
	IBOutlet NSButton* renderWireFrame;
	IBOutlet NSButton* renderGeometry;
	IBOutlet NSButton* renderNormals;

	// MD3 Info Panel
	NSPanel* md3InfoPanel;
	IBOutlet NSTextField* md3InfoName;
	IBOutlet NSTextField* md3InfoVersion;
	IBOutlet NSTextField* md3InfoFlags;
	IBOutlet NSTextField* md3InfoNumFrames;
	IBOutlet NSTextField* md3InfoNumTags;
	IBOutlet NSTextField* md3InfoNumSurfaces;
	IBOutlet NSTextField* md3InfoNumSkins;
	IBOutlet NSTextField* md3InfoIden;

	// Animation Info Panel
	NSPanel* animationPanel;
	IBOutlet NSSlider* mAnimationSlider;
	IBOutlet NSTextField* mAnimationCurrentFrame;
	IBOutlet NSTextField* mAnimationName;
	IBOutlet NSTextField* mAnimationMinBounds;
	IBOutlet NSTextField* mAnimationMaxBounds;
	IBOutlet NSTextField* mAnimationOrigin;
	IBOutlet NSTextField* mAnimationRaidus;

	// Tag Info Panel
	NSPanel* tagInfoPanel;
	IBOutlet NSOutlineView* mTagTree;
}

@property (assign) IBOutlet NSWindow* window;
@property (assign) IBOutlet NSPanel*  renderPanel;
@property (assign) IBOutlet NSPanel*  md3InfoPanel;
@property (assign) IBOutlet NSPanel*  animationPanel;
@property (assign) IBOutlet NSPanel*  tagInfoPanel;

+(AssetViewerAppDelegate*)sharedAssetViewerAppDelegate;
-(id) init;
-(void) SetVertexCount: (int) vertCount;
-(void) SetTriangleCount: (int) triCount;
-(void) SetDupeVertexCount: (int) dupeCount;
-(void) SetDupeTriangleCount: (int) dupeCount;
-(void) SetName: (NSString*) name;
-(void) SetFlags: (int) flag;
-(void) SetShaderCount: (int) count;
-(void) SetFrameCount: (int) count;
- (IBAction)RenderLightingSwitch:(id)sender;
- (IBAction)RenderWireFrameSwitch:(id)sender;
- (IBAction)RenderGeometrySwitch:(id)sender;
- (IBAction)RenderNormalSwitch:(id)sender;

-(void) SetMd3InfoName: (NSString*) name;
-(void) SetMd3InfoVersion: (int) version;
-(void) SetMd3InfoFlags: (int) flags;
-(void) SetMd3InfoNumFrames: (int) count;
-(void) SetMd3InfoNumTags: (int) count;
-(void) SetMd3InfoNumSurfaces: (int) count;
-(void) SetMd3InfoNumSkins: (int) count;
-(void) SetMd3InfoIden: (int) iden;

-(void) SetAnimationCurrentFrame:(int) frame;
-(void) SetAnimationFrameCount:(int) frame;
- (IBAction)AnimationSliderChange:(id)sender;

-(void) SetAnimationName:(NSString*) frame;
-(void) SetAnimationMinBounds:(float) x minY:(float)y minZ:(float)z;
-(void) SetAnimationMaxBounds:(float) x maxY:(float)y maxZ:(float)z;
-(void) SetAnimationOrigin:(float) x originY:(float)y originZ:(float)z;
-(void) SetAnimationRadius:(float) radius;

-(void) ShowRenderPanel;
-(void) ShowAnimationPanel;
-(void) ShowTagPanel;
-(void) ShowGeneralPanel;

@end
