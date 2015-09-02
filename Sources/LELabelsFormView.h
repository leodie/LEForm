//
//  PALabelsFormView.h
//  haofang
//
//  Created by leo on 15/1/20.
//  Copyright (c) 2015年 平安好房. All rights reserved.
//

#import "LEForm.h"

@interface LELabelsFormModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *suffixContent;

@property (nonatomic, copy) NSAttributedString *attrContent;
@property (nonatomic, copy) NSAttributedString *attrSuffixContent;

@end

@interface LELabelsFormView : LEFormView
{
    UILabel *_titleLabel;
    UIEdgeInsets _inPadding;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *contentLabel;
@property (nonatomic, readonly) UILabel *suffixLabel;


@end
