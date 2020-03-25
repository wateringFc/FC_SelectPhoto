//
//  CollectionViewCell.m
//  SelectPhoto
//
//  Created by 方存 on 2020/3/25.
//  Copyright © 2020 JKB. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.imgView];
    [self addSubview:self.deleteBut];
}

#pragma mark - lazy
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.contentView.bounds.size.width-5, self.contentView.bounds.size.height - 5)];
    }
    return _imgView;
}

- (UIButton *)deleteBut{
    if (!_deleteBut) {
        _deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBut.frame = CGRectMake(CGRectGetWidth(self.bounds)-20, 0, 20, 20);
        [_deleteBut setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    return _deleteBut;
}

@end
