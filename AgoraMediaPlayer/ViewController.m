//
//  ViewController.m
//  AgoraMediaPlayerKit
//
//  Created by 李晓晨 on 2019/7/2.
//  Copyright © 2019 李晓晨. All rights reserved.
//

#import "ViewController.h"
#import "RenderView.h"
#import <AgoraMediaPlayerKit/AgoraMediaPlayerKit.h>
#import <AgoraMediaPlayerKit/MediaInfoCallback.h>
#import <AgoraMediaPlayerKit/MediaPlayerKitEventHandler.h>
@interface ViewController ()
@property (atomic, strong) NSURL *videoUrl1;
@property (atomic, strong) NSURL *videoUrl2;
@property AgoraMediaPlayerKit * player ;
@property AgoraMediaPlayerKit * player2 ;
@property (weak, nonatomic) UIView *PlayerView;

@property NSMutableArray *audioPlayerArray;


@property (weak, nonatomic) IBOutlet UIButton *start_all;
@property (weak, nonatomic) IBOutlet UIButton *stop_all;
@property (weak, nonatomic) IBOutlet UIButton *start_all_video;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_1;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_2;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_3;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_4;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_5;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_6;
@property (weak, nonatomic) IBOutlet UIButton *start_audio_7;

@end

@interface VideoInfoHandler:NSObject <MediaInfoCallback> {
}
@end

@interface KitEventHandler:NSObject <MediaPlayerKitEventHandler> {
}
@end

@implementation VideoInfoHandler
-(void)onAudioTrackInfoCallBack:(AudioTrackInfo *) audioTrackInfo{
    NSLog(@"MediaPlayerKit callbackEvent AudioTrackInfo onAudioTrackInfoCallBack: %@  %d", audioTrackInfo,audioTrackInfo.sampleRate);
}

-(void)onVideoTrackInfoCallBack:(VideoTrackInfo *) videoTranckInfo{
    NSLog(@"MediaPlayerKit callbackEvent VideoInfoHandler onVideoTrackInfoCallBack: %@  %@", videoTranckInfo,videoTranckInfo.resolution);
}
@end

@implementation KitEventHandler

