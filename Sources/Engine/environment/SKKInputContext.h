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

#ifndef SKKInputContext_h
#define SKKInputContext_h

#import <swift/bridging>
#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKBackend/SKKEntry.h>
#import <AquaSKKBackend/IntrusiveRefCounted.h>

@class SKKCandidateBridge;
@class SKKOutputBufferImpl;
@class SKKUndoContextImpl;
@class SKKRegistrationImpl;
@protocol SKKFrontEndProtocol;
// 入力コンテキスト
class SKKInputContext : public IntrusiveRefCounted<SKKInputContext> {
public:
    SKKEntry entry;
    SKKCandidate candidate;
    SKKOutputBufferImpl *output;
    SKKUndoContextImpl *undo;
    SKKRegistrationImpl *registration;

    bool event_handled;
    bool needs_setback;
    bool dynamic_completion;
    bool annotation;

    SKKInputContext(id<SKKFrontEndProtocol> frontend);
    static SKKInputContext *createInstance(id<SKKFrontEndProtocol> frontend) {
        return new SKKInputContext(frontend);
    }
    SKKCandidateBridge *getCandidateBridge() const SWIFT_COMPUTED_PROPERTY;

} SWIFT_SHARED_REFERENCE(retainSKKInputContext, releaseSKKInputContext);

void retainSKKInputContext(SKKInputContext *obj);
void releaseSKKInputContext(SKKInputContext *obj);

#endif
