//
//  DFEmojiClassesBarNode.h
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DFEmojiClassesBarDelegate <NSObject>
@required
- (NSArray<NSString *> *)arrayForEmojiClassesBar;
@optional
- (void)didselectWithIndex:(NSInteger)index;
@end

@interface DFEmojiClassesBarNode : DFBaseView

@property (nonatomic, weak) id<DFEmojiClassesBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
