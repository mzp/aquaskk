/* -*- ObjC -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2010 Tomotaka SUWA <tomotaka.suwa@gmail.com>

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

#include "DictionaryTypeTransformer.h"
#import <AquaSKKService/SKKConstVars.h>

@implementation DictionaryTypeTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)initWithDictionaryTypes:(NSArray *)dictionaryTypes {
    if(self = [super init]) {
        dictionaryTypes_ = [dictionaryTypes retain];
    }

    return self;
}

- (void)dealloc {
    [dictionaryTypes_ release];

    [super dealloc];
}

- (id)transformedValue:(id)value {
    for(NSDictionary *item in dictionaryTypes_) {
        NSString *type = [item valueForKey:SKKDictionaryTypeKeys::type];

        if([type compare:value] == NSOrderedSame) {
            return [item valueForKey:SKKDictionaryTypeKeys::name];
        }
    }

    return nil;
}

- (id)reverseTransformedValue:(id)value {
    for(NSDictionary *item in dictionaryTypes_) {
        NSString *name = [item valueForKey:SKKDictionaryTypeKeys::name];

        if([name compare:value] == NSOrderedSame) {
            return [item valueForKey:SKKDictionaryTypeKeys::type];
        }
    }

    return nil;
}

@end
