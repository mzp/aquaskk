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

#ifndef SKKRegistration_h
#define SKKRegistration_h

#include <string>

enum SKKRegistrationState {
    SKKRegistrationNone,
    SKKRegistrationStarted,
    SKKRegistrationFinished,
    SKKRegistrationAborted
};

class SKKRegistration {
public:
    SKKRegistration()
        : state_(SKKRegistrationNone) {}

    void Start() {
        state_ = SKKRegistrationStarted;
    }

    void Finish(const std::string &str) {
        state_ = SKKRegistrationFinished;
        word_ = str;
    }

    void Abort() {
        state_ = SKKRegistrationAborted;
        word_.clear();
    }

    void Clear() {
        state_ = SKKRegistrationNone;
        word_.clear();
    }

    operator SKKRegistrationState() const {
        return state_;
    }

    const SKKRegistrationState getState() const SWIFT_COMPUTED_PROPERTY {
        return state_;
    }
    const std::string getWord() const SWIFT_COMPUTED_PROPERTY {
        return word_;
    }

    const std::string &Word() const {
        return word_;
    }

private:
    SKKRegistrationState state_;
    std::string word_;
};

#endif
