# User Guide of iFlow
## 一、Build iFlow
首先进入到要存放iFlow的目录下，输入命令：
```
git clone https://github.com/PCNL-EDA/iFlow.git    //构建iFlow目录结构
cd iFlow
./build_iflow.sh      //运行脚本下载EDA工具
```
完成后即可使用iFlow。

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

## 三、iFlow command
### Eg.
```
run_flow.py -d aes_cipher_top -s synth -f sky130 -t HS -c TYP
```
**命令参数：**

**-d (design)：**

design name；

**-s (step)：**

flow可选step：synth、floorplan、tapcell、pdn、gplace、resize、dplace、cts、filler、groute、droute、layout；

**-p (previous step)：**

用于调用前一步的结果；

**-f (foundry)：**

工艺选择，可选：sky130；

**-t (track)：**

标准单元track选择，可选：sky130[HS HD]；

**-c (corner)：**

工艺角，可选：sky130 [TYP]；

**-v (version)：**

追加到log/result rpt的版本号；

**-l ：**

前一步的版本号。


**step command：**

synth：
```
run_flow.py -d $design -s synth -f $foundry -t $track -c $corner 
```
floorplan：
```
run_flow.py -d $design -s floorplan -f $foundry -t $track -c $corner
```
tapcell：
```
run_flow.py -d $design -s tapcell -f $foundry -t $track -c $corner
```
pdn：
```
run_flow.py -d $design -s pdn -f $foundry -t $track -c $corner
```
gplace：
```
run_flow.py -d $design -s gplace -f $foundry -t $track -c $corner
```
resize：
```
run_flow.py -d $design -s resize -f $foundry -t $track -c $corner
```
dplace：
```
run_flow.py -d $design -s dplace -f $foundry -t $track -c $corner
```
cts：
```
run_flow.py -d $design -s cts -f $foundry -t $track -c $corner
```
filler：
```
run_flow.py -d $design -s filler -f $foundry -t $track -c $corner 
```
groute：
```
run_flow.py -d $design -s groute -f $foundry -t $track -c $corner
```
droute：
```
run_flow.py -d $design -s droute -f $foundry -t $track -c $corner
```
layout：
```
run_flow.py -d $design -s layout -f $foundry -t $track -c $corner
```

## 四、Example
### 1、使用iFlow跑soc_asic_top设计的全流程
进入“/iFlow/scripts/”目录，输入命令：
```
./run_flow.py -d aes_cipher_top -s synth,floorplan,tapcell,pdn,gplace,resize,dplace,cts,filler,groute,droute,layout -f sky130 -t HS -c TYP -v 1.0 -l 1.0
```
（这里的版本号为1.0）,进行aes_cipher_top设计的全流程running，注意log中有无Error。运行结束后，会打开klayout并显示最终design的版图，如图1所示，滚动鼠标滑轮可以缩放版图，按住“鼠标中键”可以移动版图。在图2中对“Layers”选择hide/show可以隐藏和显示对应的layer层，层数较多时加载会比较慢，可以右键选择“hide all”全部隐藏后，再逐层打开查看。

图1：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p1-1.png)

图2：   

![image](https://github.com/ll574918628/iFlow-image/blob/master/p2-1.png)

Klayout支持直接打开def文件，gds载入比较慢，可以直接用klayout打开def文件。输入命令“klayout”打开klayout的GUI，在菜单“File/Import”的子菜单中找到导入功能，选择DEF/LEF导入def文件以及lef文件。如图3所示，在弹窗的“Import File”中选择detail route生成的def文件导入，在“With LEF files:”中添加design中用到的lef文件，在“/iFlow/foundry/sky130/lef/中可以找到”，添加完毕后点“OK”即可导入。产生的结果如图4所示，由于def中没有merge “std cell”和“marcro”的gds文件，因此只有metal层和via，看不到底层的NW、CT、GT等，“std cell”和“marcro”的内部结构是固定的，直接调用，一般我们只关心布线结果，所以这里看def的结果足矣。

图3：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p3-1.png)


图4：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p4-1.png)

### 2、输出的结果
每一步的结果将输出到“/iFlow/result”目录下，如图5所示。

synth：RTL综合，生成综合后的网表文件；

floorplan：布局规划，生成描述物理位置关系的def和更新网表文件；

tapcell：插入physical cell，生成描述物理位置关系的def和更新网表文件；

pdn：构建电源网络，生成描述物理位置关系的def和更新网表文件；

gplace：放置标准单元，生成描述物理位置关系的def和更新网表文件；

resize：优化标准单元的尺寸，生成描述物理位置关系的def和更新网表文件；

dplace：优化标准单元的摆放，消除overflow，生成描述物理位置关系的def和更新网表文件；

cts：构建时钟树，生成描述物理位置关系的def和更新网表文件；

filler：插入filler cell，生成描述物理位置关系的def和更新网表文件；

