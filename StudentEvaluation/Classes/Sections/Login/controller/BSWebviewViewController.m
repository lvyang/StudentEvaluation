//
//  BSWebviewViewController.m
//  Pods
//
//  Created by admin zheng on 2017/4/20.
//
//

#import "BSWebviewViewController.h"
#import "NJKWebViewProgressView.h"
#import "BSLoginViewController.h"

static NSString *completeRPCURLPath = @"/njkwebviewprogressproxy/complete";
const float NJKInitialProgressValue = 0.1f;
const float NJKInteractiveProgressValue = 0.5f;
const float NJKFinalProgressValue = 0.9f;

@interface BSWebviewViewController ()<UIWebViewDelegate>

//URL
@property (nonatomic, copy) NSString *urlStr;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;

@property (weak, nonatomic) IBOutlet UILabel *viewTopLabel;

@property (nonatomic, readonly) float progress; // 0.0..1.0
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) NSUInteger loadingCount;
@property (nonatomic, assign) NSUInteger maxLoadCount;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, strong) NSURL *currentUrl;


@end

@implementation BSWebviewViewController

- (id)initWithURLStr:(NSString *)urlStr
{
    if (self = [super initWithNibName:@"BSWebviewViewController" bundle:nil]) {
        _urlStr = urlStr;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];

    _interactive = NO;
    _maxLoadCount =0;
    _loadingCount = 0;

    [self setContent];
    
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    if (self.title) {
        self.viewTopLabel.text = self.title;
    }
    if (self.naviBarColor) {
        self.navigationBar.backgroundColor = self.naviBarColor;
    }
    
    //设置进度条
    UIView *navigationBar = self.navigationController ? self.navigationController.navigationBar : self.navigationBar;
    CGRect navigationBarBounds = navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - 3, self.view.frame.size.width, 3);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [navigationBar addSubview:_progressView];
    [self completeProgress];
    
    [self loadFromUrlString:self.urlStr];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)setContent
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:105 / 255.0 green:105 / 255.0 blue:105 / 255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:1];
}

- (void)back:(id)sender
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setViewLabelTitle:(NSString *)title
{
    self.title = title;
}

-(IBAction)pop:(id)sender
{
    [self back:nil];
}

#pragma mark - loading progress
- (void)startProgress
{
    if (_progress < NJKInitialProgressValue) {
        [self setProgress:NJKInitialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? NJKFinalProgressValue : NJKInteractiveProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        [_progressView setProgress:progress animated:YES];
    }
}

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark - public
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    
    [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)loadFromUrl:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)loadFromUrlString:(NSString *)urlString
{
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadFromUrl:url];
}

#pragma mark - UIWebViewDelegate
/** @override */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.path isEqualToString:completeRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    if ([request.URL.relativePath.lowercaseString isEqualToString:@"/wap/login/login"]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[BSLoginViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return NO;
            }
        }
        
        NSMutableArray *controllers = self.navigationController.viewControllers.mutableCopy;
        [controllers removeLastObject];
        BSLoginViewController *vc = [[BSLoginViewController alloc] initWithNibName:NSStringFromClass([BSLoginViewController class]) bundle:nil];
        [controllers addObject:vc];
        [self.navigationController setViewControllers:controllers animated:YES];
        return NO;
    }
    
    BOOL ret = YES;
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentUrl = request.URL;
        [self reset];
    }
    
    return ret;
}

/** @override */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

/** @override */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentUrl && [_currentUrl isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

/** @override */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentUrl && [_currentUrl isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ((complete && isNotRedirect) || error) {
        [self completeProgress];
    }
}

@end
