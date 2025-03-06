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

#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKRegisterEditor.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import "SKKTextBuffer.h"

SKKRegisterEditor::SKKRegisterEditor(SKKInputContext *context)
    : SKKBaseEditor(context),
      entry_(context->entry),
      word_(new SKKTextBuffer()),
      impl_(new SwiftObject(AquaSKKEngine::SKKRegisterEditorImpl::init(context))) {
    //    prompt_ = "[登録：" + entry_.PromptString() + "]";
}

SKKRegisterEditor::~SKKRegisterEditor() {
    delete word_;
}

void SKKRegisterEditor::ReadContext() {
    /*    context()->entry = SKKEntry();

        Input(context()->registration.Word());
        context()->registration.Clear();*/
    (*impl_)->readConext();
}

void SKKRegisterEditor::WriteContext() {
    (*impl_)->writeContext();
    /*    context()->output.Compose(prompt_ + word_->String(), word_->CursorPosition());*/
}

void SKKRegisterEditor::Input(const std::string &ascii) {
    (*impl_)->input(ascii);
    //    word_->Insert(ascii);
}

void SKKRegisterEditor::Input(const std::string &fixed, const std::string &input, char code) {
    (*impl_)->input(fixed, input, code);
    //    Input(fixed);
}

void SKKRegisterEditor::Input(SKKBaseEditorEvent event) {
    /*    switch(event) {
        case SKKBaseEditorEventBackSpace:
            word_->BackSpace();
            break;

        case SKKBaseEditorEventDelete:
            word_->Delete();
            break;

        case SKKBaseEditorEventCursorLeft:
            word_->CursorLeft();
            break;

        case SKKBaseEditorEventCursorRight:
            word_->CursorRight();
            break;

        case SKKBaseEditorEventCursorUp:
            word_->CursorUp();
            break;

        case SKKBaseEditorEventCursorDown:
            word_->CursorDown();
            break;

        default:
            return;
        }*/
    (*impl_)->inputEvent(event);
}

void SKKRegisterEditor::Commit(std::string &queue) {
    queue = (*impl_)->commit(queue);
    /*    word_->Insert(queue);
        queue = word_->String();

        context()->entry = entry_;*/
}
