function [status,message,dataStruct] = fRunRobotCollectData(projFolder,projFile,animatlabFile,graphs,toRunRobot,isRobot,pauseDuration,toSave)

    disp(['Pausing for ',num2str(pauseDuration),' seconds.']);
    
    if toRunRobot
        pause(pauseDuration);
    end

    disp('Running.')

    standaloneFile = [projFolder,projFile];

    command = ['"',animatlabFile,'" "',standaloneFile,'"'];
    if toRunRobot
        [status,message] = system(command,'-echo');
        disp(status)
        disp(message)
    else
        status = -1;
        message = 'Plots only.';
        fprintf('\n*** Not running a new simulation; only reading data from a previous trial.***\n')
    end

    %%

%     if toRunRobot
%         pause(5);
%     end
    
    nGraphs = length(graphs);
    timeCell = cell(nGraphs,1);
    tmax = NaN(nGraphs,1);
    dt = NaN(nGraphs,1);
    columnStart = ones(nGraphs,1);
    
    i = 1; %only increment i if the specified graph is found.
    j = 1; %increment j no matter what.
    while i <= nGraphs
        thisLoopGraph = graphs{j};
        textFile = [projFolder,thisLoopGraph,'.txt'];
        readThisGraph = true;

        try dataFile(i) = importdata(textFile); %#ok<*AGROW>
        catch
            tempGraph = strrep(thisLoopGraph,'_',' ');
            textFile = [projFolder,tempGraph,'.txt'];
            warning(['File ',thisLoopGraph,' not found. Trying ',tempGraph,' instead.'])
            try dataFile(i) = importdata(textFile);
            catch
                warning(['File ',tempGraph,' not found either. Giving up on File "',thisLoopGraph,'".'])
                
                readThisGraph = false;
            end
        end   

        if readThisGraph
            columnStart(i) = find(strcmp(dataFile(i).colheaders,'Time')); 
            if size(dataFile(i).data,2) == 1
                error('Column headers for line charts must not be numerals only.');
            end
            timeCell{i} = dataFile(i).data(:,columnStart(i));
            dt(i) = mean(diff(timeCell{i}));
            tmax(i) = timeCell{i}(end);
            
            i = i + 1;
        else
            nGraphs = nGraphs - 1;
        end
        j = j + 1;
    end
    
    delete([projFolder,'*.txt'])
    
    %Find the "one true time vector," at which we will sample all of the
    %data.
    timeVec = (0:min(dt,[],'omitnan'):max(tmax,[],'omitnan'))';
    nRows = length(timeVec);
    
    dataStruct = struct; %time, headings, data, name
    
    currentTime = datestr(clock,30);
    if strcmp(projFile(end-15:end),'_Standalone.asim')
        projName = projFile(1:end-16);
    else
        projName = projFile;
    end
    structName = [currentTime,' ',projName];
    dataStruct.name = structName;
    dataStruct.time = timeVec;
    dataStruct.colheaders = [];
    dataStruct.data = [];
    
    for i=1:nGraphs
        try dataStruct.colheaders = [dataStruct.colheaders,dataFile(i).colheaders(columnStart(i)+1:end)];
        catch
            keyboard
        end
        %interp data
        %if ~isequal(dataFile(i).data(:,columnStart(i)),timeVec)
        
        newTimeVec = dataFile(i).data(:,columnStart(i));
        if ~isequal(size(timeVec),size(newTimeVec)) || max(abs(timeVec - newTimeVec)) > 1e-15
            fprintf('Interpolating data from graph %s.\n',graphs{i})
            %interp data
            nCols = size(dataFile(i).data,2);
            newData = NaN(nRows,nCols-2);
            for j=(columnStart(i)+1):nCols
                k = j - columnStart(i);
                try newData(:,k) = interp1(newTimeVec,dataFile(i).data(:,j),timeVec);
                catch
                    keyboard
                end
                
                if all(isnan(newData(:,k)))
                    keyboard
                end
            end
            dataStruct.data = [dataStruct.data,newData];
            
        else
            fprintf('No need to interpolate data from graph %s.\n',graphs{i})
            dataStruct.data = [dataStruct.data,dataFile(i).data(:,columnStart(i)+1:end)];
        end
        
        %concat data
    end
    
    [~,alphabeticalOrder] = sort(dataStruct.colheaders);
    dataStruct.colheaders = dataStruct.colheaders(alphabeticalOrder);
    dataStruct.data = dataStruct.data(:,alphabeticalOrder);
        
    if toSave
        if strcmp(projFile(end-15:end),'_Standalone.asim')
            saveFolder = projFile(1:end-16);
        else
            saveFolder = projFile;
        end
        saveDirectory = [currentTime,' Data ',saveFolder];
        mkdir(saveDirectory)
        
        save([saveDirectory,'\',projName],'dataStruct')
        mkdir([saveDirectory,'\',saveFolder]);
        copyfile(projFolder,[saveDirectory,'\',saveFolder]);
        
%         fExtractPlotData(figureDirectory);
%         guiExtractPlotData(true,figureDirectory);
    end
    
    
end