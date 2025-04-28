/* -*- C++ -*-

   Generic State Machine Library for C++.

   Copyright (c) 2006-2008, Tomotaka SUWA <t.suwa@mac.com>

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   Neither the name of the authors nor the names of its contributors
   may be used to endorse or promote products derived from this
   software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
   COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

*/

#ifndef GenericStateMachine_h
#define GenericStateMachine_h

#include <swift/bridging>
#include <AquaSKKEngine/SKKEventID.h>

namespace statemachinecxx_sourceforge_jp {
    // ======================================================================
    // event
    // ======================================================================
    template <class ParamType> class GenericEvent {
        int signal_;
        ParamType param_;

    public:
        GenericEvent() {}
        GenericEvent(int signal)
            : signal_(signal) {}
        GenericEvent(int signal, const ParamType &param)
            : signal_(signal), param_(param) {}

        operator int() const {
            return signal_;
        }
        void SetSignal(int signal) {
            signal_ = signal;
        }
        int getSignal() const SWIFT_COMPUTED_PROPERTY {
            return signal_;
        }
        SKKEventID getID() const SWIFT_COMPUTED_PROPERTY {
            return static_cast<SKKEventID>(signal_);
        }

        const ParamType &Param() const {
            return param_;
        }

        const ParamType getParam() const SWIFT_COMPUTED_PROPERTY {
            return Param();
        }

        void SetParam(const ParamType &arg) {
            param_ = arg;
        }

        bool IsSystem() const {
            return signal_ < USER_EVENT;
        }
        bool IsUser() const {
            return !IsSystem();
        }

        static GenericEvent &Probe() {
            static GenericEvent evt(PROBE);
            return evt;
        }
        static GenericEvent &Entry() {
            static GenericEvent evt(ENTRY_EVENT);
            return evt;
        }
        static GenericEvent &Exit() {
            static GenericEvent evt(EXIT_EVENT);
            return evt;
        }
        static GenericEvent &Init() {
            static GenericEvent evt(INIT_EVENT);
            return evt;
        }
    };
} // namespace statemachinecxx_sourceforge_jp

#endif // INC__GenericStateMachine__
