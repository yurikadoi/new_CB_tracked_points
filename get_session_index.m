function session_index = get_session_index(mouseID, date_of_experiment)

if strcmp(mouseID,'CB005') || strcmp(mouseID,'CB006')
    all_date_list = {'053121','060121','060221','060321', '060421','060521','060721','060821','060921','061021',...
        '061121','061221','061421','061521','061621','061721'};
    
    
    
elseif strcmp(mouseID,'CB010')
    all_date_list = {'070221','070321','070521','070621', '070721','070821','070921','071221','071321','071421',...
        '071521','071621','071721'};
    
end
session_index = find(strcmp(all_date_list,date_of_experiment));
end
