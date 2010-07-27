/////////////////////////////////////////////////////////////////////////////
// MDLReaderPolicy.cpp
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
// Includes
#include "MDLReaderPolicy.h"
#include "MDL3_Conts.h"
#include <stdint.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

//////////////////////////////////////////////////////////////////////////
// Namespaces
namespace ng
{

//////////////////////////////////////////////////////////////////////
Md3Object* ReaderMDL::ReadFile(const char* name)
{
	// Argument Checking
	if(!name && !name[0])
		return 0;


	// Open the file for reading
	FILE* file = fopen(name, "r");	
	if(!file)
		return 0;
	Md3Object* obj = NULL;

	fseek(file, 0, SEEK_END); // seek to end of file
	size_t size = ftell(file); // get current file pointer
	fseek(file, 0, SEEK_SET); // seek back to beginning of file
	
	char* data = static_cast<char*>(malloc(size));
	
	size_t sizeFile = fread(data, 1, size, file);
	if(sizeFile == size)
	{
		obj = static_cast<Md3Object*>(malloc(sizeof(Md3Object)));

		memcpy(&obj->header, (Md3Header*)data, sizeof(Md3Header));
		int numSurfaces = obj->header.numSurfaces; 

		// $TODO handle this error case correctly
		if(0 >=  numSurfaces || numSurfaces > MD3_MAX_SURFACES)
			return NULL;
	
		// Init the GL Surface object
		obj->glSurface = static_cast<Md3SurfaceGL*>(malloc(sizeof(Md3SurfaceGL) * numSurfaces));
		memset(obj->glSurface, 0, sizeof(Md3SurfaceGL) * numSurfaces);

		// Load all the frames up		
		int numFrames = obj->header.numFrames;
		obj->frames = static_cast<Md3Frame*>(malloc(sizeof(Md3Frame) * numFrames));
		memcpy(obj->frames, data + obj->header.ofsFrames, sizeof(Md3Frame) * numFrames); 
		
		// Load all the tags up
		int numTags = obj->header.numTags;
		obj->tags = static_cast<Md3Tag*>(malloc(sizeof(Md3Tag) * numTags));
		memcpy(obj->tags, data + obj->header.ofsTags, sizeof(Md3Tag) * numTags); 

		// Walk though the surfaces
		Md3Surface* surface = (Md3Surface*)((uint8_t*)data + obj->header.ofsSurfaces);
		// Lets load all the surface data first
		for(int32_t idx = 0; idx < obj->header.numSurfaces; ++idx)
		{
			memcpy(&obj->glSurface[idx].surface, surface, sizeof(Md3Surface));
			
			obj->glSurface[idx].mFramesGL = static_cast<Md3FrameGL*>(malloc(sizeof(Md3FrameGL) * numFrames));
			memset(obj->glSurface[idx].mFramesGL, 0, sizeof(Md3FrameGL) * numFrames);
			
            // Read out the UV coords for the model
            //obj->glSurface[idx].st = static_cast<Md3ST*>(malloc(sizeof(Md3ST) * surface->numVerts));
            //memcpy(obj->glSurface[idx].st, surface + surface->ofsST, sizeof(Md3ST) * surface->numVerts);
		
			for(int32_t frameIdx = 0; frameIdx < numFrames; ++frameIdx)
			{
				glGenBuffers(1, &obj->glSurface[idx].mFramesGL[frameIdx].vertexBufferId);
				glGenBuffers(1, &obj->glSurface[idx].mFramesGL[frameIdx].normalBufferId);
				glGenBuffers(1, &obj->glSurface[idx].mFramesGL[frameIdx].normVertBufferId);
			
				surface->numVerts;
				obj->glSurface[idx].mFramesGL[frameIdx].vertexBuffer =
					(GLfloat*) malloc(sizeof(GLfloat) * 3 * surface->numVerts);
				obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer =
					(GLfloat*) malloc(sizeof(GLfloat) * 3 * surface->numVerts);
				obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer =
					(GLfloat*) malloc(sizeof(GLfloat) * 3 * surface->numVerts * 2);

				Md3XYZNormal* vert = (Md3XYZNormal*)((uint8_t*)surface +
													surface->ofsXYZNormals +
													sizeof(Md3XYZNormal) * surface->numVerts * frameIdx);
				int normVertIdx = 0;
				for(int32_t vertIdx = 0 ; vertIdx < surface->numVerts; ++vertIdx, vert++) 
				{
					// Pull out the normal data
					float lng = vert->normal[0] * (2 * MATH_PI) / 255.0f;
					float lat = vert->normal[1] * (2 * MATH_PI) / 255.0f;
					obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[3*vertIdx] 	= cos(lat) * sin(lng);
					obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[(3*vertIdx)+1] = sin(lat) * sin(lng);	
					obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[(3*vertIdx)+2] = cos(lng);
					
					// Pull out the vertex data	
					obj->glSurface[idx].mFramesGL[frameIdx].vertexBuffer[(3*vertIdx)] 	=
						MD3_XYZ_SCALE * vert->vertex[0];
					obj->glSurface[idx].mFramesGL[frameIdx].vertexBuffer[(3*vertIdx)+1] = 
						MD3_XYZ_SCALE * vert->vertex[1];
					obj->glSurface[idx].mFramesGL[frameIdx].vertexBuffer[(3*vertIdx)+2] =
						MD3_XYZ_SCALE * vert->vertex[2];

					// Create the normal-vertex data
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] 	=
						MD3_XYZ_SCALE * vert->vertex[0];
					normVertIdx += 1;
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] = 
						MD3_XYZ_SCALE * vert->vertex[1];
					normVertIdx += 1;
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] =
						MD3_XYZ_SCALE * vert->vertex[2];
					normVertIdx += 1;
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] 	=
						MD3_XYZ_SCALE * vert->vertex[0] + 
						obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[3*vertIdx];
					normVertIdx += 1;
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] = 
						MD3_XYZ_SCALE * vert->vertex[1] +
						obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[3*vertIdx+1];
					normVertIdx += 1;
					obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer[normVertIdx] =
						MD3_XYZ_SCALE * vert->vertex[2] + 
						obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer[3*vertIdx+2];
					normVertIdx += 1;
					
				}
				
				glBindBuffer(GL_ARRAY_BUFFER, obj->glSurface[idx].mFramesGL[frameIdx].vertexBufferId); 
				glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*surface->numVerts*3,
							 obj->glSurface[idx].mFramesGL[frameIdx].vertexBuffer, GL_STATIC_DRAW); 
				
				glBindBuffer(GL_ARRAY_BUFFER, obj->glSurface[idx].mFramesGL[frameIdx].normalBufferId); 
				glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*surface->numVerts*3,
							 obj->glSurface[idx].mFramesGL[frameIdx].normalBuffer, GL_STATIC_DRAW); 
				
				glBindBuffer(GL_ARRAY_BUFFER, obj->glSurface[idx].mFramesGL[frameIdx].normVertBufferId); 
				glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*surface->numVerts*3 * 2,
							 obj->glSurface[idx].mFramesGL[frameIdx].normVertBuffer, GL_STATIC_DRAW); 
				
			}
			
			// Gen the opengl buffer for the normal array
			glGenBuffers(1, &obj->glSurface[idx].nvIndexBufferId);
			obj->glSurface[idx].nvIndexBuffer =
				(GLubyte*) malloc(sizeof(GLubyte) * 2 * surface->numVerts);

			for(int32_t nvIdx = 0 ; nvIdx < surface->numVerts * 2; ++nvIdx) 
			{
				obj->glSurface[idx].nvIndexBuffer[nvIdx] = nvIdx;
			}
			
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, obj->glSurface[idx].nvIndexBufferId); 
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLfloat)*surface->numVerts * 2,
						 obj->glSurface[idx].nvIndexBuffer, GL_STATIC_DRAW); 
			
			// Gen the opengl buffers needed by this guy
			glGenBuffers(1, &obj->glSurface[idx].indexBufferId);

			// Now lets allocate the needed buffer space
			obj->glSurface[idx].indexBuffer  = (GLubyte*) malloc(sizeof(GLubyte) * 3 * surface->numTriangles);
			
			// Lets load up the triagles
			Md3Triangle* tri = (Md3Triangle*)((uint8_t*)surface + surface->ofsTriangles);
			for(int32_t triIdx = 0; triIdx < surface->numTriangles; ++triIdx, tri++)
			{
				obj->glSurface[idx].indexBuffer[3*triIdx]		= tri->index[0];
				obj->glSurface[idx].indexBuffer[(3*triIdx) + 1] = tri->index[2];
				obj->glSurface[idx].indexBuffer[(3*triIdx) + 2] = tri->index[1];
			}
			
			// Load the ST data.  My thinking is this must the UV texture coords but I am not sure at the moment

			// Load the data into the GL server side memory
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, obj->glSurface[idx].indexBufferId); 
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * 3 * surface->numTriangles,
						 obj->glSurface[idx].indexBuffer, GL_STATIC_DRAW); 
			
			surface = (Md3Surface*)((uint8_t*)surface + surface->ofsEnd);
		}
	}
	free(data);
	fclose(file);
	return obj;
}

