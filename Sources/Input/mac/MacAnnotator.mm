/* -*- ObjC -*-

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

#import <AppKit/AppKit.h>
#import <InputMethodKit/InputMethodKit.h>
#import <AquaSKKBackend/SKKCandidateBridge.h>
#import <AquaSKKBackend/SKKInputMode.h>
#import <AquaSKKInput/MacAnnotator.h>
#import <AquaSKKService/SKKSupervisor.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>
#import <AquaSKKUI/AquaSKKUI-Swift.h>

MacAnnotator::MacAnnotator(SKKLayoutManager *layout) {
    impl_ = [[MacAnnotatorImpl alloc] initWithLayoutManager:layout->getImpl()];
}

MacAnnotator::~MacAnnotator() {
    [impl_ release];
}

void MacAnnotator::Update(const SKKCandidate &candidate, int cursorOffset) {

    SKKCandidateBridge *bridge = [SKKCandidateBridge candidateFromCpp:&candidate];
    [impl_ update:bridge cursorOffset:cursorOffset];
}

void MacAnnotator::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void MacAnnotator::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}
