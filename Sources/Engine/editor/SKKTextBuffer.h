/* -*- C++ -*-

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

// このファイルをAquaSKKEngineの公開ヘッダにすると
//
// /Users/mzp/ghq/github.com/mzp/aquaskk/Sources/Backend/utility/SwiftObject.h:12:7: error: field has incomplete type
// 'AquaSKKEngine::SKKTextBufferImpl'
//    T impl_;
//       ^
// /Users/mzp/ghq/github.com/mzp/aquaskk/Sources/Backend/utility/SwiftObject.h:11:26: note: in instantiation of template
// class 'SwiftObject<AquaSKKEngine::SKKTextBufferImpl>' requested here template <class T> class SwiftObject {
//                          ^
// /Users/mzp/ghq/github.com/mzp/aquaskk/Sources/Engine/editor/SKKTextBuffer.h:30:11: note: forward declaration of
// 'AquaSKKEngine::SKKTextBufferImpl'
//    class SKKTextBufferImpl;
//          ^
// というエラーが出る。
//
// 幸い、外部から使う必要はないので公開範囲をプロジェクトレベルにする。

#ifndef SKKTextBuffer_h
#define SKKTextBuffer_h

#include <string>
#import <AquaSKKBackend/SwiftObject.h>

namespace AquaSKKEngine {
    class SKKTextBufferImpl;
}

/// カーソル移動をサポートするテキストバッファ
class SKKTextBuffer {
    SwiftObject<AquaSKKEngine::SKKTextBufferImpl> *impl_;

public:
    SKKTextBuffer();
    ~SKKTextBuffer();

    void Insert(const std::string &str);
    void BackSpace();
    void Delete();
    void Clear();

    void CursorLeft();
    void CursorRight();
    void CursorUp();
    void CursorDown();

    int CursorPosition() const;

    bool IsEmpty() const;

    bool operator==(const std::string &str) const;

    std::string String() const;
    std::string LeftString() const;
    std::string RightString() const;
};

#endif
