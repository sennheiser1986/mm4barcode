function values = decodeEan(binaryInput)
%decodeEan
%   values = DecodeEan(firstDigit, binaryInput) 
%   decodes binary input EAN code
%   with start, middle and stopbits
%   firstDigit = the digit before the EAN code
    global firstDigit;
    global digitLength;
    
    % input zijn cijferkes 0 en 1, omzetten naar stringvalue
    inputBytes = binaryToString(binaryInput);
%   inputBytes = '10101110110110011001100100110110111001011110101010111001011100101100110110110011100101101100101';
    
    %conventions: digit = 0 - 9
    %               bit = 0 - 1

    %the digit in front of the barcode
    firstDigit = guessFirstDigit(inputBytes);  
    digitLength = 7; %number of bytes per char
    
    %01 - 03
    %start  = 101 

    %04 - 45  1       8       15      22      29      36
    %part 1 = 0111011 0110011 0011001 0011011 0111001 0111101

    %46 - 50
    %middle = 01010

    %51 - 92  43      50      57      64      71      78
    %part 2 = 1110010 1110010 1100110 1101100 1110010 1101100

    %93 - 95
    %end    = 101
    %               0        10        20        30        40        50        60        70       80        90
    %               12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345         
    %inputBytes  = '10101110110110011001100100110110111001011110101010111001011100101100110110110011100101101100101';
   

    % blue color map
    colorLmap = containers.Map({'0001101', '0011001', '0010011', ...
    '0111101', '0100011', '0110001', '0101111', ...
    '0111011', '0110111',  '0001011'}, ... 
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9});

    %green color map
    colorGmap = containers.Map({'0100111', '0110011', '0011011', ...
    '0100001', '0011101', '0111001', '0000101', ...
    '0010001', '0001001', '0010111'}, ...
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9});

    % red color map
    colorRmap = containers.Map({'1110010', '1100110', '1101100', ... 
    '1000010', '1011100', '1001110', '1010000', ...
    '1000100', '1001000', '1110100'}, ... 
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9});

  
    startStr  = inputBytes(1:3); %start guard bits
    hInputStr = [inputBytes(4:45), inputBytes(51:92)]; %actual data
    middleStr = inputBytes(46:50); %middle guard bits
    endStr    = inputBytes(93:95); %stop guard bits

    valLen = length(hInputStr) / digitLength; %length of the decoded number
    values = zeros(1,valLen + 1); %store decoded number here, with start digit
    values(1) = firstDigit; %put first digit 
    
    %For loop will parse the input bits per 7 (=digitlength)
    %Every digit has it's color, which depends on the value of the very
    %first digit (the one in front of the code).
    %The color per digit can be calculated with the function below.
    %Conversion from binary to number value: look up the 7-bit
    %sequence in the right color-to-digit-map
    for( i = 1 : digitLength : length(hInputStr) )
        % i points to the first bit of each digit
        % of the barcode, this position will be used to determine the 
        % color of that digit
        color = getColor(i);
        hCode = hInputStr(i:i+6)
        
        switch color
            case 'L'
                values(convertPosition(i)+1) = colorLmap(hCode);
            case 'G'
                values(convertPosition(i)+1) = colorGmap(hCode);
            case 'R'
                values(convertPosition(i)+1) = colorRmap(hCode);
        end    
    end
  
    if(checkValidity(values))
        disp 'code is valid'
    else
        disp 'code is invalid'
    end
    
    display(formatCode(values));
    

function converted = convertPosition(position)
    global digitLength;
    converted = ceil(position/digitLength);
    
function color = getColor(position)
    global firstDigit;
    
    %source of color codes: http://en.wikipedia.org/wiki/European_Article_Number
    % 0 	LLLLLL 	RRRRRR
    % 1 	LLGLGG 	RRRRRR
    % 2 	LLGGLG 	RRRRRR
    % 3 	LLGGGL 	RRRRRR
    % 4 	LGLLGG 	RRRRRR
    % 5 	LGGLLG 	RRRRRR
    % 6 	LGGGLL 	RRRRRR
    % 7 	LGLGLG 	RRRRRR
    % 8 	LGLGGL 	RRRRRR
    % 9 	LGGLGL 	RRRRRR

    % ... = line continuation, and i know, it still looks messy
    colorCodes = char('LLLLLLRRRRRR', 'LLGLGGRRRRRR', 'LLGGLGRRRRRR', ...
    'LLGGGLRRRRRR', 'LGLLGGRRRRRR', 'LGGLLGRRRRRR', 'LGGGLLRRRRRR', ... 
    'LGLGLGRRRRRR', 'LGLGGLRRRRRR', 'LGGLGLRRRRRR');
    
    colors = colorCodes(firstDigit+1,:);
    color  = colors(convertPosition(position)); 
    
function valid = checkValidity(readableInput)
    sum = 0;

    for(i = 1:2:12)
        sum = sum + readableInput(i);
    end

    for(i = 2:2:12)
        sum = sum + 3 * readableInput(i);
    end

    checksum = 10 - mod(sum,10);

    valid = (checksum == readableInput(length(readableInput)));
    
function formatted = formatCode(readableInput)    
    firstPart = removeSpaces(num2str(readableInput(1)));
    secondPart = removeSpaces(num2str(readableInput(2:7)));
    thirdPart = removeSpaces(num2str(readableInput(8:13)));

    formatted = sprintf('%s %s %s', firstPart, secondPart, thirdPart);
    
function withoutSpaces = removeSpaces(stringIn)
    % remove all spaces from string:
    %http://www.mofeel.net/582-comp-soft-sys-matlab/98032.aspx
    stringIn(stringIn==' ') = [];
    withoutSpaces = stringIn;
    
function firstDigit = guessFirstDigit(binaryInput)
    inputBytes = binaryInput
    hInputStr = inputBytes(4:45); %first part of actual data
    oddOrEven = zeros(1,6); %one bit per 'digit', set to G if the coding is even,
                            %L when odd

    %count the number of ones per digit...
    for i = 1:1:6 % 6 digits
        numOnes = 0;
        for j = 1:1:7 % 7 bits per digit 
            position = (i - 1) * 7 + j;
            if(hInputStr(position) == '1') 
                numOnes = numOnes + 1;
            end
        end
        if(mod(numOnes,2) == 0)
            oddOrEven(i) = 'G';
        else
            oddOrEven(i) = 'L';
        end        
    end

    oddOrEven = char(oddOrEven);

    colorMap = containers.Map({'LLLLLL', 'LLGLGG', 'LLGGLG', ...
        'LLGGGL', 'LGLLGG', 'LGGLLG', 'LGGGLL', ...
        'LGLGLG', 'LGLGGL', 'LGGLGL'}, ...
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9});

    firstDigit = colorMap(oddOrEven);
   
function string = binaryToString(binaryInput)
    string = zeros(1,length(binaryInput));
    for i=1:1:length(binaryInput)
        if(binaryInput(i) == 1)
            string(i) = '1';
        else
            if(binaryInput(i) == 0)
                string(i) = '0';
            end
        end
    end
    string = char(string);




