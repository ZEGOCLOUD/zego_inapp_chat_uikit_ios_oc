//
//  NSString+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "NSString+ZIMKitUtil.h"
#import "NSBundle+ZIMKitUtil.h"

@implementation NSString (ZIMKitUtil)

+ (NSString *)convertDateToStr:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    long long msgTime = [self dateConvert:msgDate];
    long long nowTime = [self dateConvert:nowDate];
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    long long marginTime = (nowTime - msgTime)/1000;
    if ( marginTime < OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    } else if (marginTime< 2*OnedayTimeIntervalValue && marginTime >= OnedayTimeIntervalValue) {
        return [NSString stringWithFormat:@"%@ %@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"],[self stringFromDate:msgDate format:@"HH:mm"]];
    } else if (marginTime < 7 *OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"EEEE HH:mm"];
    } else {
        if (nowDateComponents.year != msgDateComponents.year) {
            return [self stringFromDate:msgDate format:@"yyyy-MM-dd HH:mm"];
        } else {
            return [self stringFromDate:msgDate format:@"MM-dd HH:mm"];
        }
    }
}

+ (NSString *)conversationConvertDateToStr:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    long long msgTime = [self dateConvert:msgDate];
    long long nowTime = [self dateConvert:nowDate];
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    long long marginTime = (nowTime - msgTime)/1000;
    if ( marginTime < OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    } else if (marginTime< 2*OnedayTimeIntervalValue && marginTime >= OnedayTimeIntervalValue) {
        return [NSString stringWithFormat:@"%@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"]];
    } else if (marginTime < 7 *OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"EEEE"];
    } else {
        if (nowDateComponents.year != msgDateComponents.year) {
            return [self stringFromDate:msgDate format:@"yyyy-MM-dd"];
        } else {
            return [self stringFromDate:msgDate format:@"MM-dd"];
        }
    }
}

+ (NSString *)convertDateToStr2:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    BOOL isSameMonth = (nowDateComponents.year == msgDateComponents.year) && (nowDateComponents.month == msgDateComponents.month);

    if(isSameMonth && (nowDateComponents.day == msgDateComponents.day))
    {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    }
    else if(isSameMonth && (nowDateComponents.day == (msgDateComponents.day+1)))//yesterday
    {
        return [NSString stringWithFormat:@"%@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"]];
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//a week
    {
        return [self stringFromDate:msgDate format:@"EEEE HH:mm"];
    }
    else if (nowDateComponents.year != msgDateComponents.year)
   {
       return [self stringFromDate:msgDate format:@"yyyy-MM-dd HH:mm"];
       
   } else {
       return [self stringFromDate:msgDate format:@"MM-dd HH:mm"];
   }
}

// Time stamp converted to 0am time
+ (long long )dateConvert:(NSDate *)now
{
    NSCalendar *cal = [NSCalendar currentCalendar];

    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *zerocompents = [cal components:unitFlags fromDate:now];

    zerocompents.hour = 0;
    zerocompents.minute = 0;
    zerocompents.second = 0;

    NSDate *newdate= [cal dateFromComponents:zerocompents];
    
    //Time stamp format of converting time into milliseconds (this time is already the time of zero in the morning of the current day)
    NSTimeInterval zerointerval = [newdate timeIntervalSince1970]*1000;
    long long time = (long long)zerointerval;
    return time;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    dateFormatter = nil;
    return destDateString;
}

+ (BOOL) isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (NSString *)getCurrentThumbFileName:(NSString *)extension{
  
    return [NSString stringWithFormat:@"%d%0.0f_thumb_%@", arc4random() % 10000,[[NSDate date] timeIntervalSince1970] *1000,extension];
}

+ (NSString *)getCurrentVoiceFileName:(NSString *)extension{
  
    return [NSString stringWithFormat:@"%d%0.0f_voice.%@", arc4random() % 10000,[[NSDate date] timeIntervalSince1970] *1000,extension];
}

+ (NSString *)getCurrentVideoFileName:(NSString *)extension{
  
    return [NSString stringWithFormat:@"%d%0.0f_video.%@", arc4random() % 10000,[[NSDate date] timeIntervalSince1970] *1000,extension];
}

+ (NSString *)fileSizeTransformedValue:(double)value {
    double convertedValue = value;
    int multiply = 0;
    
    NSArray *tem = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiply++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tem objectAtIndex:multiply]];
}

@end
