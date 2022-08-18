clc
close all
clear all

fs = 1e7;                       
Ts = 1/fs;                      
N = 1e7;                 
time_axis = (0:N-1)*Ts;

freq_axis = -fs/2:fs/N:fs/2-1/N;   
B = 100e3;
T = 2/B;                     




%% Creating Band-limited channel


one_square = ones(1,200e3);
zero_me = zeros(1,9800e3/2);
Band_limited_channel= [zero_me one_square zero_me];

figure
plot(freq_axis,Band_limited_channel,'linewidth',2)
grid on
ylim([0 2])
xlim([-1/T 1/T]*5)
xlabel('Frequency (Hz)','linewidth',2)
ylabel('Amplitude','linewidth',2)
title('The Band-limited channel in frequency domain','linewidth',10)




%% Generating first square pulse


x_bits = [1];
pulse1 = rectpuls(time_axis-1/B,T);
pulse1_length = length(pulse1);
pulse1_fft = (1/200)*fftshift(fft(pulse1));
freq_axis = -fs/2:fs/pulse1_length:fs/2-1/pulse1_length;




%% Plotting first square pulse


figure
subplot(2,1,1)
plot(time_axis,pulse1,'b','linewidth',2); hold on;
grid on
xlim([0 T*4.2])
ylim([0 2])
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)

subplot(2,1,2)
plot(freq_axis,abs(pulse1_fft),'b','linewidth',2); hold on;
grid on
ylim([0 2])
xlim([-1/T 1/T]*5)
xlabel('Frequency (Hz)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,1)
title('Square pulse before passing through channel','linewidth',10)




%% Passing first square pulse through the Band-limited channel


pulse1_after_chann = pulse1_fft .* Band_limited_channel;
pulse1_after_chann_T =100* ifft(ifftshift(pulse1_after_chann));

figure
subplot(2,1,1)
plot(time_axis,pulse1_after_chann_T,'b','linewidth',2); hold on;
grid on
xlim([0 T*5])
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)

subplot(2,1,2)
plot(freq_axis,abs(pulse1_after_chann),'b','linewidth',2); hold on;
grid on
xlim([-1/T 1/T]*5)
ylim([0 2])
xlabel('Frequency (Hz)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,1)
title('Square pulse after passing through channel','linewidth',10)




%% Generating second square pulse


x_bits = [0 1];
pulse2 = rectpuls(time_axis-3/B,T);
pulse2_length = length(pulse2);
pulse2_fft =(1/200)* fftshift(fft(pulse2));




%% Plotting the 2 square pulses


figure
subplot(2,1,1)
plot(time_axis,pulse1,'b','linewidth',2); hold on;
plot(time_axis,pulse2,'r','linewidth',2); hold on;
grid on
xlim([0 T*4.2])
ylim([0 2])
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)
title('Square pulses before passing through channel','linewidth',10)




%% Passing the 2 square pulses through the Band-limited channel


pulse2_after_chann = pulse2_fft .* Band_limited_channel;
pulse2_after_chann_T =100* ifft(ifftshift(pulse2_after_chann));

subplot(2,1,2)
plot(time_axis,pulse1_after_chann_T,'b','linewidth',2); hold on;
plot(time_axis,pulse2_after_chann_T,'r','linewidth',2); hold on;
grid on
xlim([0 T*5])
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)
title('Square pulses after passing through channel','linewidth',10)




%% creating Sinc function and passing it through the band-limited channel


time_axis = (-N/2:N/2-1)*Ts;
y = sinc(time_axis*B);
y1 = [zeros(1,10000) y(1:9990000)];
y1_length = length(y1);
y1_f = (1/100)*fftshift(fft(y1));
freq_axis = -fs/2:fs/y1_length:fs/2-1/y1_length;


figure
subplot(2,1,1)
plot(time_axis,y1,'b','linewidth',2); hold on;
xlim([0.0008 0.0012])
grid on
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,2)
plot(freq_axis,abs(y1_f),'b','linewidth',2); hold on;
xlim([-80000 80000])
grid on
xlabel('Frequency (Hz)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,1)
title('Sinc function before passing through channel','linewidth',10)


y1_after_ch = y1_f .* Band_limited_channel;
y1_after_ch_T =100* ifft(ifftshift(y1_after_ch));


figure
subplot(2,1,1)
plot(time_axis,y1_after_ch_T,'b','linewidth',2); hold on;
xlim([0.0008 0.0012])
grid on
xlabel('Time (s)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,2)
plot(freq_axis,abs(y1_after_ch),'b','linewidth',2); hold on;
xlim([-80000 80000])
grid on
xlabel('Frequency (Hz)','linewidth',2)
ylabel('Amplitude','linewidth',2)
subplot(2,1,1)
title('Sinc function after passing through channel','linewidth',10)
