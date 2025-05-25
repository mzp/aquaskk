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

#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKInput/MacInputSessionParameter.h>
#import <AquaSKKInput/AquaSKKInput-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>

MacInputSessionParameter::MacInputSessionParameter(id client, SKKLayoutManager *layout)
    : config_(new SKKConfigAdapter([[MacConfigImpl alloc] init])),
      frontend_(new SKKFrontEndAdapter([[MacFrontEndImpl alloc] initWithClient:client])),
      messenger_(new SKKMessengerAdapter([[MacMessengerImpl alloc] initWithLayoutManager:layout])),
      clipboard_(new SKKClipboardAdapter([[MacClipboardImpl alloc] init])),
      candidateWindow_(new SKKCandidateWindowAdapter([[MacCandidateWindowImpl alloc] initWithLayoutManager:layout])),
      annotator_(new SKKAnnotatorAdapter([[MacAnnotatorImpl alloc] initWithLayoutManager:layout])),
      completor_(new SKKDynamicCompletorAdapter([[MacDynamicCompletorImpl alloc] initWithLayoutManager:layout])) {}

SKKConfig *MacInputSessionParameter::Config() {
    return config_.get();
}

SKKFrontEnd *MacInputSessionParameter::FrontEnd() {
    return frontend_.get();
}

SKKMessenger *MacInputSessionParameter::Messenger() {
    return messenger_.get();
}

SKKClipboard *MacInputSessionParameter::Clipboard() {
    return clipboard_.get();
}

SKKCandidateWindow *MacInputSessionParameter::CandidateWindow() {
    return candidateWindow_.get();
}

SKKAnnotator *MacInputSessionParameter::Annotator() {
    return annotator_.get();
}

SKKDynamicCompletor *MacInputSessionParameter::DynamicCompletor() {
    return completor_.get();
}
