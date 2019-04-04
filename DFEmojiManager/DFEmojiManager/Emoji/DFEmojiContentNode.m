//
//  DFEmojiContentNode.m
//  AlumniRecord
//
//  emoji的布局是写死的第一个section3行8列 其余的2行4列 如需更改 --> layout和本类中maxRowWithSection：maxCountPerRowWithSection：方法 都需要更改
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFEmojiContentNode.h"
#import "DFEmojiFlowLayout.h"
#import "DFEmojiPreviewView.h"
#import "DFEmojiPreviewImageView.h"

#import <Masonry.h>

#define kMargen 10
#define kimgPreviewkWidthHeight 150

@interface DFEmojiContentNode ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) DFEmojiFlowLayout *layout;
@property (nonatomic, strong) DFEmojiPreviewView *emojiPreview;
@property (nonatomic, strong) DFEmojiPreviewImageView *emojiImagePreview;

@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger currentIndexOfPage;

@property (nonatomic, strong) NSTimer *deleteEmojiTimer;

@end

@implementation DFEmojiContentNode

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.currentIndexOfPage = 0;
        [self prepareLayout];
    }
    return self;
}

- (void)prepareLayout {
    
    DFEmojiFlowLayout *layout = [[DFEmojiFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(0, kMargen, kMargen, kMargen);

    self.layout = layout;
    
    UICollectionView *collectionNode = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150) collectionViewLayout:layout];
    collectionNode.delegate = self;
    collectionNode.dataSource = self;
    collectionNode.pagingEnabled = YES;
    collectionNode.showsHorizontalScrollIndicator = NO;
    collectionNode.showsVerticalScrollIndicator = NO;
    collectionNode.backgroundColor = [UIColor clearColor];
    [collectionNode registerClass:[DFEmojiContentCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionNode;
    [self addSubview:self.collectionView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.2;
    
    [self.collectionView addGestureRecognizer:longPress];
    
}

- (void)setDelegate:(id<EmojiContentDelegate>)delegate {
    _delegate = delegate;
    //返回默认
    NSInteger pageCount = 0;
    if ([self.delegate respondsToSelector:@selector(allItemOfEmojiContentForClassesIndex:)]) {
        NSInteger count = [self.delegate allItemOfEmojiContentForClassesIndex:0].count;
        //全填充
        NSInteger maxRow = [self maxRowWithSection:0];
        NSInteger maxCountPerRow = [self maxCountPerRowWithSection:0];
        
        pageCount = (count + ((maxRow*maxCountPerRow) - (count % (maxRow*maxCountPerRow))))/(maxRow*maxCountPerRow);
    }

    if ([self.delegate respondsToSelector:@selector(currentSectionOfEmojiContent:)]) {
        [self.delegate currentSectionOfEmojiContent:0];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
        [self.delegate currentPageOfEmojiContent:0];
    }
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        [self.delegate pageCountOfEmojiContent:pageCount];
    }
}
//每个section对应的行数
- (NSInteger)maxRowWithSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 2;
    }
}
//每个section对应的每行的个数
- (NSInteger)maxCountPerRowWithSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }else {
        return 4;
    }
}
#pragma mark -  ----------CollectionView--delegate----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger maxRow = [self maxRowWithSection:section];
    NSInteger maxCountPerRow = [self maxCountPerRowWithSection:section];
    
    if ([self.delegate respondsToSelector:@selector(allItemOfEmojiContentForClassesIndex:)]) {
        NSInteger count = [self.delegate allItemOfEmojiContentForClassesIndex:section].count;
        
        //全填充 要不然layout布局有问题
        NSInteger newCount = count + (maxRow*maxCountPerRow - (count % (maxRow*maxCountPerRow)));
        return newCount;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DFEmojiContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    NSArray<DFEmojiModel *> *allItemArr = [self.delegate allItemOfEmojiContentForClassesIndex:indexPath.section];
    
    if (indexPath.row + 1 <= allItemArr.count) {
        
        DFEmojiModel *model = [allItemArr objectAtIndex:indexPath.item];
        
        NSString *path = kBundlePathImage(@"Emojis", @"bundle", model.emojiName, @"png");
        [cell.imageView setImage:[UIImage imageWithContentsOfFile:path]];
        cell.detailL.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.emojiDescription] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        
        if (indexPath.section == 0) {
            [cell.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(30);
                make.center.equalTo(cell.contentView);
            }];
            [cell.detailL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(cell.contentView);
                make.top.equalTo(cell.imageView.mas_bottom);
            }];
            cell.detailL.hidden = YES;
            
        }else {
            [cell.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo((KScreenWidth) / 4 - 40);
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.centerY.equalTo(cell.contentView.mas_centerY).offset(-10);
            }];
            [cell.detailL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(cell.contentView);
                make.top.equalTo(cell.imageView.mas_bottom);
            }];
            cell.detailL.hidden = NO;
        }
        
    }else {
        //第一个section最后一个显示删除
        NSInteger count = [self maxCountPerRowWithSection:0] * [self maxRowWithSection:0];
        if (indexPath.section == 0 && allItemArr.count%count > 0 && indexPath.item == count*(ceilf((CGFloat)allItemArr.count/count)) - 1) {
            NSString *path = kBundlePathImage(@"Emojis", @"bundle", @"delete-emoji", @"png");
            [cell.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            cell.detailL.text = @"";
            [cell.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(30);
                make.center.equalTo(cell.contentView);
            }];
        }else {
            cell.imageView.image = nil;
            cell.detailL.attributedText = nil;
        }
    }
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DFEmojiContentCell *cell = (DFEmojiContentCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.imageView.image) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithIndexPath: andImg: desc: path: isDelete:)]) {
            BOOL isDelete = NO;
            NSString *path = nil;
            NSInteger maxRow = [self maxRowWithSection:indexPath.section];
            NSInteger maxCountPerRow = [self maxCountPerRowWithSection:indexPath.section];

            if ((indexPath.item + 1) %(maxRow * maxCountPerRow) == 0 && indexPath.item != 0 && indexPath.section == 0) {
                isDelete = YES;
            }else {
                DFEmojiModel *model = [[self.delegate allItemOfEmojiContentForClassesIndex:indexPath.section] objectAtIndex:indexPath.item];
                
                path = kBundlePathImage(@"Emojis", @"bundle", model.emojiName, @"png");
            }
            [self.delegate didSelectWithIndexPath:indexPath andImg:cell.imageView.image desc:cell.detailL.text path:path isDelete:isDelete];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger maxRow = [self maxRowWithSection:indexPath.section];
    NSInteger maxCountPerRow = [self maxCountPerRowWithSection:indexPath.section];
    
    return CGSizeMake((KScreenWidth)/maxCountPerRow, 150/maxRow);
}

