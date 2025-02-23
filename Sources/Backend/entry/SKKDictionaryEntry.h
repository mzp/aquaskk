//
//  SKKDictionaryEntry.h
//  AquaSKK
//
//  Created by mzp on 2025/02/22.
//

#ifndef SKKDictionaryEntry_h
#define SKKDictionaryEntry_h

#ifndef SKKDicitonaryEntry_h
#define SKKDictionaryEntry_h

#include <deque>
#include <string>

// 「見出し語」と「変換候補」のペア(変換候補は分解する前の状態)
typedef std::pair<std::string, std::string> SKKDictionaryEntry;

// エントリのコンテナ
typedef std::deque<SKKDictionaryEntry> SKKDictionaryEntryContainer;
typedef SKKDictionaryEntryContainer::iterator SKKDictionaryEntryIterator;


#endif /* SKKDictionaryEntry_h */
