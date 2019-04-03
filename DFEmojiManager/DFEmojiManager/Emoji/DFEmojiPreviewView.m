//
//  DFEmojiPreviewView.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//


#import "DFEmojiPreviewView.h"
#import <YYKit.h>
#import <Masonry.h>


static CGFloat DFEmojiPreviewImageTopPadding = 18.0;
static CGFloat DFEmojiPreviewImageLeftRightPadding = 22.0;
static CGFloat DFEmojiPreviewImageLength = 48.0;
static CGFloat DFEmojiPreviewImageBottomMargin = 2.0;

@implementation DFEmojiPreviewView

- (instancetype)init {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"emoji-preview-bg"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.emojiImageView.frame = CGRectMake(DFEmojiPreviewImageLeftRightPadding, DFEmojiPreviewImageTopPadding, DFEmojiPreviewImageLength, DFEmojiPreviewImageLength);
    self.descriptionLabel.frame = CGRectMake(10,CGRectGetMaxY(self.emojiImageView.frame) + DFEmojiPreviewImageBottomMargin, self.frame.size.width - 20, 20);
}

- (UIImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
        [self addSubview:_emojiImageView];
    }
    return _emojiImageView;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        [self addSubview:_descriptionLabel];
        _descriptionLabel.font = [UIFont systemFontOfSize:11.0];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel;
}

@end
