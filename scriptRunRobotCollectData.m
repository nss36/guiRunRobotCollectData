close all
clc

% projFolder = 'G:\My Drive\Drosophibot\AnimatLab\SingleJoint-Nick-20190910-descComm\';
% projFile = 'SingleJoint-Nick-20190910-descComm_Standalone.asim';
% animatlabFile = 'C:\AnimatLabSDK\AnimatLabPublicSource\bin\AnimatSimulator.exe';
% graphs = {'DataTool_3','DataTool_4'};
% toRunRobot = true;
% pauseDuration = 0;
% toSave = false;

projFolder = 'G:\My Drive\AnimatLab\SingleJoint-Nick-20190925\';
projFile = 'SingleJoint-Nick-20190925_Standalone.asim';
animatlabFile = 'C:\AnimatLabSDK\AnimatLabPublicSource\bin\AnimatSimulator.exe';
graphs = {'DataTool_3','DataTool_4'};
toRunRobot = true;
pauseDuration = 0;
toSave = true;

[~,~,dataStruct] = fRunRobotCollectData(projFolder,projFile,animatlabFile,graphs,toRunRobot,pauseDuration,toSave);

fExtractPlotData(dataStruct);