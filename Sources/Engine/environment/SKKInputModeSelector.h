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

#ifndef SKKInputModeSelector_h
#define SKKInputModeSelector_h

#include <vector>
#import <Foundation/Foundation.h>
#include <swift/bridging>
#import <AquaSKKBackend/SKKInputMode.h>
#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKInputModeListener.h>
#import <AquaSKKEngine/SKKWidget.h>

@protocol SKKInputModeListenerProtocol;

class SKKInputModeSelector : public SKKWidget, public IntrusiveRefCounted<SKKInputModeSelector> {
    NSArray<id<SKKInputModeListenerProtocol>> *listeners_;
    SKKInputMode mode_;
    bool needsUpdate_;

    virtual void SKKWidgetShow();
    virtual void SKKWidgetHide();

public:
    SKKInputModeSelector(NSArray<id<SKKInputModeListenerProtocol>> *listeners);

    void Select(SKKInputMode mode);
    void Notify();
    void Refresh();
    SKKInputMode getInputMode() const SWIFT_COMPUTED_PROPERTY;
    operator SKKInputMode() const;
} SWIFT_SHARED_REFERENCE(retainSKKInputModeSelector, releaseSKKInputModeSelector);

void retainSKKInputModeSelector(SKKInputModeSelector *obj);
void releaseSKKInputModeSelector(SKKInputModeSelector *obj);

#endif
