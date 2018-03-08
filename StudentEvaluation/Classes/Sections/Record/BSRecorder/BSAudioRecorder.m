//
//  BSAudioRecorder.m
//  ReplyKitDemo
//
//  Created by Yang.Lv on 2017/8/4.
//  Copyright © 2017年 czl. All rights reserved.
//

#import "BSAudioRecorder.h"
#import "lame.h"

@interface BSAudioRecorder ()

@property (nonatomic, strong) NSString *cafPath;
@property (nonatomic, strong) NSString *cafFileName;

@end

@implementation BSAudioRecorder

- (void)dealloc
{
    [self.recorder stop];
    self.recorder = nil;
}

- (void)startRecordWithFileName:(NSString *)fileName
{
    _cafPath = [[[[self class] fileDirectory] stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"caf"];
    _cafFileName = _cafPath.lastPathComponent;

    _filePath = [[[[self class] fileDirectory] stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"mp3"];
    _fileName = _filePath.lastPathComponent;

    NSURL *url = [NSURL fileURLWithPath:[_cafPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self _audioRecorderSettings] error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [_recorder record];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self conventToMp3];
    });
}

- (void)stopRecord
{
    [self.recorder stop];
    self.recorder = nil;

    if ([self.delegate respondsToSelector:@selector(recorder:recordFinished:)]) {
        [self.delegate recorder:self recordFinished:self.filePath];
    }
}

- (void)pause
{
    [self.recorder pause];
    _isPaused = YES;
}

- (void)resume
{
    _isPaused = NO;
    [self.recorder record];
}

- (NSTimeInterval)duration
{
    return self.recorder.currentTime;
}

+ (NSString *)fileDirectory
{
    NSString        *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString        *recorderPath = [searchPath stringByAppendingPathComponent:@"recorder"];
    NSFileManager   *manager = [NSFileManager defaultManager];
    
    [manager createDirectoryAtPath:recorderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return recorderPath;
}

#pragma mark -  file path
- (NSDictionary *)_audioRecorderSettings
{
    NSDictionary *settings = @{AVNumberOfChannelsKey : [NSNumber numberWithInt:2],
                               AVSampleRateKey : [NSNumber numberWithFloat:11025],
                               AVFormatIDKey   : [NSNumber numberWithInt:kAudioFormatLinearPCM],
                               AVLinearPCMBitDepthKey : [NSNumber numberWithInt:16],
                               AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityHigh]};

    return settings;
}

#pragma mark - private
- (void)conventToMp3
{
    @try{
        int read = 0;
        int write = 0;
        
        FILE *pcm =fopen([self.cafPath cStringUsingEncoding:NSASCIIStringEncoding],"rb");
        FILE *mp3 =fopen([self.filePath cStringUsingEncoding:NSASCIIStringEncoding],"wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame =lame_init();
        lame_set_num_channels(lame,2);
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_quality(lame,2);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        long currentPosition;
        BOOL isSkipPCMHeader =NO;
        
        do{
            currentPosition =ftell(pcm);
            long startPositon =ftell(pcm);
            fseek(pcm, 0,SEEK_END);
            
            long endPositon = ftell(pcm);
            long length = endPositon - startPositon;
            fseek(pcm, currentPosition,SEEK_SET);
            
            if(length > PCM_SIZE * 2 *sizeof(short int)) {
                if(!isSkipPCMHeader) {
                    //Uump audio file header, If you do not skip file header
                    //you will heard some noise at the beginning!!!
                    fseek(pcm, 4 * 1024,SEEK_SET);
                    isSkipPCMHeader =YES;
                }
                
                read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
                write =lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            }
            
            else{
                [NSThread sleepForTimeInterval:0.05];
            }
            
        } while(self.recorder);
        
        read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
        write =lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        
        lame_close(lame);
        
        fclose(mp3);
        fclose(pcm);
    }
    
    @catch(NSException *exception) {
        // TODO:
    }
    
    @finally{
        // TODO: finish
        [[NSFileManager defaultManager] removeItemAtPath:_cafPath error:nil];
    }
}

@end
