//
//  PALabelsFormView.m
//  haofang
//
//  Created by leo on 15/1/20.
//  Copyright (c) 2015年 平安好房. All rights reserved.
//

#import "LELabelsFormView.h"
#import "PADefaultFormView.h"

#define ACCESSORY_STR PAICONFONT_E61F
#define DEFAULT_TEXT_COLOR [UIColor colorWithWhite:88.0/255.0 alpha:1.0]
#define DEFAULT_TEXT_FONT [UIFont systemFontOfSize:14.0]

@implementation LELabelsFormModel

- (NSString *)description
{
    NSString *objectStr = [super description];
    return [NSString stringWithFormat:@"%@ {%@, %@}", objectStr, self.content, self.suffixContent];
}

@end

@implementation LELabelsFormView

- (void)initView
{
    [super initView];
    // TODO: initialize
    _titleLabel = [[UILabel alloc] init];
    _contentLabel = [[UILabel alloc] init];
    _suffixLabel = [[UILabel alloc] init];
    
    // TODO: configure
    self.backgroundColor = [UIColor whiteColor];
    
    _inPadding = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = DEFAULT_TEXT_FONT;
    _titleLabel.textColor = DEFAULT_TEXT_COLOR;
    
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = DEFAULT_TEXT_FONT;
    _contentLabel.textColor = DEFAULT_TEXT_COLOR;
    
    _suffixLabel.backgroundColor = [UIColor clearColor];
    _suffixLabel.font = DEFAULT_TEXT_FONT;
    _suffixLabel.textColor = DEFAULT_TEXT_COLOR;
    
    // TODO: add subviews
    [self addSubview:_titleLabel];
    [self addSubview:_contentLabel];
    [self addSubview:_suffixLabel];
    
    // TODO: add constriants
}

- (void)update
{
    _titleLabel.text = self.fieldItem.title;
    LELabelsFormModel *model = validValueChanger(self.fieldItem, [LELabelsFormModel class]);
    if ([model isKindOfClass:[LELabelsFormModel class]]) {
        if (model.attrContent != nil) {
            self.contentLabel.attributedText = model.attrContent;
        } else {
            self.contentLabel.text = model.content;
        }
        if (model.attrSuffixContent != nil) {
            self.suffixLabel.attributedText = model.attrSuffixContent;
        } else {
            self.suffixLabel.text = model.suffixContent;
        }
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, _inPadding);
    CGFloat height = CGRectGetHeight(frame);
    [_titleLabel sizeToFit];
    [_contentLabel sizeToFit];
    [_suffixLabel sizeToFit];
    
    _titleLabel.height = height;
    _contentLabel.height = height;
    _suffixLabel.height = height;
    
    _titleLabel.origin = frame.origin;
    _contentLabel.origin = CGPointMake(_titleLabel.right, CGRectGetMinY(frame));
    CGFloat contentAllowWidth = CGRectGetWidth(frame) - _titleLabel.width - _suffixLabel.width;
    if (contentAllowWidth < _contentLabel.width) {
        _contentLabel.width = contentAllowWidth;
    }
    _suffixLabel.right = CGRectGetMaxX(frame);
    _suffixLabel.top = CGRectGetMinY(frame);
}

@end
