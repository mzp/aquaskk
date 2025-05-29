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
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKComposingEditor::SKKComposingEditor(SKKInputContext *context)
    : SKKBaseEditor(context),
      impl_(new SwiftObject<AquaSKKEngine::SKKComposingEditorImpl>(
          AquaSKKEngine::SKKComposingEditorImpl::init(context))) {}

SKKComposingEditor::~SKKComposingEditor() {}

void SKKComposingEditor::ReadContext() {
    (*impl_)->readContext();
}

void SKKComposingEditor::WriteContext() {
    (*impl_)->writeContext();
}

void SKKComposingEditor::Input(const std::string &ascii) {
    (*impl_)->input(ascii);
}

void SKKComposingEditor::Input(const std::string &fixed, const std::string &input, char code) {
    (*impl_)->input(fixed, input, code);
}

void SKKComposingEditor::Input(SKKBaseEditorEvent event) {
    (*impl_)->bridgeInputEvent(event);
}

void SKKComposingEditor::Commit(std::string &queue) {
    queue = (*impl_)->commit(queue);
}

// ----------------------------------------------------------------------

void SKKComposingEditor::SetEntry(const std::string &entry) {
    (*impl_)->setEntry(entry);
}
