
function jumpcorrected_spout = correct_jumps(org_spout,coordinate)

jumpcorrected_spout = org_spout;
diff_jumpcorrected_spout=diff(jumpcorrected_spout);
jump_indexes = find(abs(diff_jumpcorrected_spout) > 15);
peri_perturb_JI = jump_indexes(find(jump_indexes > 450 & jump_indexes < 485));
post_perturb_JI = jump_indexes(find(jump_indexes >= 485));
pre_perturb_JI = jump_indexes(find(jump_indexes <= 450));
if strcmp(coordinate,'Y') && ~isempty(pre_perturb_JI)
    if abs(20-jumpcorrected_spout(pre_perturb_JI(1)+1)) < abs(20-jumpcorrected_spout(pre_perturb_JI(1)))
        
        jumpcorrected_spout(pre_perturb_JI(1):pre_perturb_JI(end)) = jumpcorrected_spout(pre_perturb_JI(1)+1);
    else
        jumpcorrected_spout(pre_perturb_JI(1)+1:pre_perturb_JI(end)) = jumpcorrected_spout(pre_perturb_JI(1));
        
    end
end
for i=1:length(post_perturb_JI)
    jumpcorrected_spout(post_perturb_JI(i)+1:end) = jumpcorrected_spout(post_perturb_JI(1));
end

if length(peri_perturb_JI) ==2
    num_of_points = peri_perturb_JI(2) - peri_perturb_JI(1);
    start_edge = jumpcorrected_spout(peri_perturb_JI(1));
    end_edge = jumpcorrected_spout(peri_perturb_JI(2)+1);
    increment = (end_edge - start_edge)/num_of_points;
    for j =1:num_of_points
        jumpcorrected_spout(peri_perturb_JI(1)+j) = jumpcorrected_spout(peri_perturb_JI(1)) + increment*j;
        
    end
end
if length(peri_perturb_JI) ==3
    num_of_points = peri_perturb_JI(3) - peri_perturb_JI(1);
    start_edge = jumpcorrected_spout(peri_perturb_JI(1));
    end_edge = jumpcorrected_spout(peri_perturb_JI(3)+1);
    increment = (end_edge - start_edge)/num_of_points;
    for j =1:num_of_points
        jumpcorrected_spout(peri_perturb_JI(1)+j) = jumpcorrected_spout(peri_perturb_JI(1)) + increment*j;
        
    end
end
end