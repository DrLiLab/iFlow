# User Guide of iFlow
## Build iFlow
首先进入到要存放iFlow的目录下，输入命令：
```
git clone https://github.com/PCNL-EDA/iFlow.git    //构建iFlow目录结构
cd iFlow
./build_iflow.sh      //运行脚本下载EDA工具
```
完成后即可使用iFlow。

## iFlow目录结构
### 1、foundry/
存放工艺库，按不同工艺命名，包括lef、lib、Verilog(instance仿真用)和gds等库文件。
