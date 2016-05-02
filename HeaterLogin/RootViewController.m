//
//  RootViewController.m
//  HeaterLogin
//
//  Created by 刘明瑞 on 16/4/22.
//  Copyright © 2016年 lmr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"

@interface RootViewController()

@end




@implementation RootViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.pageViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource =self;
    MainViewController *mainViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[mainViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.parentViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController: (UIViewController *)viewController{
    //下一页显示什么内容
    NSUInteger index = ((MainViewController*)viewController).pageIndex;
    
    if(index == NSNotFound){
        return nil;
    }
    index++;
    if (index >= 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((SetThermometerViewController*) viewController).pageIndex;

    if((index == 0) || (index == NSNotFound)){
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
    
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    
    if (index >= 2){
        return nil;
    }
    
    if (index == 0) {
        MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainViewController.pageIndex = index;
        return mainViewController;
    }
    if (index ==1) {
        SetThermometerViewController *setThermometerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetThermometerViewController"];
        setThermometerViewController.pageIndex = index;
        return setThermometerViewController;
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    NSInteger count = 2;
    return count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 0;
}



@end