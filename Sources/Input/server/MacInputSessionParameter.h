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

#ifndef MacInputSessionParameter_h
#define MacInputSessionParameter_h

#include <memory>
#import <AquaSKKCore/SKKInputSessionParameter.h>
#import <AquaSKKInput/SKKLayoutManager.h>

class MacInputSessionParameter : public SKKInputSessionParameter {
    std::unique_ptr<SKKConfig> config_;
    std::unique_ptr<SKKFrontEnd> frontend_;
    std::unique_ptr<SKKMessenger> messenger_;
    std::unique_ptr<SKKClipboard> clipboard_;
    std::unique_ptr<SKKCandidateWindow> candidateWindow_;
    std::unique_ptr<SKKAnnotator> annotator_;
    std::unique_ptr<SKKDynamicCompletor> completor_;

public:
    MacInputSessionParameter(id client, SKKLayoutManager *layout);

    virtual SKKConfig *Config();
    virtual SKKFrontEnd *FrontEnd();
    virtual SKKMessenger *Messenger();
    virtual SKKClipboard *Clipboard();
    virtual SKKCandidateWindow *CandidateWindow();
    virtual SKKAnnotator *Annotator();
    virtual SKKDynamicCompletor *DynamicCompletor();
};

#endif
