close all
clc

% projFolder = 'G:\My Drive\Drosophibot\AnimatLab\SingleJoint-Nick-20190910-descComm\';
% projFile = 'SingleJoint-Nick-20190910-descComm_Standalone.asim';
% animatlabFile = 'C:\AnimatLabSDK\AnimatLabPublicSource\bin\AnimatSimulator.exe';
% graphs = {'DataTool_3','DataTool_4'};
% toRunRobot = true;
% pauseDuration = 0;
% toSave = false;

projFolder = 'C:\Users\anna.sedlackova\Desktop\VN--1105\';
projFile = 'VisionNetwork1003_Standalone.asim';
animatlabFile = 'D:\AnimatLabSDK\AnimatLabPublicSource\bin\AnimatSimulator.exe';
graphs = {'DataTool_1', 'DataTool_2', 'DataTool_3', 'DataTool_4', 'DataTool_5', 'DataTool_6', 'DataTool_7', 'DataTool_8'};
toRunRobot = true;
pauseDuration = 0;
toSave = true;

[~,~,dataStruct] = fRunRobotCollectData(projFolder,projFile,animatlabFile,graphs,toRunRobot,pauseDuration,toSave);

fExtractPlotData(dataStruct);