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

#import <AquaSKKEngine/SKKClipboard.h>
#import <AquaSKKEngine/SKKInputEnvironment.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKInputEnvironment::SKKInputEnvironment(
    SKKInputContext *context, id<SKKInputSessionParameterProtocol> param, SKKInputModeListenerCollection *listeners,
    bool isPrimaryEditor)
    : context_(context),
      paramImpl_(param),
      param_(new SKKInputSessionParameterAdapter(param)),
      selector_(listeners),
      isPrimaryEditor_(isPrimaryEditor) {}

std::string SKKInputEnvironment::PasteString() {
    return param_->Clipboard()->PasteString();
}

SKKInputContext *SKKInputEnvironment::InputContext() {
    return context_;
}

SKKInputSessionParameter *SKKInputEnvironment::InputSessionParameter() {
    return param_;
}

SKKInputModeSelector *SKKInputEnvironment::InputModeSelector() {
    return &selector_;
}

bool SKKInputEnvironment::IsPrimaryEditor() const {
    return bottom_->IsPrimaryEditor();
}

SKKAnnotator *SKKInputEnvironment::Annotator() const {
    return param_->Annotator();
}

SKKConfig *SKKInputEnvironment::Config() const {
    return param_->Config();
}

SKKFrontEnd *SKKInputEnvironment::FrontEnd() const {
    return param_->FrontEnd();
}
SKKMessenger *SKKInputEnvironment::Messenger() const {
    return param_->Messenger();
}
SKKCandidateWindow *SKKInputEnvironment::CandidateWindow() const {
    return param_->CandidateWindow();
}

SKKCandidateWindowBridge *SKKInputEnvironment::CandidateWindowBridge() const {
    return new SKKCandidateWindowBridge(CandidateWindow());
}

SKKDynamicCompletor *SKKInputEnvironment::DynamicCompletor() const {
    return param_->DynamicCompletor();
}

SKKInputEnvironmentImpl *SKKInputEnvironment::getImpl() {
    return [[SKKInputEnvironmentImpl alloc] initWithContext:this->InputContext()
                                                      param:paramImpl_
                                                   selector:&selector_
                                            isPrimaryEditor:isPrimaryEditor_];
}
void retainSKKInputEnvironment(SKKInputEnvironment *obj) {
    obj->retain();
}

void releaseSKKInputEnvironment(SKKInputEnvironment *obj) {
    obj->release();
}
