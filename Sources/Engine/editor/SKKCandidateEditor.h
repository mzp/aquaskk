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

#ifndef SKKCandidateEditor_h
#define SKKCandidateEditor_h

#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKEntry.h>
#import <AquaSKKBackend/SwiftObject.h>
#import <AquaSKKEngine/SKKBaseEditor.h>

namespace AquaSKKEngine {
    class SKKCandidateEditorImpl;
}

class SKKCandidateEditor : public SKKBaseEditor {
    SwiftObject<AquaSKKEngine::SKKCandidateEditorImpl> *impl_;

public:
    SKKCandidateEditor(SKKInputContext *context);

    virtual void ReadContext();
    virtual void WriteContext();
    virtual void Commit(std::string &queue);

    void SetCandidate(const SKKCandidate &candidate);
};

#endif
