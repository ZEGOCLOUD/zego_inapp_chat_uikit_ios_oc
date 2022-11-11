//
//  ZIMKitChatBarMoreView.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitChatBarMoreView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

#define ZIMKitMoreRowCount 4

@interface ZIMKitMoreListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^tapItemBlock)(NSIndexPath *indexPath);
@end

@implementation ZIMKitMoreListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.contentView addGestureRecognizer:tap];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.layer.cornerRadius = 12;
        self.bgView.layer.masksToBounds = true;
        self.bgView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.width.height.equalTo(@(58.0));
            make.top.mas_equalTo(self.mas_top).offset(8.0);
        }];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.centerY.equalTo(self.bgView.mas_centerY).offset(0);
            make.width.height.equalTo(@34);
        }];
        
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:11];
        self.label.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x707274) lightColor:ZIMKitHexColor(0x707274)];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.top.equalTo(self.bgView.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)filldata:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)tap:(UITapGestureRecognizer *)t {
    if (self.tapItemBlock) {
        self.tapItemBlock(self.indexPath);
    }
}
@end

@interface ZIMKitChatBarMoreView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ZIMKitChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self initData];
    }
    return self;
}


- (void)initUI {
    self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];
    
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[ZIMKitMoreListCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-Bottom_SafeHeight);
    }];
    if (Bottom_SafeHeight) {
        UIView *view = [[UIView alloc ] init];
        view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.top.mas_equalTo(self.collectionView.mas_bottom);
        }];
    }
}

- (void)initData {
    self.data = @[
                  @{@"icon": @"chat_face_photoIcon", @"title": [NSBundle ZIMKitlocalizedStringForKey:@"message_album"]},
                  @{@"icon": @"chat_face_fileIcon", @"title": [NSBundle ZIMKitlocalizedStringForKey:@"message_file"]}
                  ].mutableCopy;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMoreListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if ([self.data[indexPath.row][@"icon"] length] == 0) {
        cell.imageView.hidden = YES;
        cell.label.hidden = YES;
    } else {
        cell.imageView.hidden = NO;
        cell.label.hidden = NO;
        cell.imageView.image = [UIImage zegoImageNamed:self.data[indexPath.row][@"icon"]];
        cell.imageView.highlightedImage = [UIImage zegoImageNamed:self.data[indexPath.row][@"icon"]];
        cell.label.text = self.data[indexPath.row][@"title"];
    }
    [cell filldata:indexPath];
    @weakify(self);
    cell.tapItemBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMoreViewItemAction:)]) {
            ZIMKitFunctionType type = ZIMKitFunctionTypePhoto;
            if (indexPath.item == 0) {
                type = ZIMKitFunctionTypePhoto;
            } else if (indexPath.item == 1) {
                type = ZIMKitFunctionTypeFile;
            }
            
            [self.delegate didSelectedMoreViewItemAction:type];
            
        }
    };
    
    return cell;
}

#pragma mark - getter/setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 30; //水平间距
        layout.minimumInteritemSpacing = 16;

        CGFloat spec = 30;
        CGFloat width = (Screen_Width - (ZIMKitMoreRowCount +1)*spec)/ZIMKitMoreRowCount;
        layout.itemSize = CGSizeMake(width, 91);
        layout.sectionInset = UIEdgeInsetsMake(0, spec, 0, spec);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF6F6F6) lightColor:ZIMKitHexColor(0xF6F6F6)];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    
    return _collectionView;
}

@end

