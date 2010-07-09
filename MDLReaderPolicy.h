/////////////////////////////////////////////////////////////////////////////
// MDLReaderPolicy.h
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

//////////////////////////////////////////////////////////////////////////
// Include Guard
#ifndef MDLREADERPOLICY_H
#define MDLREADERPOLICY_H
#pragma once

//////////////////////////////////////////////////////////////////////////
// Includes
#include "MDL3_Conts.h"

//////////////////////////////////////////////////////////////////////////
// Namespace
namespace ng
{

class ReaderMDL
{
public:
	
	//////////////////////////////////////////////////////////////////////
	Md3Object* ReadFile(const char* name);

protected:

#if 0
	//////////////////////////////////////////////////////////////////////
	int ParseHeader(char* data, int offset, Md3Object* obj);

	//////////////////////////////////////////////////////////////////////
	int ParseFrames(int numFrames, char* data, Md3Frame* frames);
	int ParseTags(int numTags, char* data, Md3Tag* tags);
	int ParseSurface(int numSurfaces, char* data, Md3SurfaceContainer* surfaces, GLuint* buffers);
	int ParseShaders(int numShaders, char* data, Md3Shader* shaders);
	int ParseTriangles(int numTriangles, char* data, Md3Triangle* triangles);
	int ParseTexCoords(int numSts, char* data, Md3ST* sts); 
	int ParseXYZNormals(int numVerts, char* data, Md3XYZNormal* points);

public:

	static int BuildGeneralDataText(char** data, size_t* size, const Md3Object* obj);
#endif	
private:

}; // end of class ReaderMDL

//////////////////////////////////////////////////////////////////////////
// End of Namespace
} // end of namespace ng

#endif // End if include guard MDLREADERPOLICY_H

