//
//  LERealtimeTextFomView.m
//
//  Created by leo on 1/22/15.
//

#import "LERealtimeTextFomView.h"

@implementation LERealtimeTextFomView

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *changedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL valueValid = YES;
    if (self.fieldItem.valueChecker != NULL) {
        valueValid = self.fieldItem.valueChecker(changedText);
    }
    if (valueValid) {
        if (self.fieldItem.valueTrans) {
            textField.text = self.fieldItem.valueTrans(changedText);
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

@end
