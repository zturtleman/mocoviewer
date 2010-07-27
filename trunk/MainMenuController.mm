/////////////////////////////////////////////////////////////////////////////
// MainMenuController.mm
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

#import "MainMenuController.h"
#import "AssetViewerAppDelegate.h"
#import "AssetViewerOpenGLView.h"
#include "MDLReaderPolicy.h"
#include "InfoController.h"

@implementation MainMenuController
-(id) init
{
	if (!(self = [super init]))
        return nil;
	return self;
}

-(IBAction)menuOpenAction:(id)sender
{
	int i; // Loop counter.
	
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	// Enable the selection of files in the dialog.
	[openDlg setCanChooseFiles:YES];
	
	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:YES];
	
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* files = [openDlg filenames];
		
		// Loop through all the files and process them.
		for( i = 0; i < [files count]; i++ )
		{
			NSString* fileName = [files objectAtIndex:i];
			
			// Do something with the filename.
			const char* cFileName = [fileName cStringUsingEncoding:NSASCIIStringEncoding];
			ng::ReaderMDL reader;
			Md3Object* obj = reader.ReadFile(cFileName);
			if(nil != [AVOpenGLModel sharedAVOpenGLModel])
			{
				[[AVOpenGLModel sharedAVOpenGLModel] setObj:obj];
			}
			//char* data = nil;
			//size_t size = 0;
			//ng::ReaderMDL::BuildGeneralDataText(&data, &size, obj);	
			//[[InfoController SharedInfoController] SetGeneralInfo: data];
			//free(data);
		}
	}
}

-(IBAction)menuCloseAction:(id)sender
{
	
}

-(IBAction)menuViewAnimation:(id)sender
{
	[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] ShowAnimationPanel];
}

-(IBAction)menuViewTag:(id)sender
{
	[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] ShowTagPanel];
}

-(IBAction)menuViewGeneral:(id)sender
{
	[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] ShowGeneralPanel];
}

-(IBAction)menuViewRender:(id)sender
{
	[[AssetViewerAppDelegate sharedAssetViewerAppDelegate] ShowRenderPanel];
}

@end
