//
//  AquaSKKBackend.h
//  AquaSKKBackend
//
//  Created by mzp on 9/13/24.
//

#import <Foundation/Foundation.h>

//! Project version number for AquaSKKBackend.
FOUNDATION_EXPORT double AquaSKKBackendVersionNumber;

//! Project version string for AquaSKKBackend.
FOUNDATION_EXPORT const unsigned char AquaSKKBackendVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import
// <AquaSKKBackend/PublicHeader.h>

#pragma mark - backend

#import <AquaSKKBackend/SKKCompletionHelper.h>
#import <AquaSKKBackend/SKKDictionaryKey.h>

#pragma mark - entry

#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKEntry.h>
#import <AquaSKKBackend/SKKInputMode.h>

#pragma mark - utility

#import <AquaSKKBackend/IntrusiveRefCounted.h>
#import <AquaSKKBackend/SKKCandidateBridge.h>
#import <AquaSKKBackend/SKKEncoding.h>
#import <AquaSKKBackend/SKKTransliterate.h>
#import <AquaSKKBackend/SwiftObject.h>
