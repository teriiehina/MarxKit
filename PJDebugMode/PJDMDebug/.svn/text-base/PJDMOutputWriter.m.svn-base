//
//  PJDMOutputWriter.m
//  DebugModeTest
//
//  Created by Alejo Berman on 03/04/13.
//  Copyright (c) 2013 Alejo Berman. All rights reserved.
//

#include <unistd.h>
#include <sys/stat.h>

#import "PJDMOutputWriter.h"
#import "PJDMMacros.h"

#define kTruncateMode @"w"
#define kAppendMode   @"a"

static volatile int stderrSave__;
static volatile mode_t permisions__;

static BOOL logs_activated;


@implementation PJDMOutputWriter


+ (void)activatePrintingLogs:(BOOL)pActivate
{
  logs_activated = pActivate;

  if (logs_activated) {
    [PJDMOutputWriter redirectSTDOutput];
    PJLog(@"Printing Logs activated");
  }
  else {
    [PJDMOutputWriter redirectSTDOutputToSTD];
    PJLog(@"Printing Logs desactivated");
  }
}


+ (BOOL)isPrintingLogsActivated
{
  return logs_activated;
}



#pragma mark - Redirecting logs

+ (void)redirectSTDOutput
{
  [PJDMOutputWriter redirectSTDOutputToFile:kLogSaveFileName withOption:kAppendMode];
}



+ (void)redirectSTDOutputToFile:(NSString *)fName withOption:(NSString *)options
{
  if (!fName || !options) {
    PJLog(@"Error missing parameters!");
    return;
  }
  // Sets the process's file mode.
  // The umask() function is always successful.
  permisions__ = umask(022);
  
  // Save stderr so it can be restored.
  stderrSave__ = dup(STDERR_FILENO);
  if (stderrSave__ == -1) {
    //Error
    umask(permisions__);
    return;
  }
  
  const char *restrict full_path = [[PJDMOutputWriter getFullPathForLogsFile:fName] cStringUsingEncoding:NSUTF8StringEncoding];
  const char *restrict opt = [options cStringUsingEncoding:NSUTF8StringEncoding];
  
  // Send stderr to our file
  FILE *newStderr = freopen(full_path, opt, stderr);
  if (newStderr == NULL) {
    PJLog(@"Error %d", errno);
  }
}

+ (void)clearDefaultLogFile
{
  [PJDMOutputWriter redirectSTDOutput];
  [PJDMOutputWriter redirectSTDOutputToFile:kLogSaveFileName withOption:kTruncateMode];
}


+ (NSString *)getFullPathForLogsFile:(NSString *)fName
{
  // if we've specified a filename we use it, else we use default one
  NSString *aFileName = fName ? fName : kLogSaveFileName;
  
  NSString *str = [PJDMOutputWriter pathForCacheFileSystemDirectory:[NSString stringWithCString:"logs" encoding:NSUTF8StringEncoding]];
  
  return [NSString stringWithFormat:@"%@/%@", str, aFileName];
}


+ (NSString *)getFullPathForLogsFile
{
  return [PJDMOutputWriter getFullPathForLogsFile:nil];
}


+ (void)redirectSTDOutputToSTD
{
  // Flush before restoring stderr
  fflush(stderr);
  // set defaults permission for process.
  umask(permisions__);
  // restore stderr, new output goes to console.
  int ret = dup2(stderrSave__, STDERR_FILENO);
  if (ret == -1) {
    PJLog(@"Error %d",errno);
    /*
     [EBADF]            stderrSave or STDERR_FILENO is not an active, valid file descriptor.
     [EINTR]            Execution is interrupted by a signal.
     [EMFILE]           Too many file descriptors are active.
     */
  }
  close(stderrSave__);
}


+ (NSString *)pathForCacheFileSystemDirectory:(NSString *)directory
{
  NSString *prefixPath = nil;
  /* create path to cache directory inside the application's Documents directory */
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if (directory) {
    prefixPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    
    // check for existence of directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:prefixPath]) {
      /* create a new cache directory */
      NSError *error = nil;
      [[NSFileManager defaultManager] createDirectoryAtPath:prefixPath withIntermediateDirectories:NO attributes:nil error:&error];
      if (error) {
        prefixPath = nil;
      }
    }
  }
  else {
    prefixPath = [paths objectAtIndex:0];
  }
  
  return prefixPath;
}

@end
