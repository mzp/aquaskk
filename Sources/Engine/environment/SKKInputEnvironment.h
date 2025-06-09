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

#ifndef SKKInputEnvironment_h
#define SKKInputEnvironment_h

#include <memory>
#include <string>
#import <Foundation/Foundation.h>
#include <swift/bridging>
#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKCandidateWindowBridge.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputSessionParameter.h>

@protocol SKKInputSessionParameterProtocol;
@protocol SKKInputModeSelectorDataSourceProtocol;
@class SKKInputEnvironmentImpl;
@class SKKInputModeSelectorImpl;
@protocol SKKInputModeListenerProtocol;
@class SKKInputModeSelectorImpl;
@protocol SKKInputModeSelectorDataSourceProtocol;

class SKKInputEnvironment : public IntrusiveRefCounted<SKKInputEnvironment> {
    SKKInputContext *context_;
    id<SKKInputSessionParameterProtocol> paramImpl_;

    id<SKKInputModeSelectorDataSourceProtocol> dataSource_;
    SKKInputSessionParameter *param_;
    SKKInputModeSelectorImpl *selectorImpl_;
    bool isPrimaryEditor_;

public:
    SKKInputEnvironment(
        SKKInputContext *context, id<SKKInputSessionParameterProtocol> param,
        NSArray<id<SKKInputModeListenerProtocol>> *listeners, bool isPrimaryEditor);

    SKKInputEnvironmentImpl *getImpl();
} SWIFT_SHARED_REFERENCE(retainSKKInputEnvironment, releaseSKKInputEnvironment);

void retainSKKInputEnvironment(SKKInputEnvironment *obj);
void releaseSKKInputEnvironment(SKKInputEnvironment *obj);

#endif
