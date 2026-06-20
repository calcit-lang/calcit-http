## http 开发说明

### 关键步骤

1. **升级依赖版本**
   - 在 `Cargo.toml` 中保持与当前 Calcit 运行时兼容：
     - `cirru_edn = "0.7.7"`
     - `cirru_parser = "0.2.8"`
   - 当前工程使用 `edition = "2024"`。

2. **保持 FFI 导出接口完整**
   - 所有导出函数使用 `#[unsafe(no_mangle)]`。
   - 至少导出以下函数：
     - `abi_version() -> String`
     - `edn_version() -> String`
   - `edn_version()` 需要返回：
     - `cirru_edn::version().to_string()`

3. **服务端函数签名**
   - Calcit 侧通过 `&call-dylib-edn-fn` 调用 Rust 导出函数。
   - Rust 侧导出函数保持形如：
     - `pub fn serve_http(args: Vec<Edn>, handler: Arc<dyn Fn(Vec<Edn>) -> Result<Edn, String> + Send + Sync + 'static>, finish: Box<dyn FnOnce() + Send + Sync + 'static>) -> Result<Edn, String>`
   - 请求数据通过单个 EDN map 传给回调，回调返回响应 map。

4. **请求与响应约定**
   - 请求 map 典型字段：
     - `:method`
     - `:url`
     - `:path`
     - `:querystring`
     - `:query`
     - `:headers`
     - 非 GET 请求下可带 `:body`
   - 响应 map 典型字段：
     - `:code`
     - `:headers`
     - `:body`

5. **构建动态库**
   - 在项目根目录执行：
     - `cargo build --release`
   - 产物位于 `target/release/`。

6. **刷新运行时 dylib 文件**
   - 清理并复制产物到 `dylibs/`：
     - `rm -rf dylibs/*`
     - `mkdir -p dylibs`
     - `cp target/release/*.* dylibs/`
   - Calcit 示例默认从 `dylibs/libcalcit_http` 加载动态库。

7. **运行 Calcit 示例验证**
   - 执行：
     - `cr compact.cirru`
   - 当前预期输出应包含：
     - `%%%% test for lib`
     - `No tests...`
   - 如需测试服务端入口，执行：
     - `cr compact.cirru --entry server`
   - 这是一个常驻服务，启动后可用 `curl` 验证，例如请求 `http://127.0.0.1:4000/`，确认返回内容与响应头符合预期。

### 修改时的检查清单

- 修改导出函数后，先确认 Rust 侧可以成功编译。
- 如果运行 `cr compact.cirru` 或 `cr compact.cirru --entry server` 报 `dlsym failed`：
  - 先检查是否漏导出了 `edn_version`
  - 再检查 `#[unsafe(no_mangle)]` 是否遗漏
  - 再确认 `dylibs/` 中已复制最新产物
- 如果测试的是 `server` entry，记得在服务启动后额外用 `curl` 请求一次，避免只确认“进程启动”而遗漏请求处理逻辑。
- 如果只更新了 `target/release/` 但没有同步到 `dylibs/`，Calcit 仍会加载旧库。

### 推荐验证流程

按顺序执行：

1. 修改 `Cargo.toml` / `src/lib.rs`
2. `cargo build --release`
3. 复制 `target/release/*.*` 到 `dylibs/`
4. `cr compact.cirru`
5. 需要时执行 `cr compact.cirru --entry server`
6. 服务启动后用 `curl http://127.0.0.1:4000/` 验证请求和响应是否正常

### 当前已验证状态

- 依赖版本已升级到 `cirru_edn 0.7.7`、`cirru_parser 0.2.8`
- FFI 已补充 `edn_version()`
- Rust 2024 下导出属性已切换为 `#[unsafe(no_mangle)]`
- 项目已切换到 `compact.cirru + deps.cirru` 工作流
