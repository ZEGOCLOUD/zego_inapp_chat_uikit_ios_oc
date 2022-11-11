//
//  ZIMKitFaceManagerView.m
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import "ZIMKitFaceManagerView.h"
#import "ZIMKitDefaultEmojiCollectionView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

@interface ZIMKitFaceManagerView ()<UICollectionViewDelegate, UICollectionViewDataSource, ZIMKitDefaultEmojiCollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *homeCollectionView;

@end

@implementation ZIMKitFaceManagerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.homeCollectionView];
    [self.homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (UICollectionView *)homeCollectionView
{
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(Screen_Width, self.bounds.size.height);
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _homeCollectionView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];
        _homeCollectionView.delegate = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.showsHorizontalScrollIndicator = NO;
        _homeCollectionView.bounces = YES;
        _homeCollectionView.pagingEnabled = YES;
        [_homeCollectionView registerClass:ZIMKitDefaultEmojiCollectionView.class forCellWithReuseIdentifier:@"ZIMKitDefaultEmojiCollectionView"];
    }
    return _homeCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZIMKitDefaultEmojiCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZIMKitDefaultEmojiCollectionView" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark ZIMKitDefaultEmojiCollectionViewDelegate
- (void)didSelectItem:(NSString *_Nullable)emojiString {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:emojiString];
    }
}

- (void)deleteItemAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteInputItemAction)]) {
        [self.delegate deleteInputItemAction];
    }
}

@end
