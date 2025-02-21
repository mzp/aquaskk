//
//  SKKLocalDictionaryLoader.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import Foundation
import Combine

/*
 std::time_t lastupdate_;
 std::string path_;

 virtual bool NeedsUpdate() {
     struct stat st;

     if(stat(path_.c_str(), &st) == 0 && lastupdate_ < st.st_mtime) {
         lastupdate_ = st.st_mtime;
         return true;
     }

     return false;
 }

 virtual const std::string &FilePath() const {
     return path_;
 }

public:
 SKKLocalDictionaryLoader()
     : lastupdate_(0) {}

 virtual void Initialize(const std::string &location) {
     path_ = location;
 }

 virtual int Interval() const {
     return 60;
 }

 virtual int Timeout() const {
     return 1;
 }
 */
