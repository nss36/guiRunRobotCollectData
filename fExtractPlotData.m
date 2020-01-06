function [success] = fExtractPlotData(varargin)
    
    if nargin == 1
        dataStruct = varargin{1};
        promptUser = true;
    else
        dataStruct = varargin{1};
        promptUser = false;
        columnsToPlot = varargin{2};
        timeRange = varargin{3};
        subplotSize = varargin{4};
        plotStyleFlag = varargin{5};
    end

    plotAnotherGraph = true;

    while plotAnotherGraph
        %%% ASK WHICH COLUMNS TO PLOT %%%
        if promptUser
            disp('The column headings are shown below.')
            for i=1:size(dataStruct.data,2)
                disp([num2str(i),': ',dataStruct.colheaders{i}]);
            end

            columnsToPlot = input('Input a vector of columns to plot together: ');
        end

        %%% ASK FOR THE START AND END TIME OF THE PLOT %%%
        if promptUser
            timeRange = input(['Over what time interval would you like the data (',num2str(dataStruct.time(1)),' - ',num2str(dataStruct.time(end)),')?: ']);
        else
            %passed by guiExtractPlotData
        end
        
        if timeRange(1) <= dataStruct.time(1)
            startInd = 1;
        else
            startInd = find(timeRange(1) >= dataStruct.time,1,'last');
        end

        if timeRange(2) >= dataStruct.time(end)
            endInd = length(dataStruct.time);
        else
            endInd = find(timeRange(2) <= dataStruct.time,1,'first');
        end

        %%% ORGANIZATION OF THE SUBPLOTS %%%
        if promptUser
            subplotSize = input('How many rows and columns would you like the plots in (1x2 vector)? ');
        else
            %passed by guiExtractPlotData
        end
        
        if length(subplotSize) == 2 && prod(subplotSize) >= length(columnsToPlot)
            rowsToPlot = subplotSize(1);
            colsToPlot = subplotSize(2);
            numSubplots = length(columnsToPlot);
        else
            warning('Subplot size is incorrect.')
            rowsToPlot = length(columnsToPlot);
            colsToPlot = 1;
            numSubplots = length(columnsToPlot);
        end

        %Now, if we wish to plot a subplot, specify the columns we want to plot
        figure;
        hold on
        
        if plotStyleFlag == 0
            for i=1:numSubplots
                subplot(rowsToPlot,colsToPlot,i)
                columnIndex = columnsToPlot(i);

                hold on

                plot(dataStruct.time(startInd:endInd),dataStruct.data(startInd:endInd,columnIndex),'k','linewidth',1);
                grid on
                xlim(timeRange)
                title(strrep(dataStruct.colheaders{columnIndex},'_',' '));
                if i == colsToPlot
                    xlabel('Time (s)')
                end
            end
        elseif plotStyleFlag == 1
            legCell = {};
            for i=1:numSubplots
                columnIndex = columnsToPlot(i);

                hold on

                plot(dataStruct.time(startInd:endInd),dataStruct.data(startInd:endInd,columnIndex),'linewidth',1);
                grid on
                xlim(timeRange)
                legCell{i} = strrep(dataStruct.colheaders{columnIndex},'_',' '); %#ok<AGROW>
                if i == colsToPlot
                    xlabel('Time (s)')
                end
            end
            legend(legCell)
        elseif plotStyleFlag == 2
            if numSubplots == 2
                plot(dataStruct.data(startInd:endInd,columnsToPlot(1)),dataStruct.data(startInd:endInd,columnsToPlot(2)),'k','linewidth',1);
                xlabel(strrep(dataStruct.colheaders{columnsToPlot(1)},'_',' '));
                ylabel(strrep(dataStruct.colheaders{columnsToPlot(2)},'_',' '));
                grid on
                axis equal
            elseif numSubplots == 3
                plot3(dataStruct.data(startInd:endInd,columnsToPlot(1)),dataStruct.data(startInd:endInd,columnsToPlot(2)),dataStruct.data(startInd:endInd,columnsToPlot(3)),'k','linewidth',1);
                xlabel(strrep(dataStruct.colheaders{columnsToPlot(1)},'_',' '));
                ylabel(strrep(dataStruct.colheaders{columnsToPlot(2)},'_',' '));
                zlabel(strrep(dataStruct.colheaders{columnsToPlot(3)},'_',' '));
                grid on
                axis equal
            else
                warning('To use the "Versus" plot feature, you must only plot 2 or 3 columns.');
            end
        end

        if promptUser
            userPlotAnotherGraph = char(input('Would you like to plot another graph? (y/n) ','s'));

            if strcmp(userPlotAnotherGraph,'n')
                plotAnotherGraph = false;
            end
        else
            plotAnotherGraph = false;
        end
    end
    
    success = true;
end


