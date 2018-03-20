//
//  BSLoginManager.m
//  Pods
//
//  Created by Yang.Lv on 2017/3/18.
//
//

#import "BSLoginManager.h"
#import "BSSettings.h"
#import "LoginApi.h"

static NSString *USER_INFO = @"user_info";
static NSString *USER_DETAIL_INFO = @"user_detail_info";
static NSString *ACCESS_TOKEN = @"token";

@interface BSLoginManager ()

@property (nonatomic, assign) BOOL userDetailLoaded;

@end

@implementation BSLoginManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init]) {
        
        self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
        NSDictionary *detailDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DETAIL_INFO];
        
        if (detailDic) {
            self.userDetailLoaded = YES;
            self.userModel = [BSUserModel yy_modelWithDictionary:detailDic];
        } else {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
            self.userModel = [BSUserModel yy_modelWithDictionary:dic];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenError:) name:DODOEDU_ACCESS_TOKEN_ERROR_NOTIFICATION object:nil];
    }
    
    return self;
}

+ (instancetype)shareManager
{
    static id               manager = nil;
    static dispatch_once_t  onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (BOOL)isLogin
{
    return self.accessToken.length;
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completed:(void (^)(NSError *error, NSDictionary *response))completed
{
    LoginApi *api = [[LoginApi alloc] initWithUsername:userName password:password];
    
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        if (code != 200) {
            NSString *message = [request.responseJSONObject objectForKey:@"msg"];
            NSInteger errorCode = code;
            NSError *error = [NSError errorWithDomain:@"com.studentEvaluation" code:errorCode userInfo:@{NSLocalizedDescriptionKey : message}];
            completed(error, nil);
            return;
        }
        
        NSDictionary *content = [request.responseJSONObject objectForKey:@"content"];
        self.userModel = [BSUserModel yy_modelWithDictionary:content];
        self.accessToken = [content objectForKey:ACCESS_TOKEN] ? : @"";
        
        [[NSUserDefaults standardUserDefaults] setObject:self.userModel.userId forKey:@"HBBS_user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:content forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completed) {
            completed(nil, content);
        }
    } failure:^(YTKBaseRequest *request) {
        if (completed) {
            completed(request.error, nil);
        }
    }];
}

- (void)tokenError:(NSNotification *)notification
{
    [self removerCurrentUserInfo];
}

- (void)removerCurrentUserInfo
{
    self.userModel = nil;
    self.accessToken = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HBBS_user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DETAIL_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateCurrentUser:(BSUserModel *)userModel
{
    NSDictionary *dic = [userModel yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 检查是否是未认证用户
- (BOOL)isCertified:(NSNumber *)userStatus
{
    if (!userStatus) {
        return NO;
    }
    
    return [userStatus integerValue] != 5;
}

// 正则匹配用户密码6-20位数字和字母组合
+ (BOOL)checkUserName:(NSString *)userName AndPassword:(NSString *)password
{
    BOOL    userNameOK = NO;
    BOOL    passwordOK = NO;
    
    if ((userName.length >= 6) && (userName.length <= 20)) {
        userNameOK = YES;
    }
    
    if ((password.length >= 6) && (password.length <= 20)) {
        passwordOK = YES;
    }
    
    return userNameOK && passwordOK;
}

@end
