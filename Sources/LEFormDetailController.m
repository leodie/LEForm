//
//  PAFormDetailController.m
//
//  Created by leo on 14/11/11.
//

#import "LEFormDetailController.h"
#import "PADefaultFormView.h"

@interface LEFormTextDetailController () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *inputPromptLabel;
@property (nonatomic, assign) NSInteger maximumInputs;
@property (nonatomic, assign) NSInteger minimumInputs;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation LEFormTextDetailController

#pragma mark - Object life cycle

- (instancetype)initWithField:(LEFormField *)field
{
    if (self = [super init]) {
        _fieldItem = field;
        self.maximumInputs = _fieldItem.maximumInputs;
        self.minimumInputs = _fieldItem.minimumInputs;
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"PAFormTextDetailController is deallocating...");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.editing = NO;
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark self method

- (void)initViews
{
    const CGFloat internal = 10.0f;
    self.view.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(internal, internal, size.width - 2 * internal, 200.0)];
    
    self.inputPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.height - 2 * internal, 44.0f)];
    self.inputPromptLabel.backgroundColor = [UIColor clearColor];//self.view.backgroundColor;
    self.inputPromptLabel.textColor = [UIColor colorWithRed:0.424 green:0.424 blue:0.424 alpha:1];
    self.inputPromptLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 44.0f)];
    accessoryView.backgroundColor = [UIColor clearColor];
    [accessoryView addSubview:self.inputPromptLabel];
    
    _textView.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
    _textView.text = validValueChanger(self.fieldItem, [NSString class]);
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.textColor = self.inputPromptLabel.textColor;
    
    _textView.inputAccessoryView = accessoryView;
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, size.height - 2 * internal, 20.0f)];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textColor = self.inputPromptLabel.textColor;
    self.placeholderLabel.font = self.inputPromptLabel.font;
    self.placeholderLabel.text = _fieldItem.placeholder;
    
    [self.view addSubview:_textView];
    [self.view addSubview:self.placeholderLabel];
    [self textViewDidChange:_textView];
}

- (void)initNavigationBar
{
    self.title = self.fieldItem.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchUpDone:)];
}

#pragma mark event respond

- (void)touchUpDone:(id)sender
{
    NSUInteger numberOfInputs = [self.textView.text length];
    
//    if (self.minimumInputs != NSNotFound && numberOfInputs < self.minimumInputs) {
//        [PANoticeUtil showNotice:[NSString stringWithFormat:@"至少需要输入%d个字符", self.minimumInputs]];
//        return;
//    }
    
    if (self.maximumInputs != NSNotFound && numberOfInputs > self.maximumInputs) {
//        [PANoticeUtil showNotice:[NSString stringWithFormat:@"不能超过%tu个字", self.maximumInputs]];
        return;
    }
    
    if (self.fieldItem.valueClass == nil ||
        [self.fieldItem.valueClass isSubclassOfClass:[NSString class]]) {
        self.fieldItem.value = _textView.text;
    } else {
        self.fieldItem.value = self.fieldItem.reverseValueTrans(_textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger numberOfInputs = [textView.text length];
    
    // 根据输入是否为空显示或者隐藏placeholder
    self.placeholderLabel.hidden = (numberOfInputs > 0);
    
    // 更新剩余字数
    if (self.maximumInputs != NSNotFound) {
        if (numberOfInputs == 0) {
            self.inputPromptLabel.text = [NSString stringWithFormat:@"字数限制：%tu", self.maximumInputs];
        }
        else if (self.maximumInputs >= numberOfInputs) {
            self.inputPromptLabel.text = [NSString stringWithFormat:@"还可以输入字数：%tu", self.maximumInputs - numberOfInputs];
        }
        else { // 超出字数限制，用红色字体提示
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"还可以输入字数："
                                                                                                        attributes:@{}];
            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(self.maximumInputs - numberOfInputs)]
                                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
            self.inputPromptLabel.attributedText = mutableAttributedString;
        }
    }
}


@end