//
//  ZIMKitRecordView.h
//  ZIMKit_OC
//
//  Created by zego on 2022/8/29.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RecordStatus) {
    ZIMKitRecord_Status_Recording,
    ZIMKitRecord_Status_Cancel,
    ZIMKitRecord_Status_Timeout,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitRecordView : UIView

- (void)setVoiceValue:(CGFloat)value;

- (void)setStatus:(RecordStatus)status;

- (void)setRecordTimeL:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
