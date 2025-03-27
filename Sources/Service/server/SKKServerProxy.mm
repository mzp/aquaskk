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

#import <AquaSKKService/AISJisyo.h>
#import <AquaSKKService/SKKServerProxy.h>

NSNotificationName const kSKKSupervisorReloadBlacklistApps = @"SKKSupervisorReloadBlacklistApps";
NSNotificationName const kSKKSupervisorReloadUserDefaults = @"SKKSupervisorReloadUserDefaults";
NSNotificationName const kSKKSupervisorReloadDictionarySets = @"SKKSupervisorReloadDictionarySets";
NSNotificationName const kSKKSupervisorReloadComponents = @"SKKSupervisorReloadComponents";

@implementation SKKServerProxy

- (id)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)reloadBlacklistApps {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSKKSupervisorReloadBlacklistApps object:nil];
}

- (void)reloadUserDefaults {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSKKSupervisorReloadUserDefaults object:nil];
}

- (void)reloadDictionarySet {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSKKSupervisorReloadUserDefaults object:nil];
}

- (void)reloadComponents {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSKKSupervisorReloadUserDefaults object:nil];
}

- (NSArray *)createDictionaryTypes {
    return [AISJisyo dictionaryTypes];
}

@end
