# SinteziloUI

SwiftUI knobs, rockers and parameter groups for Audio Unit parameters.

![image](Images/SinteziloUI.png)

| View | View Model | Description |
| --- | --- | --- |
| ``ParameterKnob`` | ``ParameterViewModel`` | A knob representing a discrete or continuous parameter. |
| ``ParameterRocker`` | ``ParameterViewModel`` | A toggle switch representing a parameter with two values. |
| ``ParameterGroup`` | ``ParameterGroupViewModel`` | A named group of parameter controls. |

## ParameterViewModel

For each ``AUParameter``, create a corresponding ``ParameterViewModel``. The view model
will determine an apppropriate display representation for the parameter based on the following flags.

For discrete rather than continuous values, the following flag will be respected:

| Flag | 
| ----------- | 
| ``flag_ValuesHaveStrings`` |

The following flags will be respected when scaling values between the internal parameter representation and the display representation:

| Flag | 
| ----------- |
| ``flag_DisplayLogarithmic`` | 
| ``flag_DisplayExponential`` |
| ``flag_DisplaySquared`` | 
| ``flag_DisplaySquareRoot`` |
| ``flag_DisplayCubed`` |
| ``flag_DisplayCubeRoot`` |

The following units are explicitly handled:
    
| Unit      | Description |
| ----------- | ----------- |
| ``percent``      | Shown as a percentage between the minimum and maximum values. |
| ``hertz``   | Shown as per the default formatting; will move from Hz to kHz when the value is > 1000 etc. |
| ``milliseconds`` | For values less than one second, the value in milliseconds will be shown. Otherwise, the value in seconds will be shown. |
| ``seconds`` | as per ``milliseconds`` |
| ``BPM`` | shown as "x BPM" with up to two decimal places. |
| ``midiNoteNumber`` | Shown as the note name and minus-one-based octave e.g. C#1 |

Other units whill be presented generically with up to two decimal places.
    
To provide scale labels for parameters, pass an array of points of interest which are the value units that should be used as scale labels. These will automatically be converted to display units.

## ParameterGroupViewModel

For each group of parameters, either create a view model explicitly for each parameter, or use the 
convenience ininitializer to create these automatically. In the latter case a dictionary of parameter 
addresses and corresponding arrays of points of interest can be provided for scale labelling.