-(void)onKitError:(AgKitError)errorCode errMsg:(NSString *)errMsg{
    NSLog(@"MediaPlayerKit callbackEvent onKitError errorCode: %d  errMsg %@ ", errorCode,errMsg);
}
-(void)onPlayerStateChanged:(AgMediaPlayerState)state{
    NSLog(@"MediaPlayerKit callbackEvent onPlayerStateChanged: %d ", state);
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mainFunction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)mainFunction {
    self.videoUrl1 = [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4"];
    self.videoUrl2 = [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4"];
    
    
    NSArray *audioUrlsArray = @[[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92274/1.mp3"]
                                ,[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92274/2.mp3"]
                                ,[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92275/2.mp3"]
                                ,[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92279/1.mp3"]
                                ,[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92278/1.mp3"]
                                ,[NSURL URLWithString:@"http://mpge.5nd.com/2019/2019-6-25/92276/1.mp3"]
                                ,[NSURL URLWithString:@"http://bbcmedia.ic.llnwd.net/stream/bbcmedia_lrnorfolk_mf_p"]];
    
    _audioPlayerArray=[[NSMutableArray alloc]initWithCapacity:audioUrlsArray.count];
    for(id url in audioUrlsArray){
        NSLog(@"MediaPlayerKit audioUrlsArray %@",url);
        AgoraMediaPlayerKit *audioPlayer =[AgoraMediaPlayerKit createMediaPlayerKit];
        [audioPlayer load:url autoPlay:false];
        [_audioPlayerArray addObject:audioPlayer];
    }
    
    
    
    
    _player = [AgoraMediaPlayerKit createMediaPlayerKit];
    [_player load:self.videoUrl1 autoPlay:false];
    _player2 = [AgoraMediaPlayerKit createMediaPlayerKit];
    [_player2 load:self.videoUrl2 autoPlay:false];
    UIView *playerView = [[UIView alloc] init];
    [_player setVideoView:playerView];
    playerView.backgroundColor = [UIColor blackColor];
    
    UIView *playerView2 = [[UIView alloc] init];
    [_player2 setVideoView:playerView2];
    playerView2.backgroundColor = [UIColor redColor];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 360)];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.PlayerView];
    
    playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 180);
    playerView2.frame = CGRectMake(0, 180, self.view.bounds.size.width, 180);
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [self.PlayerView insertSubview:playerView2 atIndex:2];
    VideoInfoHandler *videoInfoHandler = [[VideoInfoHandler alloc] init];
    KitEventHandler *kiteventHandler = [[KitEventHandler alloc] init];
    [self.audioPlayerArray[0] setMediaInfoCallback:videoInfoHandler];
    [self.audioPlayerArray[0] setEventHandler:kiteventHandler];
}


- (IBAction)play_all_btn:(id)sender {
    //if (![self.player isPlaying]) {
    [self.player play];
    [self.player2 play];
    for (int i = 0; i < self.audioPlayerArray.count; i++) {
        [self.audioPlayerArray[i] play];
    }
    
}

- (IBAction)stop_all_btn:(id)sender {
    [self.player stop];
    [self.player2 stop];
    for (int i = 0; i < self.audioPlayerArray.count; i++) {
        [self.audioPlayerArray[i] stop];
    }
    
}


- (IBAction)start_all_video_btn:(id)sender {
    if(self.start_all_video.tag==1){
        self.start_all_video.tag=0;
        [self.player stop];
        [self.player2 stop];
        [self.start_all_video setTitle:@"开始全部视频" forState:UIControlStateNormal];
        [self.player adjustPlaybackSignalVolume:100];
    }else{
        self.start_all_video.tag=1;
        [self.player play];
        [self.player2 play];
        [self.start_all_video setTitle:@"停止全部视频" forState:UIControlStateNormal];
        [self.player adjustPlaybackSignalVolume:400];
    }
    
}

- (IBAction)start_audio1_btn:(id)sender {
    if(self.start_audio_1.tag==1){
        self.start_audio_1.tag=0;
        [self.audioPlayerArray[0] pause];
        [self.start_audio_1 setTitle:@"开始音频1" forState:UIControlStateNormal];
    }else{
        self.start_audio_1.tag=1;
        [self.audioPlayerArray[0] play];
        [self.start_audio_1 setTitle:@"暂停音频1" forState:UIControlStateNormal];
    }
}

- (IBAction)start_audio2_btn:(id)sender {
    if(self.start_audio_2.tag==1){
        self.start_audio_2.tag=0;
        [self.audioPlayerArray[1] pause];
        [self.start_audio_2 setTitle:@"开始音频2" forState:UIControlStateNormal];
    }else{
        self.start_audio_2.tag=1;
        [self.audioPlayerArray[1] play];
        [self.start_audio_2 setTitle:@"暂停音频2" forState:UIControlStateNormal];
//        NSLog(@"seek audio 2 %f",[self.audioPlayerArray[0] getDuration]);
//        [self.audioPlayerArray[0] seetkTo:([self.audioPlayerArray[0] getDuration])];
    }
}

- (IBAction)start_audio3_btn:(id)sender {
    if(self.start_audio_3.tag==1){
        self.start_audio_3.tag=0;
        [self.audioPlayerArray[2] pause];
        [self.start_audio_3 setTitle:@"开始音频3" forState:UIControlStateNormal];
    }else{
        self.start_audio_3.tag=1;
        [self.audioPlayerArray[2] play];
        [self.start_audio_3 setTitle:@"暂停音频3" forState:UIControlStateNormal];
    }
}

- (IBAction)start_audio4_btn:(id)sender {
    if(self.start_audio_4.tag==1){
        self.start_audio_4.tag=0;
        [self.audioPlayerArray[3] pause];
        [self.start_audio_4 setTitle:@"开始音频4" forState:UIControlStateNormal];
    }else{
        self.start_audio_4.tag=1;
        [self.audioPlayerArray[3] play];
        [self.start_audio_4 setTitle:@"暂停音频4" forState:UIControlStateNormal];
    }
}

- (IBAction)start_audio5_btn:(id)sender {
    if(self.start_audio_5.tag==1){
        self.start_audio_5.tag=0;
        [self.audioPlayerArray[4] pause];
        [self.start_audio_5 setTitle:@"开始音频5" forState:UIControlStateNormal];
    }else{
        self.start_audio_5.tag=1;
        [self.audioPlayerArray[4] play];
        [self.start_audio_5 setTitle:@"暂停音频5" forState:UIControlStateNormal];
    }
}

- (IBAction)start_audio6_btn:(id)sender {
    if(self.start_audio_6.tag==1){
        self.start_audio_6.tag=0;
        [self.audioPlayerArray[5] pause];
        [self.start_audio_6 setTitle:@"开始音频6" forState:UIControlStateNormal];
    }else{
        self.start_audio_6.tag=1;
        [self.audioPlayerArray[5] play];
        [self.start_audio_6 setTitle:@"暂停音频6" forState:UIControlStateNormal];
    }
}
- (IBAction)start_audio7_btn:(id)sender {
    if(self.start_audio_7.tag==1){
        self.start_audio_7.tag=0;
        [self.audioPlayerArray[6] pause];
        [self.start_audio_7 setTitle:@"开始音频7" forState:UIControlStateNormal];
    }else{
        self.start_audio_7.tag=1;
        [self.audioPlayerArray[6] play];
        [self.start_audio_7 setTitle:@"暂停音频7" forState:UIControlStateNormal];
    }
}

@end
