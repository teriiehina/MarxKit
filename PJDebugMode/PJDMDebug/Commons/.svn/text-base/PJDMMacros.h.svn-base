//
//  PJDMMacros.h
//  DebugModeTest
//
//  Created by Alejo Berman on 04/04/13.
//  Copyright (c) 2013 Alejo Berman. All rights reserved.
//

#import "PJDMOutputWriter.h"

/**
 * This is filename of the file that stores application logs
 */
#define kLogSaveFileName @"standardLogFileName"


/*
 * uses Standard C Library call perror() write alls logs to stderr : but NSLog is better;
 */

/*
 * uses Standard C Library call printf() to print in stdout: NOT GOOD FOR THIS WORK;
 */


/**
 * this macro write alls logs to stderr.
 * uses NSLog().
 */
//NSLog(@"%s - %s:%d\n%@",__PRETTY_FUNCTION__,__FILE__,__LINE__,[NSString stringWithFormat:format, ## __VA_ARGS__]);

#define PJLog(format,...) if (true) \
{ \
  NSLog(@"%s : %d\n%@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:format, ## __VA_ARGS__]); \
} 


