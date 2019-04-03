//
//  DFChatInputMenuBarEmojiView.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/14.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFChatInputMenuBarEmojiView : DFBaseView

@property (nonatomic, copy) void(^EmojiDeleteBlock)(void);
@property (nonatomic, copy) void(^EmojiSelectBlock)(NSInteger section,NSString *desc,NSString *path , UIImage *img);

@end

NS_ASSUME_NONNULL_END
