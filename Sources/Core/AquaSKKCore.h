//
//  AquaSKKEngine.h
//  AquaSKKEngine
//
//  Created by mzp on 7/31/24.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double AquaSKKCoreVersionNumber;

FOUNDATION_EXPORT const unsigned char AquaSKKCoreVersionString[];

#import <AquaSKKCore/IntrusiveRefCounted.h>

#pragma mark - bridge

#import <AquaSKKCore/SKKAnnotator.h>
#import <AquaSKKCore/SKKCandidateWindow.h>
#import <AquaSKKCore/SKKClipboard.h>
#import <AquaSKKCore/SKKConfig.h>
#import <AquaSKKCore/SKKDynamicCompletor.h>
#import <AquaSKKCore/SKKFrontEnd.h>
#import <AquaSKKCore/SKKInputModeListener.h>
#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKCore/SKKMessenger.h>
#import <AquaSKKCore/SKKWidget.h>

#pragma mark - editor

#import <AquaSKKCore/SKKBaseEditor.h>
#import <AquaSKKCore/SKKCandidateEditor.h>
#import <AquaSKKCore/SKKComposingEditor.h>
#import <AquaSKKCore/SKKEntryRemoveEditor.h>
#import <AquaSKKCore/SKKInputEngine.h>
#import <AquaSKKCore/SKKInputQueue.h>
#import <AquaSKKCore/SKKOkuriEditor.h>
#import <AquaSKKCore/SKKPrimaryEditor.h>
#import <AquaSKKCore/SKKRegisterEditor.h>
#import <AquaSKKCore/SKKTextBuffer.h>

#pragma mark - keymap

#import <AquaSKKCore/SKKKeyState.h>
#import <AquaSKKCore/SKKKeymap.h>
#import <AquaSKKCore/SKKKeymapEntry.h>

#pragma mark - selector

#import <AquaSKKCore/SKKBaseSelector.h>
#import <AquaSKKCore/SKKInlineSelector.h>
#import <AquaSKKCore/SKKSelector.h>
#import <AquaSKKCore/SKKWindowSelector.h>

#pragma mark - session

#import <AquaSKKCore/SKKInputContext.h>
#import <AquaSKKCore/SKKInputEnvironment.h>
#import <AquaSKKCore/SKKInputModeSelector.h>
#import <AquaSKKCore/SKKInputSession.h>
#import <AquaSKKCore/SKKOutputBuffer.h>
#import <AquaSKKCore/SKKRecursiveEditor.h>
#import <AquaSKKCore/SKKRegistration.h>
#import <AquaSKKCore/SKKUndoContext.h>

#pragma mark - skkserv

#import <AquaSKKCore/skkserv.h>

#pragma mark - state

#import <AquaSKKCore/GenericStateMachine.h>
#import <AquaSKKCore/SKKEvent.h>
#import <AquaSKKCore/SKKState.h>
#import <AquaSKKCore/SKKStateMachine.h>

#pragma mark - utility

#import <AquaSKKCore/AISRomanKanaConverter.h>
#import <AquaSKKCore/SKKRomanKanaConverter.h>

#pragma mark - utility

#import <AquaSKKCore/subrange.h>
