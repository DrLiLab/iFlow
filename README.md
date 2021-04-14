# User Guide of iFlow
## 一、Build iFlow
首先进入到要存放iFlow的目录下，输入命令：
```
git clone https://github.com/PCNL-EDA/iFlow.git    //构建iFlow目录结构
cd iFlow
./build_iflow.sh      //运行脚本下载EDA工具
```
完成后即可使用iFlow。
![image](https://github.com/ll574918628/iFlow-image/blob/master/p1.png)

## 二、iFlow目录结构
### 1、foundry/
存放工艺库，按不同工艺命名，包括lef、lib、Verilog(instance仿真用)和gds等库文件。
### 2、log/
存放flow每一步产生的log，命名格式为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version.log。
### 3、report/
存放每一步输出的报告，文件夹命名格式类似为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version。
### 4、result/
存放每一步输出的结果，如$design.v，$design.def，$design.gds，文件夹命名格式为$design.$step.$tools.$track(eg. HD/uHD).$corner(eg. MAX/MIN).$version。
### 5、rtl/
存放design的rtl文件和sdc文件，按不同的design命名。
### 6、scripts/
　		├─cfg　           //库文件配置、工具配置、flow配置脚本存放目录
　		├─common　　      //对文件操作的通用脚本存放目录
　		├─ run_flow.py    //整个flow的运行脚本
　		├─ $design       //对应design每一步的脚本存放目录
### 7、tools/
存放各个工具的文件。
### 8、work/
存放跑flow过程中生成的临时文件，沿用商业工具的习惯。
### 9、build_iflow.sh
下载安装EDA工具。
### 10、README.md
iFlow使用说明。

## 三、Example
### 1、使用iFlow跑soc_asic_top设计的全流程
进入“/iFlow/scripts/”目录，输入命令：
```
run_flow.py -d soc_asic_top -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -p synth -f smic110 -t HD -c MAX -v 0.3 -l 0.3
```
（这里的版本号为0.3）,进行soc_asic_top设计的全流程running，注意log中有无Error。运行结束后，会打开klayout并显示最终design的版图，如图7所示，滚动鼠标滑轮可以缩放版图，按住“鼠标中键”可以移动版图。在图8中对“Layers”选择hide/show可以隐藏和显示对应的layer层，层数较多时加载会比较慢，可以右键选择“hide all”全部隐藏后，再逐层打开查看。
