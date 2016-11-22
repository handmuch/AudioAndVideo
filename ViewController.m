//
//  ViewController.m
//  AudioAndvideo_Demo
//
//  Created by POWER on 16/11/16.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "ViewController.h"

//controller
#import "AudioPlayViewController.h"
#import "MPMediaPlayViewController.h"
#import "AudioRecorderViewController.h"

//common
#import "soundEffectPlay.h"
#import "AudioStreamer.h"

#define Music_Name @"Say You Love Me.mp3"

@interface ViewController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    self.title = @"iOS多媒体";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initView
{
    _titleArray = @[@"AudioToolbox", @"AudioPlayer",@"MPMediaPlayer(disable)", @"AudioRecorder",@"AudioStreamer"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //AudioToolBox
    if (indexPath.row == 0) {
        [[soundEffectPlay shareInstance]playSoundEffect:@"airlock_door_open_old.wav" AndCompletion:^{
            NSLog(@"播放完成");
        }];
    }
    else if (indexPath.row == 1)
    {
        AudioPlayViewController *audioPlayCtr = [[AudioPlayViewController alloc]init];
        [self.navigationController pushViewController:audioPlayCtr animated:YES];
    }
    else if (indexPath.row == 2)
    {
        MPMediaPlayViewController *mpMediaPlay = [[MPMediaPlayViewController alloc]init];
        [self.navigationController pushViewController:mpMediaPlay animated:YES];
    }
    else if (indexPath.row == 3)
    {
        AudioRecorderViewController *recorderCtr = [[AudioRecorderViewController alloc]init];
        [self.navigationController pushViewController:recorderCtr animated:YES];
    }
    else if (indexPath.row == 4)
    {
        //本地音乐
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:Music_Name ofType:nil];
//        [[AudioStreamer shareInstance]streamerPlayWithUrl:[NSURL fileURLWithPath:filePath]];
        
        //网络音乐
        [[AudioStreamer shareInstance]streamerPlayWithUrl:[NSURL URLWithString:@"http://wailian.ik6.com/up/20150413/18/20150413184553_27366.mp3"]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
