//
//  ZIMKitRouter.m
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import "ZIMKitRouter.h"
#import <objc/runtime.h>


//注册的key
static NSString * const blockKey  = @"block";
static NSString * const routerKey = @"router";
static NSString * const classKey  = @"controllerClass";

//调用的key
static NSString * const rouderToVcKey = @"rouderToVcKey";
static NSString * const rouderFromVcKey = @"rouderFromVcKey";
static NSString * const routerNavKey = @"routerNavKey";
static NSString * const routerTypeKey = @"routerTypeKey";
static NSString * const routerBoolKey = @"routerBoolKey";
static NSString * const routerClassKey = @"routerClassKey";

@interface ZIMKitRouter ()

@property (nonatomic, strong) NSMutableDictionary *modulesDict;

@end

@implementation ZIMKitRouter

static ZIMKitRouter *sharedManagerInstance = nil;

+ (ZIMKitRouter *)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return _dataDict;
}
- (NSMutableDictionary *)cachDict {
    if (!_cachDict) {
        _cachDict = [[NSMutableDictionary alloc] init];
    }
    return _cachDict;
}

- (NSMutableDictionary *)paramDict {
    if (!_paramDict) {
        _paramDict = [[NSMutableDictionary alloc] init];
    }
    return _paramDict;
}

- (NSMutableDictionary *)modulesDict {
    if (!_modulesDict) {
        _modulesDict = [[NSMutableDictionary alloc] init];
    }
    return _modulesDict;
}

- (void)registerURLPattern:(NSString *)urlPattern Class:(Class)vcClass toHandler:(componentBlock)blk
{
    NSString * keyString = getCachDictKey(urlPattern);
    NSDictionary * routerDict = getRouterDict(urlPattern, vcClass, blk);
    [self.cachDict setObject:routerDict forKey:keyString];
}

- (ZIMKitRouter * (^)(JumpType))jump {
    return ^ZIMKitRouter *(JumpType type) {
        [self.dataDict setObject:[NSNumber numberWithInteger:type] forKey:routerTypeKey];
        return self;
    };
}

- (ZIMKitRouter * (^)(UIViewController *))fromVC {
    return ^ZIMKitRouter *(UIViewController * from) {
        [self.dataDict setObject:from forKey:rouderFromVcKey];
        return self;
    };
}

- (ZIMKitRouter * (^)(UIViewController *))toVC {
    return ^ZIMKitRouter *(UIViewController * tovc) {
        [self.dataDict setObject:tovc forKey:rouderToVcKey];
        return self;
    };
}

- (ZIMKitRouter * (^)(UINavigationController *))fromNav {
    return ^ZIMKitRouter *(UINavigationController * fromNav) {
        [self.dataDict setObject:fromNav forKey:routerNavKey];
        return self;
    };
}

- (ZIMKitRouter *)callBackBlock:(callBackBlock)callBack {
    [self.dataDict setObject:callBack forKey:backBlockKey];
    return self;
}

- (void)handler:(handlerBlock)block {
    [[ZIMKitRouter shareInstance].dataDict setObject:block forKey:routerHandlerKey];
}

- (ZIMKitRouter * (^)(NSString *))openUrl {
    return ^ZIMKitRouter *(NSString *url) {
        UIViewController * fromVC = self.dataDict[rouderFromVcKey];
        if (!fromVC) {
            fromVC = self.dataDict[routerClassKey];
        }
        
        UINavigationController * nav = self.dataDict[routerNavKey];
        if (!nav) {
            nav = getNav();
        }
        
        JumpType type = [self.dataDict[routerTypeKey] integerValue];
        if (!type) {
            type = Push;
        }

        [self analysisUrl:url];
        NSMutableDictionary *cachParam = [self.cachDict[getCachDictKey(url)] mutableCopy];
        if (self.dataDict[backBlockKey]) {
            [cachParam setObject:self.dataDict[backBlockKey] forKey:backBlockKey];
        }
        [self.cachDict setObject:cachParam forKey:getCachDictKey(url)];
        [self.dataDict removeAllObjects];
        [self.paramDict removeAllObjects];
        componentBlock blk = cachParam[blockKey];
        if (blk) {
            blk(_paramDict, nav, type, fromVC);
        }

        return self;
    };
}

