# CE-planner native/isolated candidate runtime mode

完整安装、运行与测试说明见：[docs/修改说明与测试报告.md](docs/修改说明与测试报告.md)。

快速应用：

```bash
python3 tools/apply_candidate_runtime_mode.py --repo .
./build
```

默认使用 `native`；设置 `IGC_CANDIDATE_RUNTIME_MODE=isolated` 可完整恢复原有每轮隔离调试流程。
