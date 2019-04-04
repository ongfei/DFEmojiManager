//
//  DFEmojiManager.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class DFEmojiPlist;
NS_ASSUME_NONNULL_BEGIN

@interface DFEmojiManager : NSObject

+ (instancetype)shareInstance;


@property (nonatomic, strong, readonly) NSArray<DFEmojiPlist *> *allEmojis;

- (NSString *)emojiPathWithEmojiDescription:(NSString *)emojiDescription;

@end

@interface DFEmojiModel : NSObject

@property (nonatomic, strong) NSString *emojiName;
@property (nonatomic, strong) NSString *emojiDescription;

@end

@interface DFEmojiPlist : NSObject

@property (nonatomic, strong) NSString *classes;
@property (nonatomic, strong) NSArray<DFEmojiModel *> *emojis;

@end



NS_ASSUME_NONNULL_END
