//
//  NSObject+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZIMKitUtil)

-(void)runInMainThreadSync:(dispatch_block_t)block;
-(void)runInMainThreadAsync:(dispatch_block_t)block;

- (void) runInGlobalThreadAsync:(dispatch_block_t ) block;
@end

NS_ASSUME_NONNULL_END
