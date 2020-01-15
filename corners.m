function [xnew,tnew] = corners(x,t)
    if length(x) == length(t)
        xnew = x;
        tnew = t;
    else
        error('t and x must have the same length.');
    end
    
    f = figure;
    plot(t,x);
    
    i = 2;
    while i <= length(xnew)
        if abs(xnew(i) - xnew(i-1)) < 1e-12
            %If subsequent points have the same y coordinate, eliminate the
            %latter one.
            xnew(i) = [];
            tnew(i) = [];
        else
            i = i + 1;
        end
    end
    
    figure(f)
    hold on
    plot(tnew,xnew,'-+')
    legend('orig','new')
end