- (void)scrollToSection:(NSInteger)section {
    
    NSInteger pageCount = 0;
    NSInteger offset = 0;
    self.currentIndexOfPage = 0;
    NSInteger maxRow = 0;
    NSInteger maxCountPerRow = 0;
    
    for (int i = 0; i < section; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        maxCountPerRow = [self maxCountPerRowWithSection:i];
        maxRow = [self maxRowWithSection:i];
        
        pageCount = itemCount/(maxRow*maxCountPerRow);
        
        offset += pageCount * (KScreenWidth);
    }
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        maxCountPerRow = [self maxCountPerRowWithSection:section];
        maxRow = [self maxRowWithSection:section];

        pageCount = itemCount/(maxRow*maxCountPerRow);

        [self.delegate pageCountOfEmojiContent:pageCount];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
        [self.delegate currentPageOfEmojiContent:0];
    }
}

- (void)scrollToItem:(NSInteger)item {
    
    NSInteger kwidth = KScreenWidth;

    NSInteger offPage = item - self.currentIndexOfPage;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + offPage*kwidth, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint point = scrollView.contentOffset;
    
    NSInteger pageCount = 0;
    NSInteger currentPage = 0;
    NSInteger currentSection = 0;
    NSInteger offset = point.x;
    
    NSInteger maxRow = 0;
    NSInteger maxCountPerRow = 0;
    
    NSInteger kwidth = KScreenWidth;
    
    for (int i = 0; i < self.sectionCount; i++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        maxCountPerRow = [self maxCountPerRowWithSection:i];
        maxRow = [self maxRowWithSection:i];
        
        pageCount = itemCount/(maxRow*maxCountPerRow);

        if (pageCount * kwidth > offset) {
            
            currentPage = (NSInteger)(offset/kwidth)%pageCount;
            self.currentIndexOfPage = currentPage;
            currentSection = i;
            break;
        }else {
            offset = offset - (pageCount*kwidth);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(currentSectionOfEmojiContent:)]) {
        [self.delegate currentSectionOfEmojiContent:currentSection];
    }
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        [self.delegate pageCountOfEmojiContent:pageCount];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
       
        [self.delegate currentPageOfEmojiContent:currentPage];
    }
}

