//
//  VoiceListCell.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "VoiceListCell.h"
#import "VoiceModel.h"
#import "BSStringUtil.h"
#import "BSMusicPlayer.h"

@interface VoiceListCell()

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) VoiceModel *model;

@end

@implementation VoiceListCell

- (void)configureCellWithModel:(VoiceModel *)aModel atIndexPath:(NSIndexPath *)indexPath
{
    self.model = aModel;
    self.timeLabel.text = [BSStringUtil timeStringFromInterval:aModel.duration.integerValue];
}

- (IBAction)play:(id)sender
{
    BSTrack *track = [[BSTrack alloc] init];
    track.audioFileURL = [NSURL fileURLWithPath:self.model.path ? :@""];
    track.identifier = [NSString stringWithFormat:@"%lu",(unsigned long)self.model.path.hash];
    [[BSMusicPlayer player] playOrPause:track];
}

- (IBAction)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
        [self.delegate didClickDeleteButton:self];
    }
}

@end
