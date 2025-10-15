//
//  CNLiveTaskListTableViewCell.m
//  CNLiveCollectionModule
//
//  Created by CNLiveLive-zxw on 2019/2/26.
//  Copyright © 2019年 CNLivelive. All rights reserved.
//

#import "CNLiveCollectionCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "QMUIKit.h"
#import "CNLiveCategory.h"
#import "CNLiveBaseKit.h"

#import "CNLiveCollectionModel.h"

@interface CNLiveCollectionCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *playerBtn;

@end

@implementation CNLiveCollectionCell
static const NSInteger margin = 10;

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.leftImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.playerBtn];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:longPress];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(margin);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0);
        make.left.equalTo(self.contentView.mas_left).with.offset(margin);
        make.right.equalTo(self.contentView.mas_right).with.offset(-margin);
        
    }];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).with.offset(margin);
        make.left.equalTo(_bgView.mas_left).with.offset(margin);
        make.width.offset(120);
        make.height.offset(130);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImage.mas_top);
        make.left.equalTo(_leftImage.mas_right).with.offset(margin);
        make.right.equalTo(self.contentView.mas_right).with.offset(-margin);
        make.bottom.equalTo(_leftImage.mas_bottom).with.offset(0);

    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImage.mas_bottom).with.offset(0);
        make.left.equalTo(self.leftImage.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0);
        make.right.equalTo(self.leftImage.mas_right);

    }];
    
    [_playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftImage.mas_centerX);
        make.centerY.equalTo(_leftImage.mas_centerY);
        make.width.height.offset(50);
    }];
    
}

#pragma mark - Data
- (void)setModel:(CNLiveCollectionModel *)model{
    _model = model;
    [_leftImage sd_setImageWithURL:model.imageUrl placeholderImage:nil];
     
    _titleLabel.attributedText = model.title;

    _timeLabel.text = model.nameTime;
    
    _playerBtn.hidden = [model.videoId isEqualToString:@""];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 响应方法
- (void)playerDidClicked:(UIButton *)btn{
    
}

#pragma mark - 长按手势
- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    //直接return掉，不在开始的状态里面添加任何操作，则长按手势就会被少调用一次了
    if(gesture.state != UIGestureRecognizerStateBegan){
      return;
    }
    __weak typeof(self) weakSelf = self;
    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"取消收藏" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        [strongSelf cancelCollection];
     }];
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
      }];
           
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action];
    [alertController addAction:cancel];

    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
           
    titleAttributs[NSForegroundColorAttributeName] = [UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0];
    
    NSMutableDictionary *cancelAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
    cancelAttributs[NSForegroundColorAttributeName] = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    action.buttonAttributes = titleAttributs;
    cancel.buttonAttributes = cancelAttributs;

    [alertController showWithAnimated:YES];
}

#pragma mark - 取消收藏方法
- (void)cancelCollection{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelCollection:)]) {
        [self.delegate cancelCollection:self];//滑动响应实现
    }
}


#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.exclusiveTouch = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}
- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
        _leftImage.userInteractionEnabled = YES;
        _leftImage.contentMode = UIViewContentModeScaleAspectFill;
        _leftImage.layer.masksToBounds = YES;
    }
    return _leftImage;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
        _titleLabel.font = UIFontCNMake(16);
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
        _timeLabel.font = UIFontCNMake(13);
        _timeLabel.userInteractionEnabled = YES;
    }
    return _timeLabel;
}
- (UIButton *)playerBtn {
    if (!_playerBtn) {
        _playerBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _playerBtn.adjustsImageWhenHighlighted = NO;
        UIImage *image = [self getImageWithImageName:@"collection_white_play" bundleName:@"CNLiveCollectionModule" targetClass:[self class]];
        [_playerBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_playerBtn addTarget:self action:@selector(playerDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerBtn;
}

@end
