//
//  PJDMOutputWriter.h
//  DebugModeTest
//
//  Created by Alejo Berman on 03/04/13.
//  Copyright (c) 2013 Alejo Berman. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface PJDMOutputWriter : NSObject

/**
 * @brief Activate/Desactivate logs printing.
 * @param Boolean for activate or not.
 */
+ (void)activatePrintingLogs:(BOOL)pActivate;


/**
 * @brief Return YES if prinitng logs is activated, else NO.
 */
+ (BOOL)isPrintingLogsActivated;


/**
 * @brief Call this class method to redirect all stderr to a default filename.
 */
+ (void)redirectSTDOutput;


///**
// * @brief Call this class method to redirect all stderr to a file.
// * @param : fName the name of logs file.
// */
//+ (void)redirectSTDOutputToFile:(NSString *)fName withOption:(NSString *)options;


/**
 * @brief Call this class method to redirect all logs to stderr.
 */
+ (void)redirectSTDOutputToSTD;

/**
 * @brief Remove all logs from logs file.
 */
+ (void)clearDefaultLogFile;

/**
 * @brief Return full path for log file
 * @param NSString file name
 * @note  If nil entered as fileName, default one is used
 */
+ (NSString *)getFullPathForLogsFile:(NSString *)fName;


/**
 * @brief Return default full path for log file
 */
+ (NSString *)getFullPathForLogsFile;

@end

