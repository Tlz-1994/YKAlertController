# YKAlertController
弹出框alert的写法,大家可以参考这个示例项目写出自己喜欢的弹出框样式，码砖块的过程中少踩一些坑。
```
    YKAlertController *alertController = [YKAlertController alertControllerWithTitle:@"弹出来吧" message:@"具体的弹出样式和动画可以参考考'YKAlertController.m'文件的写法"];
    [alertController addActionWithTitle:@"取消" clickHandle:nil];
    [alertController addActionWithTitle:@"按钮1" clickHandle:^{
        
    }];
    [alertController addActionWithTitle:@"按钮2" clickHandle:^{
        
    }];
    [alertController showWithAnimated:YES];

 ```
<div style={display: flex}>
<img src="http://7xsim2.com1.z0.glb.clouddn.com/2017-06-29%2013_44_48.gif" width = 200px />
</div>
