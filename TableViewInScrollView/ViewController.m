//
//  ViewController.m
//  TableViewInScrollView
//
//  Created by 陈文琦 on 2018/6/4.
//  Copyright © 2018年 vanch. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HeaderView        *headerView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIWebView         *webView;

@property (nonatomic, assign) BOOL              nowIsTable;

@end

@implementation ViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"嵌套";
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self switchModule];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchModule) name:@"kTapSwitch" object:nil];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.height - self.view.safeAreaInsets.top);
    self.webView.frame = self.tableView.frame;
}

#pragma mark - Lazy Creator
- (HeaderView *)headerView {
    if (!_headerView) {
        _headerView = [HeaderView new];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [UIWebView new];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    }
    return _webView;
}

#pragma mark - Action
- (void)switchModule {
    if (_nowIsTable) {
        self.headerView.scrollView = self.webView.scrollView;
        if (self.tableView.superview) {
            [self.tableView removeFromSuperview];
        }
        [self.view addSubview:self.webView];
    } else {
        self.headerView.scrollView = self.tableView;
        if (self.webView.superview) {
            [self.webView removeFromSuperview];
        }
        [self.view addSubview:self.tableView];
    }
    
    _nowIsTable = !_nowIsTable;
    
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"First";
    } else {
        return @"Second";
    }
}

@end
