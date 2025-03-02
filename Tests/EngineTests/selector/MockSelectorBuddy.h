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
/*

#ifndef MockBuddy_h
#define MockBuddy_h

#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKEntry.h>
#import <AquaSKKEngine/SKKSelectorBuddy.h>

class MockSelectorBuddy : public SKKSelectorBuddy {
    SKKCandidate candidate_;

    virtual const SKKEntry SKKSelectorQueryEntry() {
        return SKKEntry("かんじ");
    }

    virtual void SKKSelectorUpdate(const SKKCandidate &candidate) {
        candidate_ = candidate;
    }

public:
    MockSelectorBuddy();
    SKKCandidate &Current() {
        return candidate_;
    }

    SKKCandidate getCurrent() const SWIFT_COMPUTED_PROPERTY {
        return candidate_;
    }
    static SKKSelectorBuddy*_Nonnull Coerce(MockSelectorBuddy *_Nonnull buddy) { return buddy; }

    static MockSelectorBuddy *_Nonnull newInstance();
} SWIFT_SHARED_REFERENCE(retainMockSelectorBuddy, releaseMockSelectorBuddy);

void retainMockSelectorBuddy(SKKSelectorBuddy *_Nonnull obj);

void releaseMockSelectorBuddy(SKKSelectorBuddy *_Nonnull obj);


#endif /* MockBuddy_h */
*/
