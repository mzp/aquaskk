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

#import <AquaSKKService/SKKConstVars.h>
#include "ObjCUtil.h"

#define DECLARE_NSStringKey(key) NSString* key = @ #key

namespace SKKUserDefaultKeys {
    // boolean
    DECLARE_NSStringKey(suppress_newline_on_commit);

    DECLARE_NSStringKey(use_numeric_conversion);
    DECLARE_NSStringKey(show_input_mode_icon);
    DECLARE_NSStringKey(use_individual_input_mode);
    DECLARE_NSStringKey(beep_on_registration);
    DECLARE_NSStringKey(inline_backspace_implies_commit);
    DECLARE_NSStringKey(delete_okuri_when_quit);

    // string
    DECLARE_NSStringKey(keyboard_layout);

    // nsarray<nsstrig *>
    DECLARE_NSStringKey(sub_rules);
    DECLARE_NSStringKey(sub_keymaps);

    // boolean
    DECLARE_NSStringKey(enable_extended_completion);
    DECLARE_NSStringKey(enable_dynamic_completion);

    // number
    DECLARE_NSStringKey(dynamic_completion_range);
    DECLARE_NSStringKey(minimum_completion_length);
    DECLARE_NSStringKey(max_count_of_inline_candidates);

    // string
    DECLARE_NSStringKey(candidate_window_labels);
    DECLARE_NSStringKey(candidate_window_font_name);

    // number
    DECLARE_NSStringKey(candidate_window_font_size);
    // boolean
    DECLARE_NSStringKey(put_candidate_window_upward);
    // boolean
    DECLARE_NSStringKey(enable_annotation);

    // string
    DECLARE_NSStringKey(user_dictionary_path);

    // boolean
    DECLARE_NSStringKey(enable_skkserv);
    DECLARE_NSStringKey(skkserv_localonly);

    // number
    DECLARE_NSStringKey(skkserv_port);

    // boolean
    DECLARE_NSStringKey(enable_private_mode);
    DECLARE_NSStringKey(fix_intermediate_conversion);
    DECLARE_NSStringKey(display_shortest_match_of_kana_conversions);
    DECLARE_NSStringKey(handle_recursive_entry_as_okuri);

    // string
    DECLARE_NSStringKey(openlab_host);
    DECLARE_NSStringKey(openlab_path);

    // nsarray<nsstrig *>
    DECLARE_NSStringKey(direct_clients);

    // boolean
    DECLARE_NSStringKey(enable_skkdap);
    // string
    DECLARE_NSStringKey(skkdap_folder);
    // number
    DECLARE_NSStringKey(skkdap_port);
}

namespace SKKDictionarySetKeys {
    DECLARE_NSStringKey(active);
    DECLARE_NSStringKey(type);
    DECLARE_NSStringKey(location);
}

namespace SKKDictionaryTypeKeys {
    DECLARE_NSStringKey(type);
    DECLARE_NSStringKey(name);
}

#undef DECLARE_NSStringKey

namespace SKKFilePaths {
    static NSString* pathForSystemResource() {
        ObjC::RAIIPool pool;
        static NSString* path = @"/Library/Input Methods/AquaSKK.app/Contents/Resources";

        return path;
    }
    
    static NSString* pathForApplicationSupport() {
        ObjC::RAIIPool pool;
        static NSString* path = [[NSString stringWithFormat:@"%@/Library/Application Support/AquaSKK",
                                           NSHomeDirectory()] retain];

        return path;
    }

    static NSString* pathForBlacklistApps() {
        ObjC::RAIIPool pool;
        static NSString* path = [[NSString stringWithFormat:@"%@/BlacklistApps.plist",
                                  pathForApplicationSupport()] retain];

        return path;
    }

    static NSString* pathForDictionarySet() {
        ObjC::RAIIPool pool;
        static NSString* path = [[NSString stringWithFormat:@"%@/DictionarySet.plist",
                                           pathForApplicationSupport()] retain];

        return path;
    }

    static NSString* pathForUserDefaults() {
        ObjC::RAIIPool pool;
        const char* plist = "Library/Preferences/jp.sourceforge.inputmethod.aquaskk.plist";
        static NSString* path = [[NSString stringWithFormat:@"%@/%s",
                                           NSHomeDirectory(), plist] retain];

        return path;
    }

    NSString* SystemResourceFolder = pathForSystemResource();
    NSString* BlacklistApps = pathForBlacklistApps();
    NSString* ApplicationSupportFolder = pathForApplicationSupport();
    NSString* DictionarySet = pathForDictionarySet();
    NSString* UserDefaults = pathForUserDefaults();
}
