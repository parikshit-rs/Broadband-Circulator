# Broadband-Circulator

## Objectives
- To design a broadband circulator in CST Studio Suite that works around 3.45 GHz.
- To obtain the S-parameters of the designed circulator and match terminate the ports.

## Introduction
In this project, we will focus on designing a broadband circulator that operates on
the centre frequency of 3.45GHz in CST Studio Suite. The objective of this project
is to develop a high-performance broadband circulator that can efficiently transmit
and receive signals over a wide frequency range with minimal losses. The project
will involve in-depth research, analysis, and simulation to optimize the design parameters
and ensure that the final product meets the required specifications.

## Methodology 
Ferrite materials are extensively discussed in the literature. The main parameters
given for a commercial ferrite material are magnetization saturation (4πMs usually
in Gauss), ferromagnetic resonant frequency (FMR) linewidth (H in oersted), relative
permittivity (εr), and initial relative permeability (μr).

We tried the implementation of this project on Stripline as well as Co planar waveguide structures. But unfortunately they were unsuccessful since CST was having internal errors while modeling thus we shifted to the microstrip structure which gave us success in the eighth attempt.

The methology we developed includes the following steps:

1. Define centre frequency f

2. Calculate Larmor frequency f0 about 30 % above f

3. Find the required filed f0 through H0=f0/gamma

4. Make H0=4πMs;
Pick ferrite materials with magnetisation saturation
close to found value, observe related ΔH, εr

5. With defined 4πMs, f, H0
Calculate [μ]

6. From [μ], calculate μeff

7. For a circular cavity, rf=1.84/2πfεμeff, and tf=0.1rf

9. Define substrate, make junction radius equals to rf,
Calculate wi ,li for the case section of 50Ω.

10. Perform design optimizations and matching network if needed

## Conclusion
Thus, the designed circulator is observed to work well in the frequency range
3.15GHz to 3.65GHz with all the 3 ports matched with referenece impedances
close to 47 ohms.

## References
1. L. Marzall, D. Psychogiou and Z. Popović, "Microstrip Ferrite Circulator
Design With Control of Magnetization Distribution," in IEEE Transactions
on Microwave Theory and Techniques, vol. 69, no. 2, pp. 1217-1226, Feb.
2021, doi: 10.1109/TMTT.2020.3045995.
2. C. E. Fay and R. L. Comstock, "Operation of the Ferrite Junction Circula
tor," in IEEE Transactions on Microwave Theory and Techniques, vol. 13,
no. 1, pp. 15-27, January 1965, doi: 10.1109/TMTT.1965.1125923.
3. Pozar, David M. Microwave Engineering. Hoboken, NJ :Wiley, 2012. APA

For other resources kindly look in Resources folder.
