//
//  ChannelViewController.m
//  CollectionViewTest
//
//  Created by Takashi Kawakami on 2016/02/08.
//  Copyright © 2016年 Takashi Kawakami. All rights reserved.
//

#import "ChannelViewController.h"

@interface ChannelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChannelViewController

- (void)loadView
{
    [super loadView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 284, 320, 568 - 284)];
    self.view = view;
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
}

@end
