% A description of the conversion of the sensor output witnessed at the ADC
% input to whichever metric is required.
function retval = angleToVoltage(angle, supply=3.3)
  retval = 12e-3*supply*sin(2*angle*pi/180);
endfunction

function retval = angleToADC(angle, supply=3.3, gain=33, offset=3.3/2)
  %angleToVoltage(angle, vss)
  retval = (angleToVoltage(angle, supply)*gain + offset);
endfunction

function retval = levelToAngle(signal, supply=3.3, gain=33, offset=3.3/2)
  retval = 0.5*asin((signal-offset)/(12e-3*supply*gain))*180/pi;
endfunction

function retval = valueToAngle(value, top, bottom, width=12, supply=3.3, gain=33, offset=3.3/2)
  vals = 2^width;
  % make supply*(top-bottom) a variable to save us the mathmatical op
  signal = supply*(value-bottom)/(top-bottom);
  retval = levelToAngle(signal, supply, gain, offset);
endfunction
