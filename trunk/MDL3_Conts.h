/////////////////////////////////////////////////////////////////////////////
// MDL3_Conts.h
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

//////////////////////////////////////////////////////////////////////////
// Include Guard
#ifndef MDL3_CONTS_H
#define MDL3_CONTS_H
#pragma once

//////////////////////////////////////////////////////////////////////////
// Includes
#include <stdlib.h>
#include <stdint.h>
#include <OpenGL/OpenGL.h>

//////////////////////////////////////////////////////////////////////////
// Defines
#define MD3_QPATH 64
#define MD3_MAX_LODS 3
#define MD3_MAX_TRIANGLES 8192
#define MD3_MAX_VERTS 4096
#define MD3_MAX_SHADERS 256
#define MD3_MAX_FRAMES 1024
#define MD3_MAX_SURFACES 32
#define MD3_MAX_TAGS 16
#define MD3_XYZ_SCALE (1.0/64.0f)
#define MATH_PI 3.14159f

//////////////////////////////////////////////////////////////////////////
// types
typedef float Vec3[3];

typedef struct Md3Frame
{
	Vec3 minBounds;
	Vec3 maxBounds;
	Vec3 localOrigin;
	float radius;
	char name[16];
} Md3Frame_t;

typedef struct Md3Tag
{
	char name[MD3_QPATH];
	Vec3 origin;
	Vec3 axis[3];
} Md3Tag_t;

typedef struct Md3Surface
{
	int32_t ident;
	char name[MD3_QPATH];
	int32_t flags;
	int32_t numFrames;
	int32_t numShaders;
	int32_t numVerts;
	int32_t numTriangles;

	int32_t ofsTriangles;
	int32_t ofsShaders;
	int32_t ofsST;
	int32_t ofsXYZNormals;
	int32_t ofsEnd;

} Md3Surface_t;

typedef struct Md3Shader
{
	char name[MD3_QPATH];
	int32_t shaderIdx;
} Md3Shader_t;

typedef struct Md3Triangle
{
	int32_t index[3];
} Md3Triangle_t;

typedef struct Md3ST
{
	float st[2];
} Md3ST_t;

typedef struct Md3Header
{
	int32_t ident;
	int32_t version;
	char name[MD3_QPATH];
	int32_t flags;
	int32_t numFrames;
	int32_t numTags;
	int32_t numSurfaces;
	int32_t numSkins;
	int32_t ofsFrames;
	int32_t ofsTags;
	int32_t ofsSurfaces;
	int32_t ofsEnd;
} Md3Header_t;

typedef struct Md3XYZNormal
{
	int16_t vertex[3];
	uint8_t normal[2];
} Md3XYZNormal_t;

typedef struct Md3FrameGL
{
	GLuint vertexBufferId;
	GLuint normalBufferId;
	GLuint normVertBufferId;
	
	GLfloat* vertexBuffer;
	GLfloat* normalBuffer;
	GLfloat* normVertBuffer;
} Md3FrameGL_t;

typedef struct Md3SurfaceGL
{
	Md3Surface surface;
	//Md3Shader* shader;
	Md3ST* st;
	Md3FrameGL* mFramesGL;

	GLuint nvIndexBufferId;
	GLubyte* nvIndexBuffer;
	
	GLuint indexBufferId;
	GLubyte* indexBuffer;
} Md3SurfaceGL_t;

typedef struct Md3Object
{
	Md3Header header;
	Md3Frame* frames;
	Md3Tag* tags;
	Md3SurfaceGL_t* glSurface;
} Md3Object_t;

void ReleaseMd3Object(Md3Object* object);

#endif
