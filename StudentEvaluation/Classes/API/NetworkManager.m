//
//  NetworkManager.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NetworkManager.h"
#import "GetVerifyCodeApi.h"
#import "BSParseUtil.h"
#import "ResetPasswordApi.h"
#import "FequentlyUsedMedalApi.h"
#import "ClassListApi.h"
#import "BSClassModel.h"
#import "BSMedalModel.h"
#import "MedalLibraryApi.h"
#import "AddMedalToFrequentUsedApi.h"
#import "StudentListApi.h"
#import "StudentModel.h"
#import "BSStringUtil.h"
#import "ReleaseMedalApi.h"
#import "MedalRecordApi.h"
#import "MedalRecordModel.h"
#import "RevokeMedalApi.h"
#import "ScanQrCodeApi.h"
#import "UnreadNoticeApi.h"
#import "NoticeListApi.h"
#import "NoticeModel.h"
#import "ConfirmSelfAproveApi.h"
#import "BindPhoneApi.h"
#import "ChangePasswordApi.h"

@implementation NetworkManager

+ (void)getVerficationCode:(NSString *)phone userId:(NSString *)userId completed:(void(^)(NSError *error ,NSString *code))completed
{
    GetVerifyCodeApi *api = [[GetVerifyCodeApi alloc] initPhoneNumber:phone userId:nil];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];

        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";

            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error, nil);
            return ;
        }
        
        NSString *code = [[json objectForKey:@"content"] objectForKey:@"code"];
        completed(nil, code);
    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];

}

+ (void)resetPassword:(NSString *)password verifyCode:(NSString *)verifyCode phone:(NSString *)phone completed:(void(^)(NSError *error))completed
{
    ResetPasswordApi *api = [[ResetPasswordApi alloc] initPhoneNumber:phone verifyCode:verifyCode password:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";
            
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error);
            return ;
        }
        
        completed(nil);

    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error);
    }];
}

+ (void)changePasswordForUser:(NSString *)userName passowrd:(NSString *)password oldPassword:(NSString *)oldPassword completed:(void(^)(NSError *error))completed
{
    ChangePasswordApi *api = [[ChangePasswordApi alloc] initWithUserName:userName oldPassword:oldPassword newPassword:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";
            
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error);
            return ;
        }
        
        completed(nil);
        
    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error);
    }];
}

+ (void)fequentlyUsedMedalForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed
{
    FequentlyUsedMedalApi *api = [[FequentlyUsedMedalApi alloc] initWithTeacherId:teacherId classId:classId medalType:medalType];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[BSMedalModel class] error:&error];
        completed(error, array);
    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)classListForTeacherId:(NSString *)teacherId completed:(void(^)(NSError *error,NSArray *result))completed
{
    ClassListApi *api = [[ClassListApi alloc] initWithTeacherId:teacherId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[BSClassModel class] error:&error];
        completed(error, array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)loadMedalLibraryForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed
{
    MedalLibraryApi *api = [[MedalLibraryApi alloc] initWithTeacherId:teacherId classId:classId medalType:medalType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger   errorCode = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [request.responseJSONObject objectForKey:@"msg"];
            errorMessage = errorMessage ? : @"操作失败";
            
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error, nil);
            return ;
        }

        NSArray *content = [request.responseJSONObject objectForKey:@"content"];
        NSMutableArray *object = [NSMutableArray array];
        for (NSDictionary *dic in content) {
            NSArray *array = [dic objectForKey:@"data"];
            NSNumber *fieldId = [dic objectForKey:@"vedioo_id"];
            NSString *fieldName = [dic objectForKey:@"veidoo_name"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *json in array) {
                BSMedalModel *medal = [BSMedalModel yy_modelWithJSON:json];
                medal.medalFieldId = fieldId;
                medal.medalFieldName = fieldName;
                [tempArray addObject:medal];
            }
            
            [object addObject:tempArray];
        }

        completed(nil, object);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)addMedalToFrequent:(NSString *)medalId teacherId:(NSString *)teacherId completed:(void(^)(NSError *error))completed
{
    AddMedalToFrequentUsedApi *api = [[AddMedalToFrequentUsedApi alloc] initWithTeacherId:teacherId medalId:medalId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

+ (void)loadStudentsList:(NSString *)classId completed:(void(^)(NSError *error,NSArray *result, NSArray *keys))completed
{
    StudentListApi *api = [[StudentListApi alloc] initWithClassId:classId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[StudentModel class] error:&error];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSArray *characters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
        for (NSString *str in characters) {
            [dictionary setObject:[NSMutableArray array] forKey:str];
        }

        // 归类
        for (StudentModel *model in array) {
            NSString *pinyin = [BSStringUtil pinyinFromChinese:model.studentName lowercase:NO];
            model.pinyinString = pinyin;
            
            if (pinyin.length == 0) {
                continue;
            }
            
            char character = [pinyin characterAtIndex:0];
            character = (character >= 'A' && character <= 'Z') ? character : '#';
            NSString *key = [NSString stringWithFormat:@"%c",character];
            
            NSMutableArray *arr = [dictionary objectForKey:key];
            [arr addObject:model];
        }
        
        // section 内部排序
        for (NSString *key in dictionary.allKeys.copy) {
            NSArray *array = [dictionary objectForKey:key];
            NSArray *res = [array sortedArrayUsingComparator:^NSComparisonResult(StudentModel *obj1, StudentModel *obj2) {
                return [obj1.pinyinString compare:obj2.pinyinString];
            }];
            [dictionary setObject:res forKey:key];
        }
        
        // section 排序
        NSMutableArray *list = [NSMutableArray array];
        NSMutableArray *keys = [NSMutableArray array];
        for (NSString *key in characters) {
            NSArray *array = [dictionary objectForKey:key];
            if (array.count) {
                [list addObject:array];
                [keys addObject:key];
            }
        }
        
        completed(error, list, keys);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil, nil);
    }];
}

