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

#import <AppKit/AppKit.h>
#import <AquaSKKInput/MacDynamicCompletor.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import <AquaSKKInput/AquaSKKInput-Preamble.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>

MacDynamicCompletor::MacDynamicCompletor(SKKLayoutManager *layout) {
    impl_ = [[MacDynamicCompletorImpl alloc] initWithLayoutManager:layout];
}

MacDynamicCompletor::~MacDynamicCompletor() {
    [impl_ release];
}

void MacDynamicCompletor::Update(const std::string &completion, int commonPrefixLength, int cursorOffset) {
    NSString *string = [NSString stringWithUTF8String:completion.c_str()];

    [impl_ updateWithCompletion:string commonPrefixLength:commonPrefixLength cursorOffset:cursorOffset];
}

// ------------------------------------------------------------

void MacDynamicCompletor::SKKWidgetShow() {
    [impl_ skkWidgetShow];
}

void MacDynamicCompletor::SKKWidgetHide() {
    [impl_ skkWidgetHide];
}
