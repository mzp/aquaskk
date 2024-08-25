//
//  AISSubRuleController.m
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

#import <AquaSKKService/AISSubRule.h>
#import <AquaSKKService/AISSubRuleController.h>
#import <AquaSKKService/SubRuleDescriptions.h>

namespace {
    const NSString *SUB_RULE_FOLDER = @"folder";
    const NSString *SUB_RULE_PATH = @"path";
    const NSString *SUB_RULE_SWITCH = @"active";
    const NSString *SUB_RULE_KEYMAP = @"keymap";
    const NSString *SUB_RULE_DESCRIPTION = @"description";
    const NSString *SUB_RULE_TYPE = @"type";
} // namespace

@interface AISSubRuleController ()
@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSArray<NSString *> *activeRules;
@end

@implementation AISSubRuleController

- (instancetype)initWithPath:(NSString *)path activeRules:(NSArray *)activeRules {
    self = [super init];
    if(self) {
        self.path = path;
        self.activeRules = activeRules;
        _allRules = [self initializeSubRulesAtPath];
    }
    return self;
}

- (NSArray<AISSubRule *> *)initializeSubRulesAtPath {
    SubRuleDescriptions *table = new SubRuleDescriptions([self.path UTF8String]);
    NSDirectoryEnumerator *files = [[NSFileManager defaultManager] enumeratorAtPath:self.path];
    NSMutableArray<AISSubRule *> *rules = [NSMutableArray array];
    while(NSString *file = [files nextObject]) {
        if([[file pathExtension] isEqualToString:@"rule"]) {
            AISSubRule *rule = [[AISSubRule alloc] init];
            rule.path = [self.path stringByAppendingPathComponent:file];
            rule.name = file;

            std::string path([file UTF8String]);
            if(table->HasKeymap(path)) {
                std::string keymap = table->Keymap(path);
                rule.keymap = [NSString stringWithUTF8String:keymap.c_str()];
            }

            rule.ruleDescription = [NSString stringWithUTF8String:table->Description([file UTF8String]).c_str()];

            BOOL enabled = self.activeRules != nil
                               ? [self.activeRules containsObject:[self.path stringByAppendingPathComponent:file]]
                               : NO;

            rule.enabled = enabled;
            [rules addObject:rule];
        }
    }
    [rules sortUsingComparator:^NSComparisonResult(AISSubRule *rule1, AISSubRule *rule2) {
      return [rule1.name compare:rule2.name];
    }];
    delete table;

    return rules;
}

@end
