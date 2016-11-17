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

//common
#import "soundEffectPlay.h"

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
    _titleArray = @[@"AudioToolbox", @"AudioPlayer"];
    
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
    
    //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
