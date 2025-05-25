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

#import "SKKInputSessionParameterAdapter.h"
#import <AquaSKKEngine/SKKAnnotatorAdapter.h>
#import <AquaSKKEngine/SKKCandidateWindowAdapter.h>
#import <AquaSKKEngine/SKKClipboardAdapter.h>
#import <AquaSKKEngine/SKKConfigAdapter.h>
#import <AquaSKKEngine/SKKDynamicCompletorAdapter.h>
#import <AquaSKKEngine/SKKFrontEndAdapter.h>
#import <AquaSKKEngine/SKKMessengerAdapter.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKInputSessionParameterAdapter::SKKInputSessionParameterAdapter(id<SKKInputSessionParameterProtocol> impl)
    : config_(new SKKConfigAdapter(impl.config)),
      frontend_(new SKKFrontEndAdapter(impl.frontEnd)),
      messenger_(new SKKMessengerAdapter(impl.messenger)),
      clipboard_(new SKKClipboardAdapter(impl.clipboard)),
      candidateWindow_(new SKKCandidateWindowAdapter(impl.candidateWindow)),
      annotator_(new SKKAnnotatorAdapter(impl.annotator)),
      completor_(new SKKDynamicCompletorAdapter(impl.dynamicCompletor)) {}

SKKConfig *SKKInputSessionParameterAdapter::Config() {
    return config_.get();
}

SKKFrontEnd *SKKInputSessionParameterAdapter::FrontEnd() {
    return frontend_.get();
}

SKKMessenger *SKKInputSessionParameterAdapter::Messenger() {
    return messenger_.get();
}

SKKClipboard *SKKInputSessionParameterAdapter::Clipboard() {
    return clipboard_.get();
}

SKKCandidateWindow *SKKInputSessionParameterAdapter::CandidateWindow() {
    return candidateWindow_.get();
}

SKKAnnotator *SKKInputSessionParameterAdapter::Annotator() {
    return annotator_.get();
}

SKKDynamicCompletor *SKKInputSessionParameterAdapter::DynamicCompletor() {
    return completor_.get();
}