//////////////////////////////////////////////////////////////////////////
// End of Namespaces

} // end of namespace ng

//////////////////////////////////////////////////////////////////////////
void ReleaseMd3Object(Md3Object* object)
{
	// Release the surface data
	for(int surfaceIdx = 0; surfaceIdx < object->header.numSurfaces; ++surfaceIdx)
	{
		for(int frameIdx = 0; frameIdx < object->header.numFrames; ++frameIdx)
		{
			glDeleteBuffers(1, &object->glSurface[surfaceIdx].mFramesGL[frameIdx].vertexBufferId);
			free(object->glSurface[surfaceIdx].mFramesGL[frameIdx].vertexBuffer);
			object->glSurface[surfaceIdx].mFramesGL[frameIdx].vertexBuffer = 0;
			
			glDeleteBuffers(1, &object->glSurface[surfaceIdx].mFramesGL[frameIdx].normalBufferId);
			free(object->glSurface[surfaceIdx].mFramesGL[frameIdx].normalBuffer);
			object->glSurface[surfaceIdx].mFramesGL[frameIdx].normalBuffer = 0;
			
			glDeleteBuffers(1, &object->glSurface[surfaceIdx].mFramesGL[frameIdx].normVertBufferId);
			free(object->glSurface[surfaceIdx].mFramesGL[frameIdx].normVertBuffer);
			object->glSurface[surfaceIdx].mFramesGL[frameIdx].normVertBuffer = 0;
		}

		glDeleteBuffers(1, &object->glSurface[surfaceIdx].nvIndexBufferId);
		free(object->glSurface[surfaceIdx].nvIndexBuffer);
		object->glSurface[surfaceIdx].nvIndexBuffer = 0;

		glDeleteBuffers(1, &object->glSurface[surfaceIdx].indexBufferId);
		free(object->glSurface[surfaceIdx].indexBuffer);
		object->glSurface[surfaceIdx].indexBuffer = 0;

		free(object->glSurface[surfaceIdx].mFramesGL);
		object->glSurface[surfaceIdx].mFramesGL = 0;
	}

	free(object->glSurface);
	object->glSurface = 0;
		
	free(object->frames);
	object->frames = 0;
	
	free(object->tags);
	object->tags = 0;
	
	free(object);
}
