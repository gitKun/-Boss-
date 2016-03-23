//
//  BossViewController.m
//  仿BOSS直聘的刷新
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "BossViewController.h"
#import "MJRefresh.h"
#import "BossHeaderView.h"

@interface BossViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.mj_header = [BossHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData {
    // 1.添加假数据
    
#warning message ==== 注意这里会造成强引用 MJRefresh 中给出的代码也同样会造成强引用
    __weak typeof(self) weakSelf = self;
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    //修改为长时间加载可以看出 控制器被强引用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endRefresh];
    });
}
- (void)endRefresh {
    // 刷新表格
    [self.tableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
}

#pragma mark ==== TableViewDelegate  &&  UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @"下拉刷新"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
