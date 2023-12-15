
# Robust Registration Of Featureless Point Clouds  With Geometry Distance Constraint
This repository includes the source code of the paper Robust Registration Of Featureless Point Clouds With Geometry Distance Constraint.
This code was written in MATLAB.
# Introduction and Usage
This program includes three algorithms:
```
1. sparse point to point
2. sparse point to plane
3. sparse WED
4. robust symmetric
5. lifted point-to-point 
6. lifted point-to-plane 
7. lifted WED 
8. GDC-lifted-point-to-plane
9. (ours)GDC-lifted-WED
```
The directory `github_repo` is lie algebra library. 
The function 'linspecer.m' can generate distinguishable colors to plot, which can download [at](https://ww2.mathworks.cn/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap). 
The function `createns` and `knnsearch` in our source files need `Statistics and Machine Learning Toolbox` in MATLAB.

We share our simulation and real data in registration.
Simulation data include turbine blade  and cylinder surface stored in `bladeData` and `cylinderData`
Real data include outlet guide vane  and engine rotor stored in `OGVdata` and `RotorData`


![real experiments scene](https://github.com/Timbersaw-wangzw/GDC_Lifted_WED/blob/main/realScene.png)

You can run directly `simulationICP.m` and `realICP.m` about simulation and real experiments.
There are some registration results shown below  



![experiments results](https://github.com/Timbersaw-wangzw/GDC_Lifted_WED/blob/main/results.png)
