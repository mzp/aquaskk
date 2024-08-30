//
//  MockFrontEnd.cpp
//  AquaSKKTesting
//
//  Created by mzp on 8/30/24.
//

#include "MockFrontEnd.h"

void MockFrontEnd::InsertString(const std::string &str) {
    result_.fixed += str;
}

void MockFrontEnd::ComposeString(const std::string &str, int cursorOffset) {
    result_.marked = str;
    result_.pos = cursorOffset;
}

void MockFrontEnd::ComposeString(const std::string &str, int convertFrom, int convertTo) {
    result_.marked = str;
    result_.pos = 0;
}

std::string MockFrontEnd::SelectedString() {
    return selected_string_;
}

void MockFrontEnd::SelectInputMode(SKKInputMode mode) {
    result_.mode = mode;
}

void MockFrontEnd::SKKWidgetShow() {}
void MockFrontEnd::SKKWidgetHide() {}

void MockFrontEnd::SetSelectedString(const std::string &str) {
    selected_string_ = str;
}

MockFrontEnd::operator TestResult &() {
    return result_;
}
