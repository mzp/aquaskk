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



#import <AquaSKKBackend/SKKAutoUpdateDictionary.h>
#import <AquaSKKBackend/SKKBackend.h>
#import <AquaSKKBackend/SKKBaseDictionary.h>
#import <AquaSKKBackend/SKKCandidateFilter.h>
#import <AquaSKKBackend/SKKDictionaryCache.h>
#import <AquaSKKBackend/SKKDictionaryFactory.h>
#import <AquaSKKBackend/SKKDictionaryKey.h>
// #import <AquaSKKBackend/SKKNumericConverter.h>

#pragma mark - dictionary

#import <AquaSKKBackend/SKKAutoUpdateDictionary.h>
#import <AquaSKKBackend/SKKBaseDictionary.h>
#import <AquaSKKBackend/SKKCommonDictionary.h>
#import <AquaSKKBackend/SKKCompletionHelper.h>
#import <AquaSKKBackend/SKKDictionaryFile.h>
#import <AquaSKKBackend/SKKDictionaryKeeper.h>
#import <AquaSKKBackend/SKKDictionaryLoader.h>
#import <AquaSKKBackend/SKKDictionaryTemplate.h>
#import <AquaSKKBackend/SKKDistributedUserDictionary.h>
#import <AquaSKKBackend/SKKGadgetDictionary.h>
#import <AquaSKKBackend/SKKHttpDictionaryLoader.h>
#import <AquaSKKBackend/SKKLocalDictionaryLoader.h>
#import <AquaSKKBackend/SKKLocalUserDictionary.h>
#import <AquaSKKBackend/SKKProxyDictionary.h>
#import <AquaSKKBackend/SKKUserDictionary.h>

#pragma mark - entry

#import <AquaSKKbackend/SKKCandidate.h>
#import <AquaSKKbackend/SKKCandidateParser.h>
#import <AquaSKKbackend/SKKCandidateSuite.h>
#import <AquaSKKbackend/SKKEntry.h>
#import <AquaSKKbackend/SKKOkuriHint.h>

#pragma mark - session

#import <AquaSKKBackend/SKKInputMode.h>

#pragma mark - utility

#import <AquaSKKBackend/calculator.h>
#import <AquaSKKBackend/pthreadutil.h>
#import <AquaSKKBackend/socketutil.h>
#import <AquaSKKBackend/utf8util.h>
#import <AquaSKKBackend/stringutil.h>
#import <AquaSKKBackend/IntrusiveRefCounted.h>

#pragma mark - Encoding
#import <AquaSKKBackend/SKKEncoding.h>
#import <AquaSKKBackend/SKKTransliterate.h>
