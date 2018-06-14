//
//  HeadView.m
//  TableViewInScrollView
//
//  Created by 陈文琦 on 2018/6/4.
//  Copyright © 2018年 vanch. All rights reserved.
//

#import "HeaderView.h"

static void * const kMXParallaxHeaderKVOContext = (void*)&kMXParallaxHeaderKVOContext;

@interface HeaderView ()

@property (nonatomic, strong) UILabel   *refreshView;
@property (nonatomic, strong) UIView    *headView;
@property (nonatomic, strong) UILabel   *sectionView;
@property (nonatomic, strong) UIView    *cellView;
@property (nonatomic, strong) UIButton  *sectionView2;

@property (nonatomic, assign) CGRect    lastBounds;
@property (nonatomic, assign) CGFloat   lastOffsetY;

@end

@implementation HeaderView

#pragma mark - Const
- (CGFloat)totalHeight {
    return 500;
}

- (CGFloat)minHeight {
    return 50;
}

#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _refreshView = [UILabel new];
    _refreshView.backgroundColor = self.randomColor;
    _refreshView.text = @"下拉刷新";
    _refreshView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_refreshView];
    
    _headView = [UIView new];
    _headView.backgroundColor = self.randomColor;
    [self addSubview:_headView];
    
    _cellView = [UIView new];
    _cellView.backgroundColor = self.randomColor;
    [self addSubview:_cellView];
    
    _sectionView = [UILabel new];
    _sectionView.backgroundColor = self.randomColor;
    _sectionView.text = @"区域表头";
    _sectionView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_sectionView];
    
    _sectionView2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _sectionView2.backgroundColor = self.randomColor;
    [_sectionView2 setTitle:@"切换" forState:UIControlStateNormal];
    [_sectionView2 addTarget:self action:@selector(didTapSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sectionView2];
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kMXParallaxHeaderKVOContext];
    }
}

- (void)didMoveToSuperview{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self
                         forKeyPath:NSStringFromSelector(@selector(contentOffset))
                            options:NSKeyValueObservingOptionNew
                            context:kMXParallaxHeaderKVOContext];
    }
}

#pragma mark - Layout
- (void)layoutSubviews {
    if (CGRectEqualToRect(self.bounds, _lastBounds)) {
        return;
    }
    
    _lastBounds = self.bounds;
    
    _refreshView.frame = CGRectMake(0, -50, self.bounds.size.width, 50);
    _headView.frame = CGRectMake(0, 0, self.bounds.size.width, 100);
    _sectionView.frame = CGRectMake(0, CGRectGetMaxY(_headView.frame), CGRectGetWidth(_headView.frame), 50);
    _cellView.frame = CGRectMake(0, CGRectGetMaxY(_sectionView.frame), CGRectGetWidth(_headView.frame), 300);
    _sectionView2.frame = CGRectMake(0, CGRectGetMaxY(_cellView.frame), CGRectGetWidth(_headView.frame), 50);
    
    [self layoutContentWithIfForce:NO];
}

- (void)layoutContentWithIfForce:(BOOL)isForce {
    //计算悬浮
    if (![self.superview isKindOfClass:[UIScrollView class]]) return;
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    CGFloat calculatedOffset = scrollView.contentOffset.y;
    
    //两类判断，第一种情况是重复一种offset
    //第二种情况是改变inset会立刻setContentOffset，这里拿这个避免重复
    //切换导致的刷新需要通过
    if (_lastOffsetY == calculatedOffset && !isForce) {
        return;
    }
    
    UIEdgeInsets inset = scrollView.contentInset;
    if (calculatedOffset < -self.totalHeight) {
        inset.top = self.totalHeight;
    } else if (calculatedOffset < -self.minHeight) {
        if (calculatedOffset > _lastOffsetY) {
            inset.top = -calculatedOffset;
        } else {
            inset.top = -calculatedOffset + 1;
        }
    } else {
        inset.top = self.minHeight;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, inset)) {
        scrollView.contentInset = inset;
    }
    
    //跟踪当前页的位置
    CGRect tmpFrame = self.frame;
    if (calculatedOffset < -self.minHeight) {
        tmpFrame.origin.y = -self.totalHeight;
    } else {
        tmpFrame.origin.y = calculatedOffset + self.minHeight - self.totalHeight;
    }
    self.frame = tmpFrame;
    [scrollView bringSubviewToFront:self];
    
    //记录最后一次偏移
    _lastOffsetY = calculatedOffset;
    //计算view内section的偏移
    calculatedOffset += self.totalHeight;
    if (calculatedOffset >= 100) {
        _sectionView.frame = CGRectMake(0, MIN(calculatedOffset, 400) , CGRectGetWidth(_headView.frame), 50);
    } else {
        _sectionView.frame = CGRectMake(0, CGRectGetMaxY(_headView.frame), CGRectGetWidth(_headView.frame), 50);
    }
}

#pragma mark - Action
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != kMXParallaxHeaderKVOContext) {
        return;
    }
    
    [self layoutContentWithIfForce:NO];
}

- (void)didTapSwitch {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTapSwitch" object:nil];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) {
        return;
    }
  
    BOOL isFirst = false;
    if (!_scrollView) {
        //第一次不刷新
        isFirst = true;
    }
    CGPoint lastOffset = _scrollView.contentOffset;
    _scrollView = scrollView;
   
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    //设置inset
    UIEdgeInsets inset = scrollView.contentInset;
    inset.top = self.totalHeight;
    scrollView.contentInset = inset;
    
    //设置offset
    if (isFirst) {
        CGPoint offset = self.scrollView.contentOffset;
        offset.y += inset.top - self.totalHeight;
        self.scrollView.contentOffset = offset;
    } else {
        [scrollView setContentOffset:lastOffset];
    }
    
    //添加view
    scrollView.backgroundColor = self.backgroundColor;
    [scrollView addSubview:self];
    self.frame = CGRectMake(0, - self.totalHeight, self.scrollView.frame.size.width, self.totalHeight);
    
    //刷新最新的
    [self layoutContentWithIfForce:YES];
}

#pragma mark - Extension
- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(255) / 255.0
                           green:arc4random_uniform(255) / 255.0
                            blue:arc4random_uniform(255) / 255.0
                           alpha:1];
}

@end
