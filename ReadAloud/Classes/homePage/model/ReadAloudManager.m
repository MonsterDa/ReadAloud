//
//  ReadAloudManager.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "ReadAloudManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ReadAloudManager()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (nonatomic, strong) AVSpeechUtterance *speechUtterance;

@property (nonatomic, strong) ReadBookModel *readModel;
@property (nonatomic, strong) ReadChapterModel *chapterModel;
@end

@implementation ReadAloudManager

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static ReadAloudManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ReadAloudManager alloc]init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
//        默认值
        self.rate = 0.5;
        self.language = @"zh-cn";
        
        NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
//        处理中断
        [nsnc addObserver:self
                 selector:@selector(handleInterruption:)
                     name:AVAudioSessionInterruptionNotification
                   object:[AVAudioSession sharedInstance]];
//        注册线路改变
        [nsnc addObserver:self
                 selector:@selector(handleRouteChange:)
                     name:AVAudioSessionRouteChangeNotification
                   object:[AVAudioSession sharedInstance]];

    }
    return self;
}

- (void)setupLockScreenInfo{
    
    
    // 锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    // 设置歌曲标题
    [playingInfo setObject:_readModel.bookName forKey:MPMediaItemPropertyAlbumTitle];
    // 设置歌手
    [playingInfo setObject:_chapterModel.chapterName forKey:MPMediaItemPropertyArtist];
    // 设置封面
    MPMediaItemArtwork *artWork;
    if (@available(iOS 10.0, *)) {
         artWork = [[MPMediaItemArtwork alloc]initWithBoundsSize:CGSizeMake(200, 200) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return [UIImage imageNamed:@"AppIcon"];
        }];
    } else {
        artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    }
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    playingInfoCenter.nowPlayingInfo = playingInfo;
    
}
//处理中断
- (void)handleInterruption:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self pauseSpeech];
        NSLog(@"暂停");
    }else{
        
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            NSLog(@"继续");
            [self continueSpeech];
        }
    }
}
//处理线路改变
- (void)handleRouteChange:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntValue];
    
    switch (reason) {
        case AVAudioSessionRouteChangeReasonUnknown:
//            改变的原因尚不清楚。
            
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            一种新的设备出现了(例如，耳机已插入)。
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
//            旧设备无法使用(例如，耳机已被拔掉)。
            
            [self pauseSpeech];
            
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
//            音频类别发生了变化(例如AVAudioSessionCategoryPlayback改为AVAudioSessionCategoryPlayAndRecord)。
            
            break;
        case AVAudioSessionRouteChangeReasonOverride:
//            路由被重写(例如，类别是AVAudioSessionCategoryPlayAndRecord和输出)
//            已从默认的接收者更改为扬声器)
            
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
//            设备从睡梦中醒来。
            
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
//            当当前类别没有路由时返回(例如，类别是AVAudioSessionCategoryRecord)
//            但是没有输入设备可用)。
            
            break;
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange:
//            指示输入和/我们的输出端口的集合没有更改，而是更改了它们的某些方面
//            配置发生了变化。例如，端口选择的数据源已经更改。
            
            break;
        default:
            break;
    }
}



//播放
- (void)startReadBookModel:(ReadBookModel *)readModel chapterModel:(ReadChapterModel *)chapterModel{
    self.readModel = readModel;
    self.chapterModel = chapterModel;
    [self startSpeech];
}

- (void)setLanguage:(NSString *)language{
    _language = language;
}
- (void)setRate:(CGFloat)rate{
    _rate = rate;
}
/**
 开始朗读
 */
- (void)startSpeech{
    [self cancelSpeech];
    [self setupLockScreenInfo];
    _speechUtterance = [[AVSpeechUtterance alloc]initWithString:_chapterModel.content];
    _speechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:_language];
//    _speechUtterance.preUtteranceDelay = 0;
    _speechUtterance.rate = _rate;
//    _speechUtterance.pitchMultiplier = .5;
    [self.speechSynthesizer speakUtterance:self.speechUtterance];
    [ZJCustomHud showWithStatus:@"加载中..."];
}

/**
 暂停
 */
- (void)pauseSpeech{
    NSLog(@"%d",self.speechSynthesizer.paused);
    if (!self.speechSynthesizer.paused) {
        [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    }else{
//        [self.speechSynthesizer continueSpeaking];
    }
}

/**
 继续
 */
- (void)continueSpeech{
    [self.speechSynthesizer continueSpeaking];
}

/**
 取消
 */
- (void)cancelSpeech{
    if (self.speechSynthesizer.speaking) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

/**
 上一章
 */
- (void)previousChapter{
    for (int i = 0; i < _readModel.chapterModels.count; i++) {
        ReadChapterModel *model = _readModel.chapterModels[i];
        if ([_chapterModel.lastChapterID isEqualToString:model.chapterID]) {
            _chapterModel = model;
            [self startSpeech];
            return;
        }
    }
}

/**
 下一章
 */
- (void)nextChapter{
    for (int i = 0; i < _readModel.chapterModels.count; i++) {
        ReadChapterModel *model = _readModel.chapterModels[i];
        if ([_chapterModel.nextChaperID isEqualToString:model.chapterID]) {
            _chapterModel = model;
            [self startSpeech];
            return;
        }
    }
}
#pragma mark - AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
//    NSLog(@"location:%lu",(unsigned long)characterRange.location);
}
//开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    [ZJCustomHud dismiss];
}
//完成
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self nextChapter];
}
//暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    
}
//继续
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    
}
//取消
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}

#pragma mark - 懒加载
- (AVSpeechSynthesizer *)speechSynthesizer{
    if (!_speechSynthesizer) {
        _speechSynthesizer = [AVSpeechSynthesizer new];
        _speechSynthesizer.delegate = self;
    }
    return _speechSynthesizer;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
