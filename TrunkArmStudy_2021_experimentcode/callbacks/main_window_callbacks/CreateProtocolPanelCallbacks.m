%% function declaring the callback functions for each component
function mainWindow = CreateProtocolPanelCallbacks( mainWindow )

protocolPanel = mainWindow.protocolPanel;
%protocolPanel.condition = 2;
%trialConditionsPanel = mainWindow.trialConditionsPanel;

set(protocolPanel.addPushButton,'Callback',{@addPushButton_Callback,mainWindow});
set(protocolPanel.removePushButton,'Callback',{@removePushButton_Callback,mainWindow});
set(protocolPanel.randomizePushButton,'Callback',{@randomizePushButton_Callback,mainWindow});
set(protocolPanel.valuesEditBox,'Callback',{@valuesEditBox_Callback,mainWindow});

% Set Conditions Callbacks
set(protocolPanel.condition1RadioButton,...
    'Callback',{@condition1RadioButton_Callback,mainWindow,protocolPanel});
set(protocolPanel.condition2RadioButton,...
    'Callback',{@condition2RadioButton_Callback,mainWindow,protocolPanel});
set(protocolPanel.condition3RadioButton,...
    'Callback',{@condition3RadioButton_Callback,mainWindow,protocolPanel});
set(protocolPanel.condition4RadioButton,...
    'Callback',{@condition4RadioButton_Callback,mainWindow,protocolPanel});
set(protocolPanel.condition5RadioButton,...
    'Callback',{@condition5RadioButton_Callback,mainWindow,protocolPanel});
set(protocolPanel.condition6RadioButton,...
    'Callback',{@condition6RadioButton_Callback,mainWindow,protocolPanel});

% get selection in listbox on push down
set(protocolPanel.experimentalVariablesListbox,'Callback',...
    {@experimentalVariablesListbox_Callback,mainWindow});

end


%% callbacks
function addPushButton_Callback(hObject, eventdata, mainWindow)

% Declare all possible variables in the experimental variables listbox and 
% get the current listbox string
completeString = { '% support', 'hand task'};
listboxString = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'String' );

% set the value and string to the first value if the listbox is empty
if isempty( listboxString )
    set( mainWindow.protocolPanel.experimentalVariablesListbox, 'Value', 1 );
    listboxString{1} = completeString{1};
    %set( mainWindow.protocolPanel.experimentalVariablesListbox, 'String', listboxString );
    %experimentalVariablesListbox_Callback(hObject, eventdata, mainWindow);
    %return;
else

% compare the current variable list and the complete variable list and 
% insert the missing variable that is found first
for i = 1 : length( completeString )
    match = strcmp( listboxString, completeString{i} );
    if ~any( match ) 
        listboxString{ length(listboxString) + 1 } = completeString{i};
        break;
    end
end
end
set( mainWindow.protocolPanel.experimentalVariablesListbox, 'String', listboxString );
experimentalVariablesListbox_Callback(hObject, eventdata, mainWindow);

end


function removePushButton_Callback(hObject, eventdata, mainWindow)

string = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'String' );

% end if there is nothing to remove
if ~isempty(string)
    
    value = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'Value' );
    
    % remove the selected value in the string
    string( value ) = '';

    set( mainWindow.protocolPanel.experimentalVariablesListbox, 'String', string );
    
    % set the selected item in the listbox 
    if value > length(string)
        newValue = value-1;
    else
        newValue = value;
    end
    set( mainWindow.protocolPanel.experimentalVariablesListbox, 'Value', newValue );
    
    % update the values to test box with the currently selected experimental variable. 
    % Display an empty values box if all variables have been removed.
    if newValue >= 1
        experimentalVariablesListbox_Callback(hObject, eventdata, mainWindow);
    else
        set( mainWindow.protocolPanel.valuesEditBox, 'String', '' );
    end
end

end


function randomizePushButton_Callback(hObject, eventdata, mainWindow)

% find which experimental variables remain
variablesString = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'String' );

% get values associated with each variable
userData = get( mainWindow.protocolPanel.valuesEditBox, 'userData' );
values = [];
for j = 1 : length(variablesString)
   if isempty(values)
       row = 1;
   else
       row = length(values) + 1;
   end
   switch variablesString{j}
       case '% support'
           values{row} = userData.percentSupportValuesString;
           rowLengths(j) = length(userData.percentSupportValuesString);
       case 'restraint'
           values{row} = userData.taskValuesString;
           rowLengths(j) = length(userData.taskValuesString);
%        case 'target'
%            values{row} = userData.targetValuesString;
%            rowLengths(j) = length(userData.targetValuesString);
       otherwise
           error('unidentified experimental variable - check code');
   end