+ (void)releaseMedal:(NSString *)medalId
           toStudent:(NSArray <StudentModel *> *)students
               class:(BSClassModel *)class
               score:(NSNumber *)score
             teacher:(NSString *)teacherId
                desc:(NSString *)desc
               voice:(NSArray <VoiceModel *> *)voices
         attachments:(NSArray <BSAttachmentModel *> *)attachments
           completed:(void(^)(NSError *error))completed
{
    NSMutableArray *studentsId = [NSMutableArray array];
    for (StudentModel *student in students) {
        [studentsId addObject:student.identifier];
    }
    NSString *studentIdString = [studentsId componentsJoinedByString:@","];
    
    ReleaseMedalApi *api = [[ReleaseMedalApi alloc] initWithTeacherId:teacherId medalId:medalId studentIds:studentIdString classId:class.classId score:score desc:desc voices:voices photos:attachments];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

+ (void)medalRecordForClass:(NSString *)classId teacher:(NSString *)teacherId page:(NSNumber *)page count:(NSNumber *)count completed:(void(^)(NSError *error,NSArray *result))completed
{
    MedalRecordApi *api = [[MedalRecordApi alloc] initWithClassId:classId teacherId:teacherId page:page pageSize:count];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[MedalRecordModel class] error:&error];
        completed(error, array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)revokeMedalRecord:(NSString *)medalRecordId teacherId:(NSString *)teacherId completed:(void(^)(NSError *error))completed
{
    RevokeMedalApi *api = [[RevokeMedalApi alloc] initWithMedalRecordId:medalRecordId teacherId:teacherId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

+ (void)scanQrCode:(NSString *)text userId:(NSString *)userId completed:(void(^)(NSError *error))completed
{
    ScanQrCodeApi *api = [[ScanQrCodeApi alloc] initWithText:text userId:userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

+ (void)loadUnreadNotice:(NSString *)userId completed:(void(^)(NSError *error,NSNumber *result))completed
{
    UnreadNoticeApi *api = [[UnreadNoticeApi alloc] initWithUserId:userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error, nil);
            return ;
        }
        
        NSNumber *count = [[json objectForKey:@"content"] objectForKey:@"noticeCount"];
        completed(nil, count);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil, nil);
    }];
}

+ (void)loadNoticeListForUser:(NSString *)userId page:(NSNumber *)page count:(NSNumber *)count completed:(void(^)(NSError *error,NSArray *result))completed
{
    NoticeListApi *api = [[NoticeListApi alloc] initWithUserId:userId page:page count:count];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[NoticeModel class] error:&error];
        completed(error, array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil, nil);
    }];
}

+ (void)confirmSelfAprove:(NSString *)studentSelfId
                toStudent:(NSString *)studentId
                    score:(NSNumber *)score
                  teacher:(NSString *)teacherId
                     desc:(NSString *)desc
                    voice:(NSArray <VoiceModel *> *)voices
              attachments:(NSArray <BSAttachmentModel *> *)attachments
                completed:(void(^)(NSError *error))completed
{
    ConfirmSelfAproveApi *api = [[ConfirmSelfAproveApi alloc] initWithTeacherId:teacherId comment:desc studentId:studentId score:score studentSelfId:studentSelfId voices:voices photos:attachments];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

+ (void)bindPhone:(NSString *)phone identifyCode:(NSString *)identifyCode userId:(NSString *)userId completed:(void(^)(NSError *error))completed
{
    BindPhoneApi *api = [[BindPhoneApi alloc] initWithUserId:userId phone:phone identifyCode:identifyCode];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [BSParseUtil parseStatusFromJson:request.responseJSONObject errorMessage:nil];
        completed(error);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(nil);
    }];
}

@end
