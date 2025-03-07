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
#import <swift/bridging>

enum class SKKRegistrationState {
    None,
    Started,
    Finished,
    Aborted
};

class SKKRegistrationContainer;

class SKKRegistration {
    SKKRegistrationContainer *container_;
public:
    SKKRegistration();
    void Start();
    void Finish(const std::string &str);
    void Abort();
    void Clear();
    operator SKKRegistrationState() const {
        return getState();
    }
    const SKKRegistrationState getState() const SWIFT_COMPUTED_PROPERTY;
    const std::string getWord() const SWIFT_COMPUTED_PROPERTY;
    const std::string Word() const;
private:
    SKKRegistrationState state_;
    std::string word_;
};

#endif
