//
//  DFEmojiContentNode.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFBaseView.h"
#import "DFEmojiManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EmojiContentDelegate <NSObject>
@required
/**
 总共有几种表情包
 */
- (NSInteger)allClassesOfEmojiContent;
//当前index表情包所有元素
- (NSArray<DFEmojiModel *> *)allItemOfEmojiContentForClassesIndex:(NSInteger)ClassesIndex;

@optional
- (void)currentSectionOfEmojiContent:(NSInteger)section;
- (void)currentPageOfEmojiContent:(NSInteger)page;
- (void)pageCountOfEmojiContent:(NSInteger)count;
- (void)emojiDeleteBtnClick;
- (void)didSelectWithIndexPath:(NSIndexPath *)indexP andImg:(UIImage *)img desc:(NSString *)desc path:(NSString *)path isDelete:(BOOL)isDelete;
@end

@interface DFEmojiContentNode : DFBaseView

@property (nonatomic, weak) id<EmojiContentDelegate> delegate;

- (void)scrollToSection:(NSInteger)section;
- (void)scrollToItem:(NSInteger)item;


@end

@interface DFEmojiContentCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *detailL;

@end

NS_ASSUME_NONNULL_END
