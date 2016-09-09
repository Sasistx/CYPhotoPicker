# CYPhotoPicker
CYPhotoPicker

iOS 相册预览，图片预览控件。提供方便的从相册，或读取本地，远程图片功能。同时支持在iOS8及以上系统，从用户iCloud中读取照片功能。

##使用方式：
###CYPhotoPicker.h

```objc
@interface CYPhotoPicker : NSObject

/**
 *  按钮背景颜色
 */
@property (nonatomic, strong, nullable) UIColor* buttonBackgroundColor;

/**
 *  按钮文字颜色
 */
@property (nonatomic, strong, nullable) UIColor* sendButtonTextColor;

/**
 *  是否包含预览页面
 */
@property (nonatomic, getter=isShowPreview) BOOL showPreview;

/**
 *  相册多选时的最大照片数量,default = 8;
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 *  pickerOption
 */
@property (nonatomic, assign) PhotoPickerOption pickerOption;

/**
 *  返回按钮样式
 */
@property (nonatomic, assign) PhotoNaviButtonStyle naviStyle;

/**
 *  拍照后保存至相册的相册名
 */
@property (nonatomic, copy, nullable) NSString* albumName;


/**
 *  发送按钮文案，默认为发送
 */
@property (nonatomic, copy, nullable) NSString* sendButtonTitle;

/**
 *  CYPicker初始化方法
 *
 *  @param controller    当前controller
 *  @param option        所展示的相册选项，目前支持，PhotoPickerOptionAlbum，PhotoPickerOptionCamera，PhotoPickerOptionAlbum | PhotoPickerOptionCamera 3种
 *  @param showPreview   相册选择是否展示预览
 *  @param dissmissBlock 选择回掉方法
 *
 *  @return CYPicker
 */
+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock;

/**
 *  将相册或相机从当前controller展示的方法
 */
- (void)show;

/**
 *  CYPicker 网络图片预览方法
 *
 *  @param controller 当前controller
 *  @param imageList  图片数组<PhotoNetworkItem * >
 *  @param index      当前位置
 *
 *  @return CYPicker
 */
+ (instancetype _Nullable)showFromeController:(UIViewController* _Nonnull)controller imageList:(NSArray<PhotoNetworkItem * > * _Nonnull)imageList currentIndex:(NSInteger)index;

/**
 *  设置预选择的图片
 *
 *  @param items items中的元素必须为PhotoListItem或者PhotoBaseListItem类型
 */
- (void)setSelectedPhotoItem:(nonnull NSArray*)items;


#pragma mark -
#pragma mark - deprecated
+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock
    __deprecated_msg("Use 'showFromController:option:showPreview:ompeletionBlock:'");

@end
```

###PhotoConfigureManager.h
```objc
@interface PhotoConfigureManager : NSObject

@property (nonatomic, strong) UIColor* buttonBackgroundColor; //default is white
@property (nonatomic, strong) UIColor* sendButtontextColor; //default is black

@property (nonatomic, assign) PhotoNaviButtonStyle naviStyle;
@property (nonatomic, strong) CYPhotoPicker* currentPicker;

@property (nonatomic, copy) NSString* sendButtonTitle;

/**
 *  CYPhotoPicker预设方法，必须在Appdelegate中进行预设
 *
 *  @param buttonBackgourndColor 按钮背景色
 *  @param buttonTextColor       文字颜色
 */
+ (void)preConfigureWithButtonBackgourndColor:(UIColor*)buttonBackgourndColor buttonTextColor:(UIColor*)buttonTextColor;

+ (PhotoConfigureManager*)sharedManager;

- (void)clearColor;

@end
```