groute：为detail rout生成引导guide文件，生成描述物理位置关系的def和更新网表文件；

droute：根据guide文件进行布线，生成描述物理位置关系的def和更新网表文件；

layout：生成gds文件。

图5：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p5-1.png)

### 3、输出的报告
每一步输出的报告可以在“/iFlow/report/”目录下查看，例如，进入“/iFlow/report/aes_cipher_top.floorplan.openroad_1.1.0.HS.TYP.1.0”目录下，查看floorplan生成的报告“init.rpt”，如图6所示，可以得到floorplan后的wns、tns以及utilization等参数。

图6：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p6-1.png)

### 4、查看某一步的结果
为了验证某一步的结果是否满足我们的要求，可以对单步的结果进行检查。例如，我们可以查看detail place之后的结果。和前面提过的步骤一样，打开klayout，在“Import File”中导入dplace结果中的def文件，如图7所示。

图7：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p7-1.png)

点击“OK”后，可以先在“Layers”选择“hide all”，再双击打开“OUTLINE”层，即可看到detail place后的结果（这里金属层为电源网络，隐藏金属层可以方便我们查看detail place的结果），如图8所示。同样的方法可以查看其他步的结果。

图8：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p8-1.png)

## 五、更换库、设计、工具
### 1、数据的定义
“/iFlow/scripts/cfg”目录下，“data_def.py”脚本定义了iFlow使用的三个主要数据：Foundry、Tools、Flow，如图9所示，定义了每一步使用的默认工具。

图9：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p9.png)

### 2、更换工艺库
在“/iFlow/scripts/cfg”目录下，“foundry_cfg.py”脚本配置flow需要用到的工艺库文件（lib、lef、gds），如图10和图11所示，当需要更换工艺库时，可以在此脚本中添加配置即可。

图10：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p10-1.png)

图11：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p11-1.png)

### 3、更换设计RTL
进入到“/iFlow/scripts/”目录下，创建相应design的脚本文件目录，将“aes_cipher_top”文件夹中“synth.yosys_0.9.tcl”脚本拷贝到新的design目录下，修改“synth.yosys_0.9.tcl”脚本中的RTL配置即可，如图12所示，更换design的Verilog文件。

图12：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p12-1.png)

### 4、更换工具
在“/iFlow/scripts/cfg”目录下，“tools_cfg.py”脚本中配置了每一步可以使用的工具及其所在路径，如图13所示。当要更换工具或者更换新版本工具时，增加新的工具的定义即可。

图13：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p13.png)

## 六、Flow脚本说明
主要说明“run_flow.py”这个脚本每一步大概作用，
### 1、参数的解析和验证
开头部分为参数的解析和验证，如图14所示，这里定义了“run_flow.py”这个脚本运行时需要的参数，包括：“design、step、prestep、foundry、track、corner、version、preversion”。输入命令：
```
run_flow.py -h
```
可以得到可选参数的具体说明，如图15所示，当需要跑aes_cipher_top的综合时，我们可以输入命令:
```
./run_flow.py -d aes_cipher_top -s synth -f sky130 -t HS -c TYP -v 1.0
```
生成的log、report和result也会以相应的参数命名，如：“aes_cipher_top.synth.yosys_0.9.HS.TYP.1.0.log”。

·当需要同时跑多步时，可以以逗号“，”分隔，如同时跑synth和floorplan时，可以输入命令：
```
./run_flow.py -d aes_cipher_top -s synth,floorplan -f sky130 -t HS -c TYP -v 1.0
```
·当需要指定使用工具openroad_0.9.0进行floorplan时（默认使用openroad_1.1.0），可以输入命令：
```
./run_flow.py -d aes_cipher_top -s floorplan=openroad_0.9.0
```

图14：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p14.png)

图15：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p15-1.png)

### 2、设置环境变量和创建路径
如图16所示，这里主要设置环境变量以及创建相应的工作路径、结果输出的的路径以及库文件所在路径。

图16：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p16.png)

### 3、预处理文件
如图17所示，由于yosys中的abc工具只能读一个.lib文件，因此在使用yosys要先执行mergeLib.pl脚本，将所有用到的.lib文件合并为一个.lib文件“merged.lib”。同样的，TritonRoute工具也只能读入一个.lef文件，需要将所用到的.lef文件合并为一个.lef文件“merged_spacing.lef”。

图17：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p17.png)

### 4、逐步运行
如图18所示，根据不同的“step”运行不同的工具以及脚本，Openroad中不包含detailroute和看版图的工具，detailroute使用TritonRoute工具，看版图使用klayout工具。

图18：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p18-1.png)

### 5、后处理
每一步跑完后更新变量“prestep_sel”和“pre_tool_name”，如图19所示。

图19：

![image](https://github.com/ll574918628/iFlow-image/blob/master/p19.png)
