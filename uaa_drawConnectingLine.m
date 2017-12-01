 function img = uaa_drawConnectingLine(img, X0, Y0, X1, Y1)
        
        for n = 0:(1/round(sqrt((X1-X0)^2 + (Y1-Y0)^2))):1
            xn = round(X0 +(X1 - X0)*n);
            yn = round(Y0 +(Y1 - Y0)*n);
            img(xn,yn) = 1;
        end
    end