#pragma mark -  ----------长按手势方法----------
- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self.collectionView];
    
    NSIndexPath *indexP = [self.collectionView indexPathForItemAtPoint:touchPoint];
    
    DFEmojiContentCell *cell = (DFEmojiContentCell *)[self.collectionView cellForItemAtIndexPath:indexP];
    if (indexP.section == 0 && (indexP.item + 1) %24 == 0 && indexP.item != 0) {
        if (self.emojiPreview.superview) {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
        if (sender.state == UIGestureRecognizerStateBegan) {
            
            if (self.deleteEmojiTimer) {
                [self.deleteEmojiTimer invalidate];
                self.deleteEmojiTimer = nil;
            }
            
            self.deleteEmojiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delegateDeleteEmoji) userInfo:nil repeats:YES];
        
        }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {

            if (self.deleteEmojiTimer) {
                [self.deleteEmojiTimer invalidate];
                self.deleteEmojiTimer = nil;
            }
        
            if ([self.delegate respondsToSelector:@selector(emojiDeleteBtnClick)]) {
                [self.delegate emojiDeleteBtnClick];
            }
        }else {
            //从别的emoji长按滑动回来 会进这里 如果需要执行删除 把began里代码copy过来即可
        }
        return;
    }
    
    //滑动后 是没释放的
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
    
    CGRect rect = [cell convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    //section = 0 显示emoji预览 别的显示img预览
    if (indexP) {
        if (indexP.section == 0) {
            [self showEmojiPreviewWith:rect gesture:sender cell:cell];
        }else {
            [self showImgPreviewWith:rect gesture:sender cell:cell];
        }
    }else {
        //防止手势区域滑出 获取到indexP为null 视图不会消失
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
        self.emojiPreview.frame = CGRectZero;
        self.emojiPreview.emojiImageView.image = nil;
        self.emojiPreview.descriptionLabel.text = @"";
        [self.emojiPreview removeFromSuperview];
    }
   
    
}

