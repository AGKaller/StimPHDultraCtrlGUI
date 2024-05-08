function [name,volume_ml,diameter_mm] = SYRINGES_DEF()
%SYRINGES_DEF List of syringes
%   This function returns a list of syringes with names, volumes and
%   diameters.
sList = { ...
    ... NAME                            VOLUME [ml]     DIAMETER [mm]
        'BRAUN_OPS_50ml'                50              28;
        'MERIT_VacLok_60ml'             60              27.06;
    };
name = sList(:,1);
volume_ml = vertcat(sList{:,2});
diameter_mm = vertcat(sList{:,3});
end