- (ZIMKitRouter * (^)(NSString *,id))openUrlWithParam {
    return ^ZIMKitRouter * (NSString *url, id param) {
        UIViewController * fromVC = self.dataDict[rouderFromVcKey];
        if (!fromVC) {
            fromVC = self.dataDict[routerClassKey];
        }
        
        UINavigationController * nav = self.dataDict[routerNavKey];
        if (!nav) {
            nav = getNav();
        }
        
        JumpType type = [self.dataDict[routerTypeKey] integerValue];
        if (!type) {
            type = Push;
        }
        
        NSMutableDictionary *cachParam = [self.cachDict[getCachDictKey(url)] mutableCopy];
        if (self.dataDict[backBlockKey]) {
            [cachParam setObject:self.dataDict[backBlockKey] forKey:backBlockKey];
        }
        if (!cachParam) {
            NSLog(@"ZIMKitRoute exceptional~~~~");
            cachParam = [NSMutableDictionary dictionary];
        }
        [self.cachDict setObject:cachParam forKey:getCachDictKey(url)];
        componentBlock blk = cachParam[blockKey];
        [self.dataDict removeAllObjects];
        [self.paramDict removeAllObjects];
        if (blk) {
            blk(param, nav, type, fromVC);
        }
        
        return self;
    };
}

- (id (^)(NSString *))getVCFromUrl {
    return ^id (NSString *url) {
        NSDictionary *par = self.cachDict[getCachDictKey(url)];
        Class controllerClass = par[classKey];
        if (!controllerClass) {
            return nil;
        }
        return [[controllerClass alloc] init];
    };
}

- (void (^)(NSString *))deregisterURL {
    return ^void (NSString *url) {
        NSString * keySting = getCachDictKey(url);
        [[ZIMKitRouter shareInstance].cachDict removeObjectForKey:keySting];
    };
}

- (ZIMKitRouter * (^)(BOOL))animated {
    return ^ZIMKitRouter *(BOOL animated) {
        [self.dataDict setObject:[NSNumber numberWithBool:animated] forKey:routerBoolKey];
        return self;
    };
}

- (ZIMKitRouter * (^)(NSString *))closeWithUrl {
    return ^ZIMKitRouter * (NSString *url) {
        
        UIViewController * fromVC = self.dataDict[rouderFromVcKey];
        if (!fromVC) {
            fromVC = self.dataDict[routerClassKey];
        }
        
        UIViewController * toVC = self.dataDict[rouderToVcKey];
        
        JumpType type = [self.dataDict[routerTypeKey] integerValue];
        if (!type) {
            type = Pop;
        }
        
        UINavigationController * nav = self.dataDict[routerNavKey];
        id navOrVc = (nav==nil) ? fromVC : nav;
        
        if (!nav) {
            nav = getNav();
        }
        
        BOOL animated = [self.dataDict[routerBoolKey] boolValue];
        if (!self.dataDict[routerBoolKey]) {
            animated = YES;
        }
        
        switch (type) {
            case Pop:
                popViewController(nav, animated);
                break;
            case PopSome:
                popToSomeViewControlelr(nav, toVC, animated);
                break;
            case PopRoot:
                popToRootViewController(nav, animated);
                break;
            case Dismiss:
                dissmissViewController(navOrVc, animated);
                break;
            default:
                break;
        }
        [self.dataDict removeAllObjects];
        return self;
    };
}

//分解url获取传值
- (NSMutableDictionary *)analysisUrl:(NSString *)urlString {
    NSURL * url = [NSURL URLWithString:urlString];
    NSString * paramString = url.query;
    NSArray * paramArray = [paramString componentsSeparatedByString:@"&"];
    [self.paramDict removeAllObjects];
    [paramArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray* paramArr = [obj componentsSeparatedByString:@"="];
        if (paramArr.count > 1) {
            NSString* key = [paramArr objectAtIndex:0];
            NSString* value = [paramArr objectAtIndex:1];
            _paramDict[key] = value;
        }
    }];
    
    return _paramDict;
}

static inline void popViewController(id nav, BOOL animated) {
    if ([[nav class] isSubclassOfClass:[UINavigationController class]]) {
        [nav popViewControllerAnimated:animated];
    }
}

static inline void popToSomeViewControlelr(id nav, UIViewController *vc, BOOL animated) {
    if ([[nav class] isSubclassOfClass:[UINavigationController class]]) {
        [nav popToViewController:vc animated:animated];
    }
}

static inline void popToRootViewController(id nav, BOOL animated) {
    if ([[nav class] isSubclassOfClass:[UINavigationController class]]) {
        [nav popToViewController:((UINavigationController *)nav).viewControllers.firstObject animated:animated];
    }
}

