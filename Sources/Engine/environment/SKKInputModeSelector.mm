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

#import "SKKInputModeSelector.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

@interface InputModeSelectorAdapter : NSObject <SKKInputModeSelectorDataSource> {
@public
    NSArray<id<SKKInputModeListenerProtocol>> *array_;
}
@end

@implementation InputModeSelectorAdapter

- (NSArray<id<SKKInputModeListenerProtocol>> *)listeners {
    return array_;
}
@end

SKKInputModeSelector::SKKInputModeSelector(NSArray<id<SKKInputModeListenerProtocol>> *listeners)
    : SKKWidget(true) {
    InputModeSelectorAdapter *dataSource = [[InputModeSelectorAdapter alloc] init];
    dataSource->array_ = listeners;
    dataSource_ = dataSource;
    listeners_ = listeners;
    impl_ = [[SKKInputModeSelectorImpl alloc] init];
    impl_.dataSource = dataSource_;
}

void SKKInputModeSelector::Select(SKKInputMode mode) {
    [impl_ selectWithInputMode:mode];
}

void SKKInputModeSelector::Notify() {
    [impl_ notify];
}

void SKKInputModeSelector::Refresh() {
    [impl_ refresh];
}

SKKInputModeSelector::operator SKKInputMode() const {
    return getInputMode();
}

SKKInputMode SKKInputModeSelector::getInputMode() const SWIFT_COMPUTED_PROPERTY {
    return [impl_ inputMode];
}

// ------------------------------------------------------------

void SKKInputModeSelector::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void SKKInputModeSelector::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}

void SKKInputModeSelector::Show() {
    [impl_ show];
}

void SKKInputModeSelector::Hide() {
    [impl_ hide];
}

void SKKInputModeSelector::Activate() {
    [impl_ activate];
}

void SKKInputModeSelector::Deactivate() {
    [impl_ deactivate];
}

void retainSKKInputModeSelector(SKKInputModeSelector *obj) {
    obj->retain();
}

void releaseSKKInputModeSelector(SKKInputModeSelector *obj) {
    obj->release();
}
