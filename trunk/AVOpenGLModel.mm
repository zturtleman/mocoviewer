/////////////////////////////////////////////////////////////////////////////
// AVOpenGLModel.mm
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
// Includes
#import "AVOpenGLModel.h"
#import "AssetViewerAppDelegate.h"
#include <OpenGL/gl.h>
#include <OpenGl/glu.h>
#include "MDL3_Conts.h"

/////////////////////////////////////////////////////////////////////////////
// Defines
#define R 0
#define G 1
#define B 2

#define X 0
#define Y 1
#define Z 2
#define W 3

/////////////////////////////////////////////////////////////////////////////
// Class AVOpenGLModel
@implementation AVOpenGLModel

/////////////////////////////////////////////////////////////////////////////
// Synthesize block

@synthesize fovy = mFovy;
@synthesize nearPlane = mNearPlane;
@synthesize farPlane = mFarPlane;

static AVOpenGLModel* s_instance = nil;

/////////////////////////////////////////////////////////////////////////////
+(AVOpenGLModel*)sharedAVOpenGLModel
{
	@synchronized(self)
	{
		return s_instance;
	}
	return nil;
}

/////////////////////////////////////////////////////////////////////////////
-(void) setupPerspective:(GLdouble) aspect
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(mFovy, aspect, mNearPlane, mFarPlane);
}

/////////////////////////////////////////////////////////////////////////////
-(void) drawView
{
	glLoadIdentity();	
	gluLookAt(	mCameraLoc[0], mCameraLoc[1], mCameraLoc[2],
				mCameraCenter[0], mCameraCenter[0], mCameraCenter[0],
				mCameraUp[0], mCameraUp[1], mCameraUp[2]);
}

/////////////////////////////////////////////////////////////////////////////
-(void) setupLighting 
{
	GLfloat diffuseLight[] = {mDiffuse[R], mDiffuse[G], mDiffuse[B]};
	GLfloat ambientLight[] = {mAmbient[R], mAmbient[G], mAmbient[B]};
	GLfloat position0[] = {mLightPos[0][X], mLightPos[0][Y], mLightPos[0][Z], mLightPos[0][W]};
	GLfloat position1[] = {mLightPos[1][X], mLightPos[1][Y], mLightPos[1][Z], mLightPos[1][W]};

	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
	glLightfv(GL_LIGHT0, GL_POSITION, position0);
	
	glLightfv(GL_LIGHT1, GL_DIFFUSE, diffuseLight);
	glLightfv(GL_LIGHT1, GL_AMBIENT, ambientLight);
	glLightfv(GL_LIGHT1, GL_POSITION, position1);

}

/////////////////////////////////////////////////////////////////////////////
-(void) drawModel
{
	if(mGeometryEnabled)
	{
		if(mLightingEnabled)
		{
			[self setupLighting];
		}

		mActiveShader->Enable();
		
		if(mObj)
		{
			glPushMatrix();
			glColor3f(1.0f, 0.0f, 0.0f);
			// We need to walk this guy down
			int32_t count = mObj->glSurface[mSurfaceIdx].surface.numTriangles;

			// Bind up the Vertex data
			glBindBuffer(GL_ARRAY_BUFFER, mObj->glSurface[mSurfaceIdx].mFramesGL[mFrameIdx].vertexBufferId);
			glVertexPointer(3, GL_FLOAT, 0, 0);

			glBindBuffer(GL_ARRAY_BUFFER, mObj->glSurface[mSurfaceIdx].mFramesGL[mFrameIdx].normalBufferId);
			glNormalPointer(GL_FLOAT, 0, 0);
			
			// Bind up the index array
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mObj->glSurface[mSurfaceIdx].indexBufferId);
			
			glRotatef(mAngleZ, 0.0f, 0.0f, 1.0f);
			glRotatef(mAngleY, 0.0f, 1.0f, 0.0f);
			
			glDrawElements(GL_TRIANGLES, count*3, GL_UNSIGNED_BYTE, 0);
			glPopMatrix();
		}
		
		mActiveShader->Disable();
	}

	if(mNormalsEnabled)
	{
		glPushMatrix();
		int32_t count = mObj->glSurface[mSurfaceIdx].surface.numVerts;
		glColor3f(0.0f, 0.0f, 1.0f);
		glBindBuffer(GL_ARRAY_BUFFER, mObj->glSurface[mSurfaceIdx].mFramesGL[mFrameIdx].normVertBufferId);
		glVertexPointer(3, GL_FLOAT, 0, 0);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mObj->glSurface[mSurfaceIdx].nvIndexBufferId);
		glRotatef(mAngleZ, 0.0f, 0.0f, 1.0f);
		glRotatef(mAngleY, 0.0f, 1.0f, 0.0f);
		glDrawElements(GL_LINES, count*2, GL_UNSIGNED_BYTE, 0);
		glPopMatrix();
	}
} 
/////////////////////////////////////////////////////////////////////////////
-(void)draw
{
	[self drawView];
	[self drawModel];
}