static inline void dissmissViewController(id nav, BOOL animated) {
    dispatch_async(dispatch_get_main_queue(), ^{
        handlerBlock completion = [ZIMKitRouter shareInstance].dataDict[routerHandlerKey];
        [nav dismissViewControllerAnimated:animated completion:^{
            if (completion) {
                completion();
            }
        }];
    });
}

static inline NSDictionary *getRouterDict(NSString * router, Class vcClass, componentBlock blk) {
    return @{classKey:vcClass, routerKey:router, blockKey:blk};
}

NSString *getCachDictKey(NSString *router) {
    NSURL * url = [NSURL URLWithString:router];
    NSString * keyString = [NSString stringWithFormat:@"%@%@", url.host,url.path];
    return keyString;
}

static inline UINavigationController *getNav() {
    id class = [ZIMKitRouter shareInstance].dataDict[routerClassKey];
    if ([class isKindOfClass:[UIViewController class]]) {
        return ((UIViewController*)class).navigationController;
    } else if ([class isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)class;
    }
    return nil;
}

- (id)tabbarSelectedWithClass:(id)class andIndex:(NSInteger)index andBlock:(void (^)(id blockParam))block{
    NSString * selectIndex = @"setSelectedIndex:";
    id manager = class;
    SEL customSelector = NSSelectorFromString(selectIndex);
    NSAssert1(customSelector, @"No method exists%@", selectIndex);
    
    id result;
    if ([manager respondsToSelector:customSelector]){
        IMP imp = [manager methodForSelector:customSelector];
        id (*func)(id, SEL, id ) = (void *)imp;
        result = func(manager, customSelector,block);
    }
    return result;
}

#pragma mark - BusinessBus

- (void)registerModules:(NSArray *)modulesArray {
    for (NSString *moduleString in modulesArray) {
        [self.modulesDict setObject:createModule(moduleString) forKey:moduleString];
        registerUrlwithModuleString(moduleString);
    }
}

static void registerUrlwithModuleString(NSString *moduleString) {
    Class class = NSClassFromString(moduleString);
    SEL sel = NSSelectorFromString(@"registerURL");
    IMP imp = [class methodForSelector:sel];
    if (imp) {
        void (*func)(id, SEL) = (void *)imp;
        func(class, sel);
    }
}

static id createModule(NSString *moduleString) {
    Class class = NSClassFromString(moduleString);
    id module = [[class alloc]init];
    return module;
}

+ (id)postModuleWithTarget:(NSString*)moduleStr action:(SEL)aSelector withObject:(id)obj callBackBlock:(void (^)(id blockParam))block {
    id manager = [[ZIMKitRouter shareInstance].modulesDict objectForKey:moduleStr];
    SEL customSelector = aSelector;
    if (!obj) {
        obj = @"";
    }
    NSAssert1(customSelector, @"No method exists%@", NSStringFromSelector(aSelector));
    
    id result;
    if ([manager respondsToSelector:customSelector]) {
        IMP imp = [manager methodForSelector:customSelector];
        id (*func)(id, SEL ,id ,id ) = (void *)imp;
        result = func(manager, customSelector,obj,block);
    }
    
    return result;
}

+ (id)postModuleWithTarget:(NSString*)moduleStr action:(SEL)aSelector withObject:(id)obj {
    id manager = [[ZIMKitRouter shareInstance].modulesDict objectForKey:moduleStr];
    SEL customSelector = aSelector;
    if (!obj) {
        obj = @"";
    }
    NSAssert1(customSelector, @"No method exists%@", NSStringFromSelector(aSelector));
    
    id result;
    if ([manager respondsToSelector:customSelector]) {
        IMP imp = [manager methodForSelector:customSelector];
        id (*func)(id, SEL ,id) = (void *)imp;
        result = func(manager, customSelector,obj);
    }
    
    return result;
}

@end

#pragma mark - UIRouter Category
static void * CallBackBlockKey = (void *)@"CallBackBlockKey";

@implementation NSObject (ZIMKitRouter)

@dynamic router,callBackBlock;

- (ZIMKitRouter *)router {
    ZIMKitRouter *rout = [ZIMKitRouter shareInstance];
    [rout.dataDict setObject:self forKey:routerClassKey];
    return rout;
}

- (void)setCallBackBlock:(callBackBlock)callBackBlock {
    objc_setAssociatedObject(self, CallBackBlockKey, callBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (callBackBlock)callBackBlock {
    return objc_getAssociatedObject(self, CallBackBlockKey);
}

@end
