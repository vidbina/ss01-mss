% A description of the conversion of the sensor output witnessed at the ADC
% input to whichever metric is required.
function [a, b] = angleToVoltage(angle, supply=3.3)
  a = 12e-3*supply*sin(2*angle*pi/180);
  b = 12e-3*supply*cos(2*angle*pi/180);
endfunction

function [a, b] = angleToADC(angle, supply=3.3, gain=33, offset=3.3/2)
  [a, b] = angleToVoltage(angle, supply); %*gain + offset);
  a = a*gain+offset;
  b = b*gain+offset;
endfunction

% signal is equal to the voltage measured by the ADC
function retval = levelToAngle(signal, supply=3.3, gain=33, offset=3.3/2, sensor=1)
  if sensor == 1
    retval = 0.5*asin((signal-offset)/(12e-3*supply*gain))*180/pi;
  elseif sensor == 2
    retval = 0.5*acos((signal-offset)/(12e-3*supply*gain))*180/pi;
  else
    retval = NA
  endif
endfunction

function retval = ratioToAngle(ratio, supply=3.3, gain=33, offset=3.3/2)
  swing = 12e-3*supply*gain;
  baseline = offset-swing;
  printf(sprintf("\n\rrange is %f over baseline %f\n\r", swing, baseline));
  retval = levelToAngle(baseline+((2*swing)*(ratio)), supply, gain, offset); %0.5*asin((ratio-offset))*180/pi;
endfunction

function retval = levelOverRangeToAngle(signal, top, bottom, supply=3.3, gain=33, offset=3.3/2)
  val = (signal-bottom)/(top-bottom);
  printf(sprintf("\n\rsignal factor %f results to %f\n\r", val, val*signal));
  retval = levelToAngle(val*signal, supply=supply, gain=gain, offset=offset)
endfunction

function retval = valueToAngle(value, top, bottom, width=12, supply=3.3, gain=33, offset=3.3/2)
  retval = ratioToAngle((value-bottom)/(top-bottom), supply, gain, offset);
endfunction

function retval = valueAtoAngle(value)
  retval = valueToAngle(value, 3234, 535);
endfunction

function retval = valueBtoAngle(value)
  retval = valueToAngle(value, 3465, 986);
endfunction

range = 0:180;
supply = 3.3;
gain = 33;

figure(1);
[a_out, b_out] = arrayfun(@(x) angleToVoltage(x, 3.3), range);
plot(range, a_out, range, b_out);
xlabel('rotation in degrees');
ylabel('expected output in volts');
legend('A', 'B');
title("Sensor output");

figure(2);
%a_adc = arrayfun(@(x) angleToADC(x, supply, gain, supply/2, 1), range);
%b_adc = arrayfun(@(x) angleToADC(x, supply, gain, supply/2, 2), range);
[a_adc, b_adc] = arrayfun(@(x) angleToADC(x), range);
plot(range, a_adc, range, b_adc);
xlabel('rotation in degrees');
ylabel('expected output in volts');
legend('A', 'B');
title("Amplifier output");

figure(3);
[a_adc, b_adc] = arrayfun(@(x) angleToADC(x), range);
a_returned = arrayfun(@(x) levelToAngle(x, supply, gain, supply/2, 1), a_adc);
b_returned = arrayfun(@(x) levelToAngle(x, supply, gain, supply/2, 2), b_adc);
plot(range, range, range, a_returned, range, b_returned);
legend('actual angle', 'feedback from A', 'feedback from B');
xlabel('rotation in degrees');
ylabel('readout in degrees');
title("Angular feedback from sensors over 360 degree range");
