/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008 Tomotaka SUWA <t.suwa@mac.com>

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

#import <AquaSKKEngine/SKKInputSessionParameter.h>
#import <AquaSKKEngine/SKKRecursiveEditor.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#include "utf8util.h"

SKKRecursiveEditor::SKKRecursiveEditor(SKKInputEnvironment *env)
    : editor_(env), state_(SKKState(env, &editor_)) {

    SKKAnnotator *annotator = env->InputSessionParameter()->Annotator();
    SKKDynamicCompletor *completor = env->InputSessionParameter()->DynamicCompletor();
    SKKCandidateWindow *candidateWindow = env->InputSessionParameter()->CandidateWindow();
    impl_ = new SwiftObject(AquaSKKEngine::SKKRecursiveEditorImpl::init(env, annotator, completor, candidateWindow));
}

SKKRecursiveEditor::~SKKRecursiveEditor() {
    delete impl_;
}

void SKKRecursiveEditor::Input(const SKKEvent &event) {
    (*impl_)->input(event);
    state_.Dispatch(SKKStateMachine::Event(event.id, event));
}

void SKKRecursiveEditor::Output() {
    editor_.UpdateInputContext();
    (*impl_)->output();
}

void SKKRecursiveEditor::Activate() {
    (*impl_)->activate();
}

void SKKRecursiveEditor::Deactivate() {
    (*impl_)->deactivate();
}

bool SKKRecursiveEditor::IsChildOf(SKKStateMachine::Handler handler) {
    return state_.IsChildOf(handler);
}
