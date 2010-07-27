/////////////////////////////////////////////////////////////////////////////
// Shader.cpp
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

#include "Shader.h"
#include <stdlib.h>
#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#include <string>

static char* ShaderFileRead(const char* fileName)
{
	char* text = NULL;
	if(fileName)
	{
		FILE* file = fopen(fileName, "r");
		if(file)
		{
			fseek(file, 0, SEEK_END);
			int count = ftell(file);
			rewind(file);
			if(0 < count)
			{
				text = static_cast<char*>(malloc(sizeof(char)*(count+1)));
				count = fread(text, sizeof(char), count, file);
				text[count] = 0;
			}
		}
	}

	return text;
}

Shader::Shader()
: mId(0)
, mVsId(0)
, mFsId(0)
{

}

Shader::~Shader()
{
	glDetachShader(mId, mFsId);
	glDetachShader(mId, mVsId);

	glDeleteShader(mFsId);
	glDeleteShader(mVsId);
	glDeleteProgram(mId);
}

ShaderError Shader::Init(const char* vsFile, const char* fsFile)
{
	// Lets do some simple checking before we continue
	if(!vsFile || !(*vsFile) || !fsFile || !(fsFile))
		return SHADER_ERROR_INVALID_ARGS;

	const char* vsText = ShaderFileRead(vsFile);
	const char* fsText = ShaderFileRead(fsFile);

	if(!vsText || !fsText) 
		return SHADER_ERROR_INVALID_ARGS;
	
	// Create the shaders
	mVsId = glCreateShader(GL_VERTEX_SHADER);
	mFsId = glCreateShader(GL_FRAGMENT_SHADER);
	
	if(0 == mVsId || 0 == mFsId)
		return SHADER_ERROR_GL_ERROR;

	glShaderSource(mVsId, 1, &vsText, 0);
	glShaderSource(mFsId, 1, &fsText, 0);

	glCompileShader(mVsId);
	glCompileShader(mFsId);

	mId = glCreateProgram();
	glAttachShader(mId, mFsId);
	glAttachShader(mId, mVsId);
	glLinkProgram(mId);
		
	return SHADER_ERROR_NONE;
}

ShaderError Shader::Enable()
{
	glUseProgram(mId);
	return SHADER_ERROR_NONE;
}

ShaderError Shader::Disable()
{
	glUseProgram(0);
	return SHADER_ERROR_NONE;
}
