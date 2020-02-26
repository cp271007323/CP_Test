//
//  NSString+YBCodec.m
//  Aa
//
//  Created by Aalto on 2018/11/20.
//  Copyright © 2018 Aalto. All rights reserved.
//

@implementation NSString (Extras)

/**
 *  判断对象 / 数组是否为空
 *  为空返回 YES
 *  不为空返回 NO
 */
+(BOOL)isEmptyStr:(NSString *)value{
    
    if (value == nil ||
        value == NULL) return YES;
    
    if ([value isKindOfClass:[NSString class]]){
        
        if (((NSString *)value).length > 0){
            
            if ([value isEqualToString:@"(null)"]||
                [value isEqualToString:@"null"]||
                [value isEqualToString:@"<null>"]) return YES;
        }
        
        else return YES;
    }
    
    return NO;
}


#pragma mark -  高亮文字（搜索结果包含关键字）
+ (NSMutableAttributedString *)getAttributeStrWithString:(NSString *)string{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if ([string containsString:@"</em>"]) {
        NSArray *arr = [string componentsSeparatedByString:@"</em>"];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = arr[i];
            if ([str containsString:@"<em>"]) {
                NSMutableArray *rangeArray = [self rangeOfSubString:@"<em>" inString:str];
                NSRange range = [rangeArray.lastObject rangeValue];
                NSString *strResult = [str substringFromIndex:range.location + range.length];//高亮的文字"哈>2"
                NSRange strRange = [str rangeOfString:[NSString stringWithFormat:@">%@", strResult]];//高亮文字加一个>的range,也就是">哈>2"的range
                NSRange resultStrRange = NSMakeRange(strRange.location + 1, strRange.length - 1);//高亮文字range
                if (i == 0) {
                    NSDictionary *dic = @{@"location":@(resultStrRange.location), @"length":@(resultStrRange.length)};
                    [array addObject:dic];
                }else{
                    
                    if (array.count > 0) {
                        NSDictionary *dic = array[array.count - 1];
                        NSDictionary *resultDic  = @{@"location":@(resultStrRange.location + [dic[@"location"] integerValue]+ [dic[@"length"] integerValue] + 5), @"length":@(resultStrRange.length)};//第二个开始的range都是在前一个rang的基础上累加的
                        [array addObject:resultDic];
                    }else{
                        int nLength = 0;
                        for (int m = 0; m < i; m++) {
                            nLength = nLength + (int)[arr[m] length] + 5;
                        }
                        NSDictionary *dic = @{@"location":@(resultStrRange.location + nLength), @"length":@(resultStrRange.length)};//[arr[i - 1] length] + 5指的是数组前一个字符串的长度+</em>的长度
                        [array addObject:dic];
                    }
                    
                }
            }
        }
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    for (int i = 0; i < array.count; i++) {
        NSRange range = NSMakeRange([array[i][@"location"] integerValue], [array[i][@"length"] integerValue]);
        @try {
            if (attString.length >= (range.length + range.location)) {
                [attString addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:range];
            }
        } @catch (NSException *exception) {

        }
    }
    return [self getDeletedTagStringwithString:attString andArray:array];
}

+ (NSMutableAttributedString *)getDeletedTagStringwithString:(NSMutableAttributedString *)attributeString andArray:(NSMutableArray *)array{
    
    NSMutableAttributedString *attString = attributeString;
    for (int i = 0; i < array.count; i++) {
        NSRange range1 = NSMakeRange([array[i][@"location"] integerValue] - 4 - (4 + 5) * i, 4);//高亮文字前面的<em>的range
        
        [attString deleteCharactersInRange:range1];
        
        NSRange range2 = NSMakeRange([array[i][@"location"] integerValue] + [array[i][@"length"] integerValue] - 5 * i - 4 * (i + 1), 5);//高亮文字前面的</em>的range(删除<em>之后,所以location要-4)
        
        [attString deleteCharactersInRange:range2];
    }
    
    return attString;
}


+ (NSMutableArray *)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *string1 = [string stringByAppendingString:subStr];//防止数组越界,崩溃的
    
    NSString *temp;
    
    for(int i = 0; i < string.length; i++) {
        
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i, subStr.length};
            
            [rangeArray addObject: [NSValue valueWithRange:range]];
            
        }
        
    }
    
    return rangeArray;
}

@end
