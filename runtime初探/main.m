//
//  main.m
//  runtime初探
//
//  Created by zhongding on 2019/1/17.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
#import "Person.h"

#import <objc/runtime.h>

/*
 Method 的实质是一个结构体：method_t
 */
struct method_t {
    SEL name;
    const char *types;
    IMP imp;
    
//    struct SortBySELAddress :
//    public std::binary_function<const method_t&,
//    const method_t&, bool>
//    {
//        bool operator() (const method_t& lhs,
//                         const method_t& rhs)
//        { return lhs.name < rhs.name; }
//    };
};

void run(){
    NSLog(@"调用C方法");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        Dog  *dog = [Dog new];
        
        Method  m1 = class_getInstanceMethod([dog class], @selector(run));
        Method  m2 = class_getInstanceMethod([dog class], @selector(walk));

        
        //1.修改方法的实现指向c方法
        //method_setImplementation(m1, (IMP)run);
        
        //2.修改方法指向类的其他方法
        //获取walk方法的实现
        //IMP imp = method_getImplementation(m2);
        //把run的方法实现指向walk方法
       // method_setImplementation(m1, imp);
        
        //3.使用结构体修改方法的实现
        //class_getInstanceMethod：返回一个结构体，包含方法名、方法的实现、类型等信息
        struct method_t *m3  = (struct method_t *) class_getInstanceMethod([dog class], @selector(walk));
        method_setImplementation(m1, m3->imp);
        
        
        //4.修改类的指向
        //Person *p = [Person new];
        //把Dog类的对象指向Person类
        //object_setClass(dog, [p class]);
        
        [dog run];

    }
    return 0;
}
