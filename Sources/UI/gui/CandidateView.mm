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

#import <AquaSKKUI/CandidateCell.h>
#import <AquaSKKUI/CandidatePageIndicator.h>
#import <AquaSKKUI/CandidateView.h>

@implementation CandidateView

+ (unsigned)cellSpacing {
    return 4;
}

- (id)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        candidateCells_ = [[NSMutableArray alloc] initWithCapacity:0];
        indicator_ = [[CandidatePageIndicator alloc] init];
        cellFont_ = 0;
        labels_ = @"";
    }

    return self;
}

- (void)dealloc {
    [candidateCells_ release];
    [indicator_ release];
    if(cellFont_)
        [cellFont_ release];

    [super dealloc];
}

- (void)drawRect:(NSRect)rect {
    int margin = [CandidateView cellSpacing];

    NSPoint offset = NSMakePoint(margin, margin);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    int cellCount = [labels_ length];
#pragma clang diagnostic pop
    for(unsigned index = 0; index < [candidateCells_ count]; ++index) {
        CandidateCell *cell = [candidateCells_ objectAtIndex:index];
        NSSize maxSize = [cell size];

        maxSize.width = [cell defaultSize].width * cellCount + [CandidateView cellSpacing] * (cellCount - 1);

        if([cell size].width < maxSize.width) {
            [cell drawAtPoint:offset withFocus:(index == selected_)];
        } else {
            [cell drawAtPoint:offset withSize:maxSize];
        }

        offset.x += ([cell size].width + margin);
    }

    [indicator_ drawAtPoint:NSMakePoint([self bounds].size.width - [indicator_ size].width - margin, margin)];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[NSColor windowFrameColor] set];
#pragma clang diagnostic pop
    NSFrameRect([self frame]);
}

- (void)prepareWithFont:(NSFont *)newFont labels:(NSString *)newLabels {
    [newFont retain];

    if(cellFont_)
        [cellFont_ release];
    cellFont_ = newFont;

    labels_ = newLabels;
}

- (NSSize)contentSize {
    NSSize result;

    CandidateCell *cell = [self newCandidateCell];

    result.width = ([cell defaultSize].width + [CandidateView cellSpacing]) * [labels_ length];
    result.width += [indicator_ size].width;
    result.height = [cell defaultSize].height;

    result.width += [CandidateView cellSpacing] * 2;
    result.height += [CandidateView cellSpacing] * 2;

    [cell release];

    return result;
}

- (void)setCandidates:(NSArray *)candidates selectedIndex:(int)cursor {
    [candidateCells_ removeAllObjects];

    for(unsigned index = 0; index < [candidates count]; ++index) {
        CandidateCell *tmp = [self newCandidateCell];

        [tmp setString:[candidates objectAtIndex:index] withLabel:[labels_ characterAtIndex:index]];
        [candidateCells_ addObject:tmp];
        [tmp release];
    }

    selected_ = cursor;

    [self setNeedsDisplay:YES];
}

- (void)setPage:(NSRange)page {
    [indicator_ setPage:page];

    [self setNeedsDisplay:YES];
}

- (id)newCandidateCell {
    return [[CandidateCell alloc] initWithFont:cellFont_];
}

@end
