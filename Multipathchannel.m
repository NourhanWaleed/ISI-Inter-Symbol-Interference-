%Transmitted signal is x
% received signal is y 
% N is the awgn noise that corrupts y
% our function is Y = HX+N where H(i) is the channel effect of the i+1
% channel and is represented by a 2D matrix of dimension L*L

%initializing variables
Eb = 1;
L = 50; %dimension of matrix, could be changed I used 5 for debugging bs momken nkabarha
H = zeros(L,L);
channel_function = exp(-0.5*[0:L-1].^2)';    %channel function that we're going to use  % e^-0.5*x^2
%channel_function = repmat(channel_function,1,1);
h = randn(L,1);  %creating an array of normally distributed numbers, mean =0, variance =1
%i added the other randn as the graph looked weird
No = [0 0.001 0.005 0.01 0.05 0.1 0.25 0.5 0.7 0.9 1]; % awgn noise 11 values
temporary_BER = [];    % initializing empty array to store the BER values inside the loop for plotting
BER = []; % initializing empty array for BER/noise
h = abs(h).*channel_function;
%filling matrix
i=1;
j = 1;
for k = 1:L
    for m = i:-1:1
        H(k,j) = h(m);
        j = j +1;
    end
    j = 1;
    i = i + 1;
end
%disp(h)
%disp(H)
%inverse_H = inv(H);   %inversing the matrix

%calculating BER
for a = No
    N = sqrt(a/2)*randn(L,1);   %calculating noise power
    for i = 1:11        %calculating the BER 11 times for each noise
        non_zero_values = setdiff(-1:1, 0);         %returning the non zero values with no repitition
        x = non_zero_values( randi(length(non_zero_values), L, 1) ); %stream of bits transmitted
        
        y = H*x' + N;        %recieved bits/ signal
        
        x_received =inv(H)*y;     %recieved bits plus noise
        D = zeros(size(x_received));    %will store bits here      
        for k = 1:L
            if x_received(k) <= 0
                D(k)= -1 ;            %polar type, if it's less than zero it's -1, if it's more it's -1
            else
                D(k) = 1;
            end
        end
        
        n = 0;
        for k = 1:L
            if D(k) ~= x(k)               %checking with initial x to calculate BER
                n = n + 1;
            end
        end
        
        
        temporary_BER = [temporary_BER n/L];    %concatenating the BERs
    end
    BER = [BER mean(temporary_BER)];    %calculating the mean BER for each noise
    temporary_BER = [];      %reseting the array for the new noise
end

plot(Eb./No, BER)
xlabel('Eb/No')
ylabel('BER')
xlim([0,100])