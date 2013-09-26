//
//  MarkKit.m
//  MarxKit
//
//  Created by Peter Meuel on 26/09/13.
//  Copyright (c) 2013 Alejo Berman. All rights reserved.
//

#import "MarkKit.h"

@implementation MarkKit

+ (instancetype)international
{
  static MarkKit *_international = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    _international = [[self alloc] init];
  });
  
  return _international;
}

@end
