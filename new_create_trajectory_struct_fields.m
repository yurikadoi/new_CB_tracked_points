function fields = new_create_trajectory_struct_fields
%% prepare the empty trajcetory cell struct
body_parts = {'nose', 'R_eye', 'R_ear','R_heel', 'R_foot_mf', 'L_foot_mf', 'tail_base', 'tail_tip','R_barend','L_barend','spout','back_corner'};
coordinates = {'X', 'Y', 'LH'};

for body_parts_ind = 1:length(body_parts)
    for coordinates_ind = 1:length(coordinates)
        field_ind =3*(body_parts_ind-1) + coordinates_ind;
        % create a cell with bodyparts+coorinate names (noseX, noseY,
        % noseLH, R_eyeX, etc.)
        fields{field_ind} = [body_parts{body_parts_ind},coordinates{coordinates_ind}];
    end
end