/////////////////////////////////////////////////////////////////////////////
-(id) init
{
	if(self = [super init])
	{
		// Init the camera values
		mFovy = 45.0;
		mNearPlane = 0.1;
		mFarPlane = 1000.0;

		mCameraLoc[0] = 50.0;
		mCameraLoc[1] = 0.0;
		mCameraLoc[2] = 0.0;
		mCameraCenter[0] = 0.0;
		mCameraCenter[1] = 0.0;
		mCameraCenter[2] = 0.0;
		mCameraUp[0] = 0.0;
		mCameraUp[1] = 0.0;
		mCameraUp[2] = 1.0;
		mAngleZ = 0;
		mAngleY = 0;

		// Init the light values
		mDiffuse[R] = 1.0f;
		mDiffuse[G] = 1.0f;
		mDiffuse[B] = 1.0f;
		mAmbient[R] = 0.5f;
		mAmbient[G] = 0.5f;
		mAmbient[B] = 0.5f;

		mLightPos[0][X] = 20.0f;
		mLightPos[0][Y] = 20.0f;
		mLightPos[0][Z] = 10.0f;
		mLightPos[0][W] = 0.0f;
		
		mLightPos[1][X] = -20.0f;
		mLightPos[1][Y] = -20.0f;
		mLightPos[1][Z] = 0.0f;
		mLightPos[1][W] = 0.0f;


		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LESS);
		
		NSString* vsfileStdLight =[[NSBundle mainBundle] pathForResource:@"stdLightVertex" ofType:@"glsl"];
		NSString* fsfileStdLight =[[NSBundle mainBundle] pathForResource:@"stdLightFragment" ofType:@"glsl"];
		
		NSString* vsfileFlat =[[NSBundle mainBundle] pathForResource:@"flatVertex" ofType:@"glsl"];
		NSString* fsfileFlat =[[NSBundle mainBundle] pathForResource:@"flatFragment" ofType:@"glsl"];
		
		mLightingShader.Init([vsfileStdLight UTF8String], [fsfileStdLight UTF8String]);
		mFlatShader.Init([vsfileFlat UTF8String], [fsfileFlat UTF8String]);

		glClearColor(0.0, 0.0, 0.0, 0.0);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_NORMAL_ARRAY);
		[self enableLighting];
		[self disableWireFrame];
		[self enableGeometry];
		[self disableNormals];

		mFrameIdx = 0;
		mSurfaceIdx = 0;
	
	}
	s_instance = self;
	return self;
}

/////////////////////////////////////////////////////////////////////////////
-(void) zoomCameraDelta:(float)deltaX DeltaY:(float)deltaY;
{
	mCameraLoc[0] += deltaX;
	mCameraLoc[2] += deltaY;
}

/////////////////////////////////////////////////////////////////////////////
-(void) rotateObjectDelta: (float)deltaZ AngleY:(float)deltaY
{
	mAngleZ += deltaZ;
	mAngleY += deltaY;
}

