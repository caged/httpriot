/*
  HTTPRiot.h
  HTTPRiot

  Created by Justin Palmer on 1/28/09.
  Copyright 2009 Alternateidea. All rights reserved.
*/

/**
@mainpage HTTPRiot - A simple HTTP REST Library

HTTPRiot is a simple REST library designed to make interacting with REST services 
much easier.  It was inspired by John Nunemaker's <a href="http://github.com/jnunemaker/httparty/tree/master">httparty</a>
Ruby library.

<h3>A simple example</h3>
@code
// Returns a dictionary of key vlaues
id person = [HTTPRiotRestModel getPath:@"/some/person.json" 
                               options:[NSDictionary dictionaryWithObject:@"json" forKey:@"format"] 
                                error:nil];
                                
@endcode

<h3>Creating Your Own Models</h3>
The preferred way to use HTTPRiot is to subclass HTTPRiotRestModel and make your own models.
From these models you can set default options that will be used by every request.

@include Person.m
*/

#import <Foundation/Foundation.h>

#import "HTTPRiotRequest.h"
#import "HTTPRiotRestModel.h"