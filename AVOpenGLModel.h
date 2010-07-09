/////////////////////////////////////////////////////////////////////////////
// AVOpenGLModel.h
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
// Includes
#import <Cocoa/Cocoa.h>
#include "MDL3_Conts.h"
#include "Shader.h"

@interface AVOpenGLModel : NSObject
{
	Md3Object_t* mObj;
	
	GLdouble mFovy;
	GLdouble mNearPlane;
	GLdouble mFarPlane;

	// camera information
	GLdouble mCameraLoc[3];
	GLdouble mCameraCenter[3];
	GLdouble mCameraUp[3];
	GLdouble mAngleZ;
	GLdouble mAngleY;

	// The Lighting values
	GLfloat mDiffuse[3];
	GLfloat mAmbient[3];
	GLfloat mLightPos[6][3]; 
	
	BOOL mLightingEnabled;
	BOOL mGeometryEnabled;
	BOOL mNormalsEnabled;

	Shader mLightingShader;
	Shader mFlatShader;
	Shader* mActiveShader;

	// Animation values
	int mFrameIdx;
	
	// The surface value
	int mSurfaceIdx;
}

@property (readwrite) GLdouble fovy;
@property (readwrite) GLdouble nearPlane;
@property (readwrite) GLdouble farPlane;

+(AVOpenGLModel*) sharedAVOpenGLModel;
-(void) draw;
-(void) setupPerspective:(GLdouble) aspect;
-(id) init;
-(void) zoomCameraDelta:(float)deltaZ DeltaY:(float)deltaY;
-(void) rotateObjectDelta: (float)deltaX AngleY:(float)deltaY;
-(void) enableWireFrame;
-(void) disableWireFrame;
-(void) enableLighting;
-(void) disableLighting;
-(void) enableGeometry;
-(void) disableGeometry;
-(void) enableNormals;
-(void) disableNormals;

-(void) loadFrame: (int) frameIdx;
-(void) setObj: (Md3Object_t*) obj;
// Action for the camera to do
@end
