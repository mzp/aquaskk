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
#import <InputMethodKit/InputMethodKit.h>
#import <AquaSKKBackend/SKKInputMode.h>
#import <AquaSKKInput/MacFrontEnd.h>
#import <AquaSKKService/SKKSupervisor.h>
#import <AquaSKKEngine/SKKEvent.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>

MacFrontEnd::MacFrontEnd(id client) {
    impl_ = [[MacFrontEndImpl alloc] initWithClient:client];
}

MacFrontEnd::~MacFrontEnd() {
    [impl_ release];
}

void MacFrontEnd::InsertString(const std::string &str) {
    NSString *string = [NSString stringWithUTF8String:str.c_str()];
    [impl_ insertString:string];
}

void MacFrontEnd::ComposeString(const std::string &str, int cursorOffset) {
    NSString *string = [NSString stringWithUTF8String:str.c_str()];
    [impl_ composeString:string cursorOffset:cursorOffset];
}

void MacFrontEnd::ComposeString(const std::string &str, int candidateStart, int candidateLength) {
    NSString *string = [NSString stringWithUTF8String:str.c_str()];
    [impl_ composeString:string candidateStart:candidateStart candidateLength:candidateLength];
}

std::string MacFrontEnd::SelectedString() {
    NSString *string = [impl_ selectedString];
    return [string UTF8String];
}
