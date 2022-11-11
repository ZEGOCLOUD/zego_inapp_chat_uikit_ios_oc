//
//  NSObject+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/6/8.
//

#import "NSObject+ZIMKitUtil.h"

@implementation NSObject (ZIMKitUtil)

-(void ) runInMainThreadSync:(dispatch_block_t ) block
{
    
    if ([NSThread currentThread].isMainThread) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
        
    }
    
}

-(void ) runInMainThreadAsync:(dispatch_block_t ) block
{
    
    if ([NSThread currentThread].isMainThread) {
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
        
    }
}

- (void) runInGlobalThreadAsync:(dispatch_block_t ) block
{
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}

@end
