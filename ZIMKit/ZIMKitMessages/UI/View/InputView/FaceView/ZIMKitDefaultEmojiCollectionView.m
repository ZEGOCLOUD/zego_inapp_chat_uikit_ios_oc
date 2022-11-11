//
//  ZIMKitDefaultEmojiCollectionView.m
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import "ZIMKitDefaultEmojiCollectionView.h"
#import "ZIMKitEmojiItemCell.h"
#import "ZIMKitDefine.h"

#import <Masonry/Masonry.h>

#define ZIMKitEmojiRowCount 7

@interface ZIMKitDefaultEmojiDelView : UIView

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, copy) void (^deleteBlock) (void);

@end

@implementation ZIMKitDefaultEmojiDelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _alphaView = [[UIView alloc] init];
    _alphaView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];
    _alphaView.alpha = 0.95;
    [self addSubview:_alphaView];
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _whiteView = [[UIView alloc] init];
    _whiteView.layer.cornerRadius = 4.0;
    _whiteView.layer.masksToBounds = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delAction:)];
    [_whiteView addGestureRecognizer:tap];
    _whiteView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    [self addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(35);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.top.mas_equalTo(self.mas_top).offset(28);
    }];
    
    _icon = [[UIImageView alloc] init];
    _icon.userInteractionEnabled = true;
    _icon.image = [UIImage zegoImageNamed:@"chat_face_delIcon"];
    [_whiteView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView.mas_centerX);
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
}

- (void)delAction:(UITapGestureRecognizer *)tap {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

@interface ZIMKitDefaultEmojiCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) ZIMKitDefaultEmojiDelView *delView;
@property (strong, nonatomic) NSArray *emojiList;

@end

@implementation ZIMKitDefaultEmojiCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.delView];
        [self.delView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.width.mas_equalTo(105);
            make.height.mas_equalTo(98);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    
}

- (ZIMKitDefaultEmojiDelView *)delView {
    if (!_delView) {
        _delView = [[ZIMKitDefaultEmojiDelView alloc] init];
        @weakify(self);
        _delView.deleteBlock = ^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteItemAction)]) {
                [self.delegate deleteItemAction];
            }
        };
    }
    return _delView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = ({
            UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            collectionViewFlowLayout.minimumLineSpacing = 10;
            collectionViewFlowLayout.minimumInteritemSpacing = 15;
            CGFloat spec = 15;
            CGFloat width = (Screen_Width - (ZIMKitEmojiRowCount +1)*spec)/ZIMKitEmojiRowCount;
            collectionViewFlowLayout.itemSize = CGSizeMake(width, width);
            collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, spec, 0, spec);
            collectionViewFlowLayout;
        });
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(16, 0, 16*2+15, 0);
        _collectionView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:ZIMKitEmojiItemCell.class forCellWithReuseIdentifier:@"ZIMKitEmojiItemCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emojiList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZIMKitEmojiItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZIMKitEmojiItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSString *text = self.emojiList[indexPath.item];
    @weakify(self);
    cell.tapEmoji = ^(NSString * _Nonnull emo) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItem:)]) {
            [self.delegate didSelectItem:emo];
        }
    };
    [cell filldata:text];
    return cell;
}

- (NSArray *)emojiList {
    if (!_emojiList) {
        _emojiList = @[@"😀", @"😃", @"😄", @"😁", @"😆", @"😅", @"😂",
                       @"😇", @"😉", @"😊", @"😋", @"😌", @"😍", @"😘",
                       @"😗", @"😙", @"😚", @"😜", @"😝", @"😛", @"😎",
                       @"😏", @"😶", @"😐", @"😑", @"😒", @"😳", @"😞",
                       @"😟", @"😤", @"😠", @"😡", @"😔", @"😕", @"😬",
                       @"😣", @"😖", @"😫", @"😩", @"😪", @"😮", @"😱",
                       @"😨", @"😰", @"😥", @"😓", @"😯", @"😦", @"😧",
                       @"😢", @"😭", @"😵", @"😲", @"😷", @"😴", @"💤",
                       @"😈", @"👿", @"👹", @"👺", @"💩", @"👻", @"💀",
                       @"👽", @"🎃", @"😺", @"😸", @"😹", @"😻", @"😼",
                       @"😽", @"🙀", @"😿", @"😾", @"👐", @"🙌", @"👏",
                       @"🙏", @"👍", @"👎", @"👊", @"✊", @"👌", @"👈",
                       @"👉", @"👆", @"👇", @"✋", @"👋", @"💪", @"💅",
                       @"👄", @"👅", @"👂", @"👃", @"👀", @"👶", @"👧",
                       @"👦", @"👩", @"👨", @"👱", @"👵", @"👴", @"👲",
                       @"👳‍", @"👼", @"👸", @"👰", @"🙇", @"💁", @"🙅‍",
                       @"🙆", @"🙋", @"🙎", @"🙍", @"💇", @"💆", @"💃",
                       @"👫", @"👭", @"👬", @"💛", @"💚", @"💙", @"💜",
                       @"💔", @"💕", @"💞", @"💓", @"💗", @"💖", @"💘",
                       @"💝", @"💟"];
    }
    return _emojiList;
}
@end
