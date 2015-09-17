//
//  KHSegmentControl.m
//  GroomsMan
//
//  Created by Ken Huang on 2015-07-16.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "KHSegmentControl.h"
#import "Masonry.h"
#import "UIColor+GroomsMen.h"

@interface KHSegmentControl ()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UIView *selectedRect;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation KHSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        self.labels = [[NSMutableArray alloc] init];
        [self setupLabels];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor greyBlue];
    self.labels = [[NSMutableArray alloc] init];
    self.segmentTitles = @[@"all", @"private", @"public", @"drafts"];
    [self setupLabels];
    [self setupSelectedRect];
    
}

- (void)setupSelectedRect
{
    self.selectedRect = [UIView new];
    self.selectedRect.layer.cornerRadius = 5.0f;
    self.selectedRect.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectedRect.layer.borderWidth = 3.0f;
    self.selectedRect.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectedRect];
    [self bringSubviewToFront:self.selectedRect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat width = CGRectGetWidth(frame) / self.labels.count;
    CGFloat height = CGRectGetHeight(frame);
    frame.size.width = width * 0.8;
    frame.size.height = height * 0.8;
    frame.origin.x += width * 0.1;
    frame.origin.y += height * 0.1;
    self.selectedRect.frame = frame;
    [self animatedToNewSelectedIndex];
}

- (void)setupLabels
{
    for (int i = 0; i < self.segmentTitles.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 40)];
        label.text = self.segmentTitles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    [self setupLabelConstrants:self.labels inView:self];
}

- (void)setupLabelConstrants:(NSArray *)labels inView:(UIView *)view
{
    for (int i = 0; i < labels.count; i++)
    {
        UILabel *label = labels[i];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top);
            make.bottom.equalTo(view.mas_bottom);
            make.width.equalTo(view.mas_width).dividedBy(labels.count);
            if (i == 0)
            {
                make.left.equalTo(view.mas_left);
            } else {
                UILabel *leftLabel = labels[i - 1];
                make.left.equalTo(leftLabel.mas_right);
            }
        }];
    }
}

- (void)animatedToNewSelectedIndex
{
    UILabel *label = self.labels[_selectedIndex];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:0 animations:^{
//        self.selectedRect.frame = label.frame;
        CGRect frame = label.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        frame.size.width = width * 0.8;
        frame.size.height = height * 0.8;
        frame.origin.x += width * 0.1;
        frame.origin.y += height * 0.1;
        self.selectedRect.frame = frame;
    } completion:nil];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    
    __block NSInteger index = -1;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(obj.frame, location)){
            index = idx;
        }
    }];
    
    if (index != -1)
    {
        self.selectedIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return NO;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self animatedToNewSelectedIndex];
}

@end
