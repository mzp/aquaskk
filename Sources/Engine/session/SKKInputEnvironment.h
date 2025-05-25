/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2009 Tomotaka SUWA <t.suwa@mac.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

#ifndef SKKInputEnvironment_h
#define SKKInputEnvironment_h

#include <memory>
#include <string>
#include <swift/bridging>
#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKBaseEditor.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputModeSelector.h>
#import <AquaSKKEngine/SKKInputSessionParameter.h>

class SKKInputEnvironment : public IntrusiveRefCounted<SKKInputEnvironment> {
    SKKInputContext *context_;
    SKKInputSessionParameter *param_;
    SKKInputModeSelector selector_;
    std::unique_ptr<SKKBaseEditor> bottom_;

public:
    SKKInputEnvironment(
        SKKInputContext *context, SKKInputSessionParameter *param, SKKInputModeListenerCollection *listeners,
        SKKBaseEditor *bottom);

    SKKAnnotator *Annotator() const;
    SKKConfig *Config() const;
    SKKFrontEnd *FrontEnd() const;
    SKKMessenger *Messenger() const;
    SKKCandidateWindow *CandidateWindow() const;
    SKKDynamicCompletor *DynamicCompletor() const;

    SKKInputContext *InputContext();
    SKKInputSessionParameter *InputSessionParameter();
    SKKInputModeSelector *InputModeSelector();
    SKKBaseEditor *BaseEditor();

    std::string PasteString();

    bool IsPrimaryEditor() const;
} SWIFT_SHARED_REFERENCE(retainSKKInputEnvironment, releaseSKKInputEnvironment);

void retainSKKInputEnvironment(SKKInputEnvironment *obj);
void releaseSKKInputEnvironment(SKKInputEnvironment *obj);

#endif