end

% if there is only one experimental variable, randomize and display its
% values
if length(variablesString) == 1
    newValues = values{1};
    
elseif length(variablesString) == 2
    values1 = values{1};
    values2 = values{2};
    newValues = cell( length(values1), length(values2) );
    comma = ',';
    for i = 1 : length(values1)
        for j = 1 : length(values2)
            newValues(i,j) = strcat( values1(i), comma, values2(j) );
        end
    end
    % convert 2D array to 1D array
    newValues = reshape( newValues, prod( size(newValues) ), 1 );
    
elseif length(variablesString) == 3
    values1 = values{1};
    values2 = values{2};
    values3 = values{3};
    newValues = cell( length(values1), length(values2) );
    comma = ',';
    for i = 1 : length(values1)
        for j = 1 : length(values2)
            for k = 1 : length(values3)
                newValues(i,j,k) = strcat( values1(i), comma, values2(j), comma, values3(k) );
            end
        end
    end
    % convert 3D array to 1D array
    newValues = reshape( newValues, [ prod( size(newValues) ) 1 ] );
else
    disp('Too many or no experimental variables to randomize');
    return;
    
end

% Create new seed for randomizing, in case matlab was just opened
value = randperm(200);
if value(1) == 123
    s = RandStream.create('mt19937ar','seed',sum(100*clock));
    RandStream.setGlobalStream(s);
end

% randomize the newValues vector and display it in the values box
permutation = randperm(length(newValues));
newValues = newValues(permutation);
set(mainWindow.protocolPanel.valuesEditBox,'String',newValues);

end

function experimentalVariablesListbox_Callback(hObject, eventdata, mainWindow)

% find which experimental variable is currently selected
value = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'Value' );
variables = get( mainWindow.protocolPanel.experimentalVariablesListbox,'String');
selected = variables{value};

userData = get( mainWindow.protocolPanel.valuesEditBox, 'userData' );

switch selected
    case '% support'
        set( mainWindow.protocolPanel.valuesEditBox, 'String', userData.percentSupportValuesString );
    case 'restraint' %changed for Kacey from 'hand task' 5.30.19
        set( mainWindow.protocolPanel.valuesEditBox, 'String', userData.taskValuesString );
%     case 'target'
%         set( mainWindow.protocolPanel.valuesEditBox, 'String', userData.targetValuesString );
    otherwise
        error('unidentified experimental variable - check code');
end

end

function valuesEditBox_Callback(hObject, eventdata, mainWindow)
% 

% find which experimental variable is currently selected
value = get( mainWindow.protocolPanel.experimentalVariablesListbox, 'Value' );
variables = get( mainWindow.protocolPanel.experimentalVariablesListbox,'String');
selected = variables{value};

% get the new entered values to test and the previously stored values to test
newString = get( mainWindow.protocolPanel.valuesEditBox, 'String' );
userData = get( mainWindow.protocolPanel.valuesEditBox, 'userData' );

% replace the data in the values editbox for the corresponding experimental variable  
switch selected
    case '% support'
        userData.percentSupportValuesString = newString';
    case 'restraint' % changed for Kacey 5.30.19 from 'hand task'
        userData.viscosityValuesString = newString';
%     case 'target'
%         userData.targetValuesString = newString';
    otherwise
        error('unidentified experimental variable - check code');
end

set( mainWindow.protocolPanel.valuesEditBox, 'UserData', userData );

end

function condition1RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Home-Neutral selected');
    protocolPanel.condition = 1;
    mainWindow.protocolPanel.condition = 1;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 1)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end

function condition2RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Target-Neutral selected');
    protocolPanel.condition = 2;
    mainWindow.protocolPanel.condition = 2;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 2)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end

function condition3RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Home-Open selected');
    protocolPanel.condition = 3;
    mainWindow.protocolPanel.condition = 3;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 3)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end

function condition4RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Target-Open selected');
    protocolPanel.condition = 4;
    mainWindow.protocolPanel.condition = 4;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 4)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end
function condition5RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Home-Close selected');
    protocolPanel.condition = 5;
    mainWindow.protocolPanel.condition = 5;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 5)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end

function condition6RadioButton_Callback(hObject, eventdata, mainWindow, protocolPanel)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if (get(hObject,'Value') == get(hObject,'Max'))
	display('Target-Close selected');
    protocolPanel.condition = 6;
    mainWindow.protocolPanel.condition = 6;
    set( mainWindow.protocolPanel.conditionEditBox, 'Value', 6)
    set( mainWindow.protocolPanel.conditionEditBox, 'String', mainWindow.protocolPanel.condition );
    guidata(hObject,mainWindow.protocolPanel.condition);
end

end

