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
#import <AquaSKKEngine/SKKEntryRemoveEditor.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKEntryRemoveEditor::SKKEntryRemoveEditor(SKKInputContext *context)
    : SKKBaseEditor(context), impl_(new SwiftObject(AquaSKKEngine::SKKEntryRemoveEditorImpl::init(context))) {}

void SKKEntryRemoveEditor::ReadContext() {
    (*impl_)->readContext();
}

void SKKEntryRemoveEditor::WriteContext() {
    (*impl_)->writeContext();
}

void SKKEntryRemoveEditor::Input(const std::string &ascii) {
    (*impl_)->input(ascii);
}

void SKKEntryRemoveEditor::Input(const std::string &fixed, const std::string &input, char code) {
    (*impl_)->input(fixed, input, code);
}

void SKKEntryRemoveEditor::Input(SKKBaseEditorEvent event) {
    (*impl_)->inputEvent(event);
}

void SKKEntryRemoveEditor::Commit(std::string &queue) {
    queue = (*impl_)->commit(queue);
}
