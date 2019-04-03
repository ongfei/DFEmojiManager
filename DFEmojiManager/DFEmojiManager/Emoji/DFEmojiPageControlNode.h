//
//  DFEmojiPageControlNode.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EmojiPageControlDelegate <NSObject>

- (void)emojiPageControlSelectIndex:(NSInteger)index;

@end
@interface DFEmojiPageControlNode : DFBaseView

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) id<EmojiPageControlDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
