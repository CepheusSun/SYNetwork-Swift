# SYNetwork-Swift

简单的网络框架。 基于 Swift4.0。 支持按照接口缓存请求结果。
请求结果通过 RxSwift 回调回来。依然是离散型的请求方式。膜拜 casa

主要是为了学习 Swift 简单的根据以前用 OC 写的 SYNetwork 写了一个 Swift 版本的东东, 并且添加了将数据存在沙盒的 feature. 使用就没什么好说的了。只需要将你的 ViewModel 继承 Request 这个 protocol 然后实现必要的方法就 ok. 然后为了省事儿, 将 SYService 之类的东西全部移除，通过 request 的继承来解决这种问题。


