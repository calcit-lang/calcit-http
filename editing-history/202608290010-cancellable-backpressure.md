# HTTP 可取消背压 / Cancellable HTTP backpressure

## 中文

- 升级已发布的 `calcit_native_ffi 0.1.3`，普通 request `emit` 读取 `ServerControl.cancelled`。
- 取消期间的 closing/finished 作为正常 shutdown，terminal 继续独立发布并清理 response capabilities。

## English

- Upgrade to the published `calcit_native_ffi 0.1.3` and connect ordinary request `emit` delivery to `ServerControl.cancelled`.
- Treat closing/finished during cancellation as normal shutdown while publishing terminal events independently to clean up response capabilities.
