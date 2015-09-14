# CustomAnnotationCalloutView
##教程篇
##包括系统方法和完全自定义的方法<br>
* 系统方法<br>
    * 系统的方法使通过leftCalloutAccessoryView和rightCalloutAccessoryView来自定义；<br>
     *  缺点很显然：<br>
      *            1、不能设置弹出窗的背景颜色
      *            2、不能设置主标题和副标题的字体大小和颜色
      *            3、只能设置两行标题<br>
* 完全自定义<br>
  * 原理：与其说是自定义气泡视图不如说是两种样式大头针的切换<br>
     * 1、首先我们需要一个全局的大头针类型是我们自定义好的那个，这个大头针的坐标要保持和我们点击项的坐标是一致的<br>
     * 2、一开始都是基本大头针当我们点击的时候，若果没有自定义大头针就创建一个并赋值坐标系;
         如果我们点击的存在大头针但是点击的不是自定义类型的大头针，需要把全局的大头针的坐标系换成我们点击的大头针的坐标系，造成一个假象好像使我们的弹出气泡;
         如果存在自定义大头针并且我们点击也是自定义类型的大头针这时候需要移除自定义大头针<br>
     * 3、基本原理就是这样目前还是没有找到能够直接改变弹出视图的方案 如果有的话我再补充<br>
     
##下面我们来看一下效果<br>
![image](https://github.com/mokey1422/gifResourceOther/blob/master/calloutView.gif)
