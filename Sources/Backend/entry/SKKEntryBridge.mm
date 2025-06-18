//
//  SKKEntryBridge.m
//  AquaSKKBackend
//
//  Created by mzp on 2025/06/17.
//

#import "SKKEntryBridge.h"
#import <AquaSKKBackend/SKKEncoding.h>
#import <AquaSKKBackend/SKKEntry.h>

@implementation SKKEntryBridge

- (instancetype)init {
    self = [super init];
    if(self) {
        _rawValue = new SKKEntry();
    }
    return self;
}

- (instancetype)initWithRawValue:(SKKEntry)entry {
    self = [super init];
    if(self) {
        _rawValue = new SKKEntry();
        *_rawValue = entry;
    }
    return self;
}

- (instancetype)initWithEntry:(NSString *)entry okuri:(NSString *)okuri {
    self = [super init];
    if(self) {
        _rawValue = new SKKEntry(entry.UTF8String, okuri.UTF8String);
    }
    return self;
}

- (void)dealloc {
    delete _rawValue;
}

- (NSString *)entryString {
    return SKKUTF8String(_rawValue->EntryString());
}

- (NSString *)promptString {
    return SKKUTF8String(_rawValue->PromptString());
}

- (NSString *)okuriString {
    return SKKUTF8String(_rawValue->OkuriString());
}

- (BOOL)isEmpty {
    return _rawValue->IsEmpty();
}

- (BOOL)isOkuriAri {
    return _rawValue->IsOkuriAri();
}

- (void)setOkuri:(NSString *)prefix kana:(NSString *)kana {
    _rawValue->SetOkuri(prefix.UTF8String, kana.UTF8String);
}

- (void)appendEntry:(NSString *)string {
    _rawValue->AppendEntry(string.UTF8String);
}

- (NSString *)toggleKana:(SKKInputMode)inputMode {
    return SKKUTF8String(_rawValue->ToggleKana(inputMode));
}

- (NSString *)toggleJisx0201Kana:(SKKInputMode)inputMode {
    return SKKUTF8String(_rawValue->ToggleJisx0201Kana(inputMode));
}

- (SKKEntryBridge *)normalize:(SKKInputMode)inputMode {
    SKKEntry entry = _rawValue->Normalize(inputMode);
    return [[SKKEntryBridge alloc] initWithRawValue:entry];
}

- (SKKEntry)copy {
    return *_rawValue;
}

@end
