% A description of the conversion of the sensor output witnessed at the ADC
% input to whichever metric is required.
function retval = angleToVoltage(angle, supply=3.3)
  retval = 12e-3*supply*sin(2*angle*pi/180);
endfunction

function retval = angleToADC(angle, supply=3.3, gain=33, offset=3.3/2)
  %angleToVoltage(angle, vss)
  retval = (angleToVoltage(angle, supply)*gain + offset);
endfunction

% only this the conversion helpers within the specified ranges
% signal should not be greater then the supply
function retval = levelToAngle(signal, supply=3.3, gain=33, offset=3.3/2)
  retval = 0.5*asin((signal-offset)/(12e-3*supply*gain))*180/pi;
  printf(sprintf("arcsin(%f/%f)=%f\n\r", (signal-offset), (12e-3*supply*gain), retval*2));
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

figure(1);
plot(arrayfun(@(x) angleToVoltage(x), 0:360));
title("Sensor to sensor output")

figure(2);
plot(arrayfun(@(x) angleToADC(x), 0:360));
title("Sensor to ADC");

%figure(3);
%plot(arrayfun(@(x) levelToAngle(x), arrayfun(@(x) angleToVoltage(x), 0:360)));
%title("Angle to voltage conversion and then back to angle");

%arcsin(0.56)*0.5 = -10