#pragma mark -  ----------emoji的长按展示----------
- (void)showEmojiPreviewWith:(CGRect)rect gesture:(UILongPressGestureRecognizer *)sender cell:(DFEmojiContentCell *)cell {
    
    if (self.emojiImagePreview.superview) {
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (cell.imageView.image) {
            self.emojiPreview.emojiImageView.image = cell.imageView.image;
            self.emojiPreview.descriptionLabel.text = cell.detailL.text;
            self.emojiPreview.frame = CGRectZero;
            if (!self.emojiPreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiPreview];
            }
            self.emojiPreview.frame = CGRectMake(rect.origin.x - 90/2.0 + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0 - 140, 90, 140);
        }else {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        if (cell.imageView.image) {
            if (!self.emojiPreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiPreview];
            }
            self.emojiPreview.frame = CGRectMake(rect.origin.x - 90/2.0 + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0 - 140, 90, 140);
            self.emojiPreview.emojiImageView.image = cell.imageView.image;
            self.emojiPreview.descriptionLabel.text = cell.detailL.text;
        }else {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
    }else {
        self.emojiPreview.frame = CGRectZero;
        self.emojiPreview.emojiImageView.image = nil;
        self.emojiPreview.descriptionLabel.text = @"";
        [self.emojiPreview removeFromSuperview];
    }
}
#pragma mark -  ----------img的长按展示----------
- (void)showImgPreviewWith:(CGRect)rect gesture:(UILongPressGestureRecognizer *)sender cell:(DFEmojiContentCell *)cell {
 
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (cell.imageView.image) {
            self.emojiImagePreview.emojiImageView.image = cell.imageView.image;
            self.emojiImagePreview.descriptionLabel.text = cell.detailL.text;
            self.emojiImagePreview.frame = CGRectZero;
            if (!self.emojiImagePreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiImagePreview];
            }

            CGFloat originX = rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0;
            if (originX + kimgPreviewkWidthHeight > KScreenWidth) {
                originX = KScreenWidth - kimgPreviewkWidthHeight - 10;
            }
            if (rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0 < 10) {
                originX = 10;
            }
            
            self.emojiImagePreview.frame = CGRectMake(originX, rect.origin.y - kimgPreviewkWidthHeight, kimgPreviewkWidthHeight, kimgPreviewkWidthHeight);
            
            self.emojiImagePreview.sharpPoint = CGPointMake((rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0) + kimgPreviewkWidthHeight/2, rect.origin.y);
            [self.emojiImagePreview setNeedsDisplay];

        }else {
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.emojiImageView.image = nil;
            self.emojiImagePreview.descriptionLabel.text = @"";
            [self.emojiImagePreview removeFromSuperview];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        if (cell.imageView.image) {
            if (!self.emojiImagePreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiImagePreview];
            }
            self.emojiImagePreview.emojiImageView.image = cell.imageView.image;
            self.emojiImagePreview.descriptionLabel.text = cell.detailL.text;
            
            CGFloat originX = rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0;
            if (originX + kimgPreviewkWidthHeight > KScreenWidth) {
                originX = KScreenWidth - kimgPreviewkWidthHeight - 10;
            }
            if (rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0 < 10) {
                originX = 10;
            }
            
            self.emojiImagePreview.frame = CGRectMake(originX, rect.origin.y - kimgPreviewkWidthHeight, kimgPreviewkWidthHeight, kimgPreviewkWidthHeight);
            
            self.emojiImagePreview.sharpPoint = CGPointMake((rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0) + kimgPreviewkWidthHeight/2, rect.origin.y);
            [self.emojiImagePreview setNeedsDisplay];
        }else {
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.emojiImageView.image = nil;
            self.emojiImagePreview.descriptionLabel.text = @"";
            [self.emojiImagePreview removeFromSuperview];
        }
    }else {
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
    }
}

#pragma mark -  ----------删除emoji 代理----------
- (void)delegateDeleteEmoji {
    if ([self.delegate respondsToSelector:@selector(emojiDeleteBtnClick)]) {
        [self.delegate emojiDeleteBtnClick];
    }
}
#pragma mark -  ----------lazyLoading----------
- (NSInteger)sectionCount {
    if (!_sectionCount) {
        if ([self.delegate respondsToSelector:@selector(allClassesOfEmojiContent)]) {
            _sectionCount = [self.delegate allClassesOfEmojiContent];
        }else {
            _sectionCount = 1;
        }
    }
    return _sectionCount;
}

- (DFEmojiPreviewView *)emojiPreview {
    if (!_emojiPreview) {
        _emojiPreview = [[DFEmojiPreviewView alloc] init];
    }
    return _emojiPreview;
}

- (DFEmojiPreviewImageView *)emojiImagePreview {
    if (!_emojiImagePreview) {
        _emojiImagePreview = [[DFEmojiPreviewImageView alloc] init];
    }
    return _emojiImagePreview;
}

@end

@implementation DFEmojiContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.center.equalTo(self.contentView);
        }];
        self.detailL = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.detailL];
        self.detailL.textAlignment = NSTextAlignmentCenter;
        [self.detailL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imageView.mas_bottom);
        }];
    }
    return self;
}

@end
