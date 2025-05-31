//
//  AquaSKKEngine.h
//  AquaSKKEngine
//
//  Created by mzp on 7/31/24.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double AquaSKKEngineVersionNumber;

FOUNDATION_EXPORT const unsigned char AquaSKKEngineVersionString[];

#pragma mark - Adapter
#import <AquaSKKEngine/SKKAnnotatorAdapter.h>
#import <AquaSKKEngine/SKKCandidateWindowAdapter.h>
#import <AquaSKKEngine/SKKClipboardAdapter.h>
#import <AquaSKKEngine/SKKConfigAdapter.h>
#import <AquaSKKEngine/SKKDynamicCompletorAdapter.h>
#import <AquaSKKEngine/SKKFrontEndAdapter.h>
#import <AquaSKKEngine/SKKInputModeListenerAdapter.h>
#import <AquaSKKEngine/SKKInputSessionParameterAdapter.h>
#import <AquaSKKEngine/SKKMessengerAdapter.h>

#pragma mark - bridge

#import <AquaSKKEngine/SKKAnnotator.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKCandidateWindowBridge.h>
#import <AquaSKKEngine/SKKClipboard.h>
#import <AquaSKKEngine/SKKConfig.h>
#import <AquaSKKEngine/SKKDynamicCompletor.h>
#import <AquaSKKEngine/SKKFrontEnd.h>
#import <AquaSKKEngine/SKKInputModeListener.h>
#import <AquaSKKEngine/SKKInputSessionParameter.h>
#import <AquaSKKEngine/SKKMessenger.h>
#import <AquaSKKEngine/SKKWidget.h>

#pragma mark - buffer
#import <AquaSKKEngine/SKKInputQueueObserver.h>

#pragma mark - editor

#import <AquaSKKEngine/SKKBaseEditor.h>
#import <AquaSKKEngine/SKKCandidateEditor.h>
#import <AquaSKKEngine/SKKComposingEditor.h>
#import <AquaSKKEngine/SKKEntryRemoveEditor.h>
#import <AquaSKKEngine/SKKInputEngine.h>
#import <AquaSKKEngine/SKKOkuriEditor.h>
#import <AquaSKKEngine/SKKOkuriListener.h>
#import <AquaSKKEngine/SKKPrimaryEditor.h>
#import <AquaSKKEngine/SKKRegisterEditor.h>

#pragma mark - selector

#import <AquaSKKEngine/SKKSelector.h>

#pragma mark - session

#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputEnvironment.h>
#import <AquaSKKEngine/SKKInputModeSelector.h>
#import <AquaSKKEngine/SKKInputSession.h>
#import <AquaSKKEngine/SKKOutputBuffer.h>
#import <AquaSKKEngine/SKKRecursiveEditor.h>
#import <AquaSKKEngine/SKKRegistration.h>
#import <AquaSKKEngine/SKKUndoContext.h>

#pragma mark - state

#import <AquaSKKEngine/SKKEvent.h>
#import <AquaSKKEngine/SKKState.h>

#pragma mark - utility

#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
