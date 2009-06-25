/*
 * Copyright (c) 2009 Justin Palmer <encytemedia@gmail.com>, All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 *   Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 *   Neither the name of the author nor the names of its contributors may be used
 *   to endorse or promote products derived from this software without specific
 *   prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

/**
@mainpage HTTPRiot - A simple HTTP REST Library

@image html httpriot.png

@li <a href="http://labratrevenge.com/httpriot">HTTPRiot homepage</a>
@li <a href="https://github.com/Caged/httpriot/tree/master">Source Code</a>

HTTPRiot is a simple REST library designed to make interacting with REST services 
much easier.  It supports GET, POST, PUSH and DELETE requests, HTTP Basic Authentication and 
the ability to post form-encoded data.

HTTPRiot was inspired by John Nunemaker's excellent 
<a href="http://github.com/jnunemaker/httparty/tree/master">httparty</a> Ruby library.

<div id="guides">
    <span class="ttl">Related Guides</span>
     <ul>
        <li>@subpage iphone-setup</li>
        <li>@subpage cocoa-setup</li> 
    </ul>
</div>

<h3>Some Examples</h3>

<h4>Send a GET request</h4>
@code
[HRRestModel getPath:@"/person.json" target:self selector:@selector(personLoaded:)];
@endcode

<h4>Send a POST request</h4>
@code
NSDictionary *opts = [NSDictionary dictionaroyWithObject:[person JSONRepresentation] forKey:@"body"];
[HRRestModel postPath:@"/person" withOptions:opts target:self selector:@selector(personCreated:)];
@endcode

<h4>Send a PUT request</h4>
@code
NSDictionary *opts = [NSDictionary dictionaroyWithObject:[updatedPerson JSONRepresentation] forKey:@"body"];
[HRRestModel postPath:@"/person" withOptions:opts target:self selector:@selector(personUpdated:)];
@endcode

<h4>Send a DELETE request</h4>
@code
[HRRestModel deletePath:@"/person/1" target:self selector:@selector(personDeleted:)];
@endcode
                            
<h3>Posting Form Data</h3>
It's very easy to post form-encoded data.  When you specify the <tt>params</tt> option for a POST 
request <tt>HTTPRiot</tt> will treat this as form encoded data.

@code
NSDictionary *formParams = [NSDictionary dictionaryWithObjectsAndKeys:@"bob", @"name", @"01/02/03", @"birthday", nil];
[HRRestModel postPath:@"http://localhost:1234/some/form/submission" 
                    options:[NSDictionary dictionaryWithObject:formParams forKey:@"params"] 
                      target:self
                    selector:@selector(formPosted:)];
@endcode

<h3>Creating Your Own Models</h3>
The preferred way to use HTTPRiot is to subclass HRRestModel and make your own models.
From these models you can set "class options" that will be used in every request sent from 
a particular model.

@include Tweet.m

<h3>Handling Errors</h3>
If any errors are present, the error will be included in the info dictionary passed to the callback.
@li <strong><tt>code</tt></strong> - The status code returned by the server.
@li <strong><tt>localizedFailureReason</tt></strong> - The reason the request failed.
@li <strong><tt>localizedDescription</tt></strong> - Description of the failure.
@li <strong><tt>domain</tt></strong> - The error domain.
@li <strong><tt>userInfo</tt></strong> - The userInfo dictionary with error infomration in addition to 
    to any <strong><tt>headers</tt></strong> returned by the server.  This dictionary also contains the full 
    <strong><tt>url</tt></strong> used in the request.

@page iphone-setup Using the HTTPRiot Framework in your iPhone Applications

HTTPRiot comes with a simple SDK package that makes it very easy to get up and running quickly 
on the iphone.  You'll need to put this SDK package somewhere where it won't get deleted and you 
can share it with all your iPhone projects.

-# Move the httpriot-* directory to <strong><tt>~/Library/SDKs</tt></strong>.  You might need to create this directory.
   It's not mandatory that it lives in this location, but it's a good idea that you put it somewhere 
   where it can be shared.
-# Create a new project or open an existing project in XCode.  Select your application's target and 
   press<strong class="key"> ⌘i</strong> to bring up the properties window.  Set the <strong><tt>Additional SDKs</tt></strong>
   property to <strong><tt>~/Library/SDKs/httpriot-0.1.0/\$(PLATFORM_NAME).sdk</tt></strong>.
   @image html additional-sdks.png
-# Set the <strong><tt>Additional Linker Flags</tt></strong> to <tt>-lhttpriot -ObjC</tt></strong> 
   @image html other-linker-flags.png
-# Use <strong><tt>\#include "HTTPRiot/HTTPRiot.h"</tt></strong> in one of your application's files. 
   That's it!  Now you're ready to use HTTPRiot!

@page cocoa-setup Using the HTTPRiot Framework in your Desktop Applications

-# Right click Other Frameworks in XCode and select <tt>Add &rarr; Existing Frameworks</tt>.  Select 
   the <strong><tt>HTTPRiot.framework</tt></strong> and press <tt>Add</tt>. @image html httpriot-framework.png
-# Include the framework <HTTPRiot/HTTPRiot.h> in your project.  That's it!

<h3>Embedding HTTPRiot.framework in your application</h3>
If you want to distribute HTTPRiot.framework with your application you'll need to do another step.

-# Right click your target name and select <tt>"Add > New Build Phase > New Copy Files Build Phase"</tt>.
   Set <tt>Frameworks</tt> as the destination path in the popup. @image html copy-files.png
-# Drag the HTTPRiot.framework file to this new phase.
*/

#import <Foundation/Foundation.h>
#import "HRRequestOperation.h"
#import "HRRestModel.h"
#import "HRResponseDelegate.h"