/////////////////////////////////////////////////////////////////////////////
-(void) enableWireFrame
{
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
}

/////////////////////////////////////////////////////////////////////////////
-(void) disableWireFrame
{
	glPolygonMode(GL_FRONT, GL_FILL);
}

/////////////////////////////////////////////////////////////////////////////
-(void) enableLighting
{
	mActiveShader = &mLightingShader;
	mLightingEnabled = TRUE;	
}

/////////////////////////////////////////////////////////////////////////////
-(void) disableLighting
{
	mActiveShader = &mFlatShader;
	mLightingEnabled = FALSE;	
}

/////////////////////////////////////////////////////////////////////////////
-(void) enableGeometry
{
	mGeometryEnabled = TRUE;
}

/////////////////////////////////////////////////////////////////////////////
-(void) disableGeometry
{
	mGeometryEnabled = FALSE;
}

/////////////////////////////////////////////////////////////////////////////
-(void) enableNormals
{
	mNormalsEnabled = TRUE;
}

/////////////////////////////////////////////////////////////////////////////
-(void) disableNormals
{
	mNormalsEnabled = FALSE;
}

/////////////////////////////////////////////////////////////////////////////
-(void) loadFrame: (int) frameIdx 
{
	mFrameIdx = frameIdx;
	if(mObj)
	{
		int32_t count = mObj->glSurface[mSurfaceIdx].surface.numTriangles;
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetTriangleCount:count];
		count = mObj->glSurface[mSurfaceIdx].surface.numVerts;	
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetVertexCount:count];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetDupeVertexCount:0];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetDupeTriangleCount:0];
		
		const char* name = mObj->glSurface[mSurfaceIdx].surface.name;
		NSString* strName = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetName:strName];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationCurrentFrame:frameIdx];

		name = mObj->frames[mFrameIdx].name;
		strName = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationName:strName];

		float x = mObj->frames[mFrameIdx].minBounds[0];
		float y = mObj->frames[mFrameIdx].minBounds[1];
		float z = mObj->frames[mFrameIdx].minBounds[2];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationMinBounds:x minY:y minZ:z];
		
		x = mObj->frames[mFrameIdx].maxBounds[0];
		y = mObj->frames[mFrameIdx].maxBounds[1];
		z = mObj->frames[mFrameIdx].maxBounds[2];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationMaxBounds:x maxY:y maxZ:z];
		
		x = mObj->frames[mFrameIdx].localOrigin[0];
		y = mObj->frames[mFrameIdx].localOrigin[1];
		z = mObj->frames[mFrameIdx].localOrigin[2];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationOrigin:x originY:y originZ:z];
		
		float radius = mObj->frames[mFrameIdx].radius; 
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationRadius:radius];
	}
}

/////////////////////////////////////////////////////////////////////////////
-(void) setObj: (Md3Object_t*) obj
{
	if(mObj)
		ReleaseMd3Object(mObj);
	
	mObj = obj;
	if(mObj)
	{
		// Aways set us up on the first frame
		[self loadFrame:0];

		// Populate the general info
		const char* name = mObj->header.name;
		NSString* strName = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoName:strName];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoVersion:mObj->header.version];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoFlags:mObj->header.flags];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoNumFrames:mObj->header.numFrames];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoNumTags:mObj->header.numTags];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoNumSurfaces:mObj->header.numSurfaces];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoNumSkins:mObj->header.numSkins];
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetMd3InfoIden:mObj->header.ident];

		// Pull out the total frame count
		int32_t count = mObj->glSurface[mSurfaceIdx].surface.numFrames;
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetFrameCount:count];
		
		count = mObj->glSurface[mSurfaceIdx].surface.numShaders;
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetShaderCount:count];
		
		count = mObj->glSurface[mSurfaceIdx].surface.flags;
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetFlags:count];
		
		// Load the animation data up
		[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] SetAnimationFrameCount:mObj->header.numFrames];
	
		// Load the tag data up
		
	}
}

@end
