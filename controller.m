function [vL, vR] = controller(err)
persistent method ctrlFun

if ischar(err)
    method = err;
    switch method
        case 'bangbang'
            ctrlFun = @bangbang;
        case 'pid'
            ctrlFun = @pidctrl;
            pidctrl();
        case 'fuzzy'
            ctrlFun = @fuzzyctrl;
            fuzzyctrl();
        case 'nn'
            ctrlFun = @nnctrl2;
            ctrlFun();
        otherwise
            error('control method can only be one of bangbang, pid, fuzzy, nn');
    end
    return
end

[vL, vR] = ctrlFun(err);

end