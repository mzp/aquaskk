//
//  AquaSKKEngine.h
//  AquaSKKEngine
//
//  Created by mzp on 7/31/24.
//

#import <Foundation/Foundation.h>

//! Project version number for AquaSKKEngine.
FOUNDATION_EXPORT double AquaSKKEngineVersionNumber;

//! Project version string for AquaSKKEngine.
FOUNDATION_EXPORT const unsigned char AquaSKKEngineVersionString[];

#pragma mark - bridge

#import <AquaSKKEngine/SKKAnnotator.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKClipboard.h>
#import <AquaSKKEngine/SKKConfig.h>
#import <AquaSKKEngine/SKKDynamicCompletor.h>
#import <AquaSKKEngine/SKKFrontEnd.h>
#import <AquaSKKEngine/SKKInputModeListener.h>
#import <AquaSKKEngine/SKKInputSessionParameter.h>
#import <AquaSKKEngine/SKKMessenger.h>
#import <AquaSKKEngine/SKKWidget.h>

#pragma mark - backend

#import <AquaSKKEngine/SKKBackend.h>
#import <AquaSKKEngine/SKKCandidateFilter.h>
#import <AquaSKKEngine/SKKDictionaryCache.h>
#import <AquaSKKEngine/SKKDictionaryFactory.h>
#import <AquaSKKEngine/SKKDictionaryKey.h>
#import <AquaSKKEngine/SKKNumericConverter.h>
#import <AquaSKKEngine/SKKCompleter.h>
#import <AquaSKKEngine/SKKAutoUpdateDictionary.h>
#import <AquaSKKEngine/SKKBaseDictionary.h>

#pragma mark - dictionary

#import <AquaSKKEngine/SKKAutoUpdateDictionary.h>
#import <AquaSKKEngine/SKKBaseDictionary.h>
#import <AquaSKKEngine/SKKCommonDictionary.h>
#import <AquaSKKEngine/SKKCompletionHelper.h>
#import <AquaSKKEngine/SKKDictionaryFile.h>
#import <AquaSKKEngine/SKKDictionaryKeeper.h>
#import <AquaSKKEngine/SKKDictionaryLoader.h>
#import <AquaSKKEngine/SKKDictionaryTemplate.h>
#import <AquaSKKEngine/SKKDistributedUserDictionary.h>
#import <AquaSKKEngine/SKKGadgetDictionary.h>
#import <AquaSKKEngine/SKKHttpDictionaryLoader.h>
#import <AquaSKKEngine/SKKLocalDictionaryLoader.h>
#import <AquaSKKEngine/SKKLocalUserDictionary.h>
#import <AquaSKKEngine/SKKProxyDictionary.h>
#import <AquaSKKEngine/SKKUserDictionary.h>

#pragma mark - editor

#import <AquaSKKEngine/SKKBaseEditor.h>
#import <AquaSKKEngine/SKKCandidateEditor.h>
#import <AquaSKKEngine/SKKComposingEditor.h>
#import <AquaSKKEngine/SKKEntryRemoveEditor.h>
#import <AquaSKKEngine/SKKInputEngine.h>
#import <AquaSKKEngine/SKKInputQueue.h>
#import <AquaSKKEngine/SKKOkuriEditor.h>
#import <AquaSKKEngine/SKKPrimaryEditor.h>
#import <AquaSKKEngine/SKKRegisterEditor.h>
#import <AquaSKKEngine/SKKTextBuffer.h>

#pragma mark - entry

#import <AquaSKKEngine/SKKCandidate.h>
#import <AquaSKKEngine/SKKCandidateParser.h>
#import <AquaSKKEngine/SKKCandidateSuite.h>
#import <AquaSKKEngine/SKKEntry.h>
#import <AquaSKKEngine/SKKOkuriHint.h>

#pragma mark - keymap

#import <AquaSKKEngine/SKKKeyState.h>
#import <AquaSKKEngine/SKKKeymap.h>
#import <AquaSKKEngine/SKKKeymapEntry.h>

#pragma mark - selector

#import <AquaSKKEngine/SKKBaseSelector.h>
#import <AquaSKKEngine/SKKInlineSelector.h>
#import <AquaSKKEngine/SKKSelector.h>
#import <AquaSKKEngine/SKKWindowSelector.h>

#pragma mark - session

#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputEnvironment.h>
#import <AquaSKKEngine/SKKInputMode.h>
#import <AquaSKKEngine/SKKInputModeSelector.h>
#import <AquaSKKEngine/SKKInputSession.h>
#import <AquaSKKEngine/SKKOutputBuffer.h>
#import <AquaSKKEngine/SKKRecursiveEditor.h>
#import <AquaSKKEngine/SKKRegistration.h>
#import <AquaSKKEngine/SKKUndoContext.h>

#pragma mark - skkserv

#import <AquaSKKEngine/skkserv.h>

#pragma mark - state

#import <AquaSKKEngine/GenericStateMachine.h>
#import <AquaSKKEngine/SKKEvent.h>
#import <AquaSKKEngine/SKKState.h>
#import <AquaSKKEngine/SKKStateMachine.h>

#pragma mark - utility

#import <AquaSKKEngine/calculator.h>
#import <AquaSKKEngine/pthreadutil.h>
#import <AquaSKKEngine/socketutil.h>
#import <AquaSKKEngine/subrange.h>
