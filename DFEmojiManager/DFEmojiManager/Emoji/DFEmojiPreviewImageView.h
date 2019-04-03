//
//  DFEmojiPreviewImageView.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/27.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFBaseView.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFEmojiPreviewImageView : DFBaseView

@property (nonatomic, assign) CGPoint sharpPoint;
@property (nonatomic, strong) UIImageView *emojiImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;


@end

NS_ASSUME_NONNULL_END
