/* -*- mode: C++; coding: utf-8 -*-

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

#import <AquaSKKEngine/SKKComposingEditor.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import "SKKTextBuffer.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>


SKKComposingEditor::SKKComposingEditor(SKKInputContext *context)
    : SKKBaseEditor(context), composing_(new SKKTextBuffer()),
impl_(new SwiftObject<AquaSKKEngine::SKKComposingEditorImpl>(
    AquaSKKEngine::SKKComposingEditorImpl::init(context)))
{}

SKKComposingEditor::~SKKComposingEditor() {
    delete composing_;
}

void SKKComposingEditor::ReadContext() {
/*    composing_->Clear();

    if(context()->entry.IsEmpty()) {
        // 直接入力モードからの遷移
        composing_->Insert(context()->undo.Entry());
    } else {
        // 変換モードからの遷移なので、見出し語を復元する
        context()->entry.SetOkuri("", "");
        composing_->Insert(context()->entry.EntryString());
    }

    context()->dynamic_completion = true;*/
    (*impl_)->readContext();
}

void SKKComposingEditor::WriteContext() {
/*    context()->output.SetMark();
    context()->output.Compose("▽" + composing_->String(), composing_->CursorPosition());

    update();*/
    (*impl_)->writeContext();
}

void SKKComposingEditor::Input(const std::string &ascii) {
/*    composing_->Insert(ascii);

    update();*/
    (*impl_)->input(ascii);
}

void SKKComposingEditor::Input(const std::string &fixed, const std::string &input, char code) {
//    Input(fixed);
    (*impl_)->input(fixed, input, code);
}

void SKKComposingEditor::Input(SKKBaseEditorEvent event) {
/*    switch(event) {
        case SKKBaseEditorEventBackSpace:
        if(composing_->IsEmpty()) {
            context()->needs_setback = true;
        }
        composing_->BackSpace();
        break;

    case SKKBaseEditorEventDelete:
        composing_->Delete();
        break;

    case SKKBaseEditorEventCursorLeft:
        composing_->CursorLeft();
        break;

    case SKKBaseEditorEventCursorRight:
        composing_->CursorRight();
        break;

    case SKKBaseEditorEventCursorUp:
        composing_->CursorUp();
        break;

    case SKKBaseEditorEventCursorDown:
        composing_->CursorDown();
        break;
    }

    update();*/
    (*impl_)->inputEvent(event);
}

void SKKComposingEditor::Commit(std::string &queue) {
//    queue = composing_->String();
    queue = (*impl_)->commit(queue);
}

// ----------------------------------------------------------------------

void SKKComposingEditor::SetEntry(const std::string &entry) {
/*    composing_->Clear();
    composing_->Insert(entry);

    update();*/
    (*impl_)->setEntry(entry);
}

// ----------------------------------------------------------------------

void SKKComposingEditor::update() {
//    context()->entry = SKKEntry(composing_->LeftString());
}
