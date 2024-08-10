//
//  AISJisyo.m
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <AquaSKKService/AISJisyo.h>
#import <AquaSKKService/SKKConstVars.h>

namespace {
// 順番の入れ替えは禁止(追加のみ)
struct DictionaryTypes {
    enum {
        Common,
        AutoUpdate,
        Proxy,
        Kotoeri,
        Gadget,
        CommonUTF8,
    };
};

NSString *DictionaryNames[] = {
    @"SKK 辞書(EUC-JP)", @"SKK 辞書(自動ダウンロード)",
    @"skkserv 辞書",     @"ことえり辞書",
    @"プログラム辞書",   @"SKK 辞書(UTF-8)"};
} // namespace

@interface AISJisyo ()
@property(strong, nonatomic) NSMutableDictionary *dictionary;
@end

@implementation AISJisyo

- (instancetype)initWithDictionary:(NSMutableDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

- (instancetype)initWithType:(AISJisyoType)type
                    location:(NSString *)location
                     enabled:(BOOL)enabled {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[SKKDictionarySetKeys::type] = @(type);
    dictionary[SKKDictionarySetKeys::location] = location;
    dictionary[SKKDictionarySetKeys::active] = @(enabled);
    return [self initWithDictionary:dictionary];
}

- (NSString *)location {
    return self.dictionary[SKKDictionarySetKeys::location];
}

- (void)setLocation:(NSString *)location {
    _dictionary[SKKDictionarySetKeys::location] = location;
}

- (void)setType:(AISJisyoType)type {
    _dictionary[SKKDictionarySetKeys::type] = @(type);
}

- (AISJisyoType)type {
    return (AISJisyoType)((NSNumber *)
                              self.dictionary[SKKDictionarySetKeys::type])
        .integerValue;
}

- (BOOL)enabled {
    return ((NSNumber *)self.dictionary[SKKDictionarySetKeys::active])
        .boolValue;
}

- (void)setEnabled:(BOOL)enabled {
    _dictionary[SKKDictionarySetKeys::active] = @(enabled);
}

- (NSString *)displayLocation {
    return [self.location stringByAbbreviatingWithTildeInPath];
}

- (NSString *)displayType {
    return [[self class] displayNameForJisyoType:self.type];
}

+ (NSArray *)dictionaryTypes {
    static NSArray *__dictionaryTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      int order[] = {DictionaryTypes::Common,
                     DictionaryTypes::CommonUTF8,
                     DictionaryTypes::AutoUpdate,
                     DictionaryTypes::Proxy,
                     DictionaryTypes::Kotoeri,
                     DictionaryTypes::Gadget,
                     0xff};
      NSMutableArray *types = [[NSMutableArray alloc] init];

      for (int index = 0; order[index] != 0xff; ++index) {
          NSNumber *type = [NSNumber numberWithInt:order[index]];
          NSString *name = DictionaryNames[order[index]];
          NSDictionary *entity = [NSDictionary
              dictionaryWithObjectsAndKeys:type, SKKDictionaryTypeKeys::type,
                                           name, SKKDictionaryTypeKeys::name,
                                           nil];
          [types addObject:entity];
      }

      __dictionaryTypes = types;
    });
    return __dictionaryTypes;
}

+ (NSString *)displayNameForJisyoType:(AISJisyoType)jisyoType {
    for (NSDictionary *item in self.class.dictionaryTypes) {
        NSNumber *type = [item valueForKey:SKKDictionaryTypeKeys::type];

        if (type.integerValue == jisyoType) {
            return [item valueForKey:SKKDictionaryTypeKeys::name];
        }
    }
    return @"";
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:AISJisyo.class]) {
        AISJisyo *otherJisyo = (AISJisyo *)other;
        BOOL isEqual = YES;
        isEqual = isEqual && self.type == otherJisyo.type;
        isEqual = isEqual && [self.location isEqualToString:otherJisyo.location];
        isEqual = isEqual && self.enabled == otherJisyo.enabled;
        return isEqual;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return NO;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<AISJisyo: type=%@;location=%@;enabled=%@>", self.displayType, self.location, @(self.enabled)];
}

- (NSUInteger)hash
{
    NSUInteger hash = 0;
    hash = hash * 31 + self.type;
    hash = hash * 31 + [self.location hash];
    hash = hash * 31 + (self.enabled ? 1 : 0);
    return hash;
}

